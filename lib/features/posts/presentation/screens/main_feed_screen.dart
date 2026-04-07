import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/providers/user_providers.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/post_widget.dart';

class MainFeedScreen extends ConsumerStatefulWidget {
  const MainFeedScreen({super.key});

  @override
  ConsumerState<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends ConsumerState<MainFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // Initial load
    Future.microtask(() {
      ref.read(userViewModelProvider.notifier).getAuthenticatedUser();
      ref.read(mainFeedViewModelProvider.notifier).getPosts();
    });
  }

  void _onScroll() {
    final state = ref.read(mainFeedViewModelProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (state.hasNext && !state.isLoading) {
        ref.read(mainFeedViewModelProvider.notifier).getPosts(isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
    final feedState = ref.watch(mainFeedViewModelProvider);

    final logoutVM = ref.read(logoutViewModelProvider.notifier);
    final feedVM = ref.read(mainFeedViewModelProvider.notifier);

    final posts = feedState.posts;
    final isLoading = userState.isLoading || feedState.isLoading;

    return CustomScaffold(
      isLoading: isLoading,
      backgroundColor: AppColors.background,

      appBarLeadingIcon: Icons.menu,
      onAppBarLeadingIconPressed: (context) {
        Scaffold.of(context).openDrawer();
      },

      drawer: userState.user == null
          ? const SizedBox.shrink()
          : AppDrawer(
              currentUser: userState.user!,
              selectedRoute: AppRoutes.mainFeed,
              onSignOut: () async {
                await logoutVM.logout();
                if (context.mounted) {
                  NavigationUtils.replaceWith(context, AppRoutes.login);
                }
              },
            ),

      body: RefreshIndicator.noSpinner(
        onRefresh: () async {
          await feedVM.getPosts(); // refresh resets to page 0
        },

        child: posts.isEmpty && !isLoading
            ? Center(
                child: Text(
                  "No posts available",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: AppDimens.padding80),
                itemCount: posts.length + (feedState.hasNext ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = posts[index];

                  return PostWidget(
                    post: post,
                    onTap: () => NavigationUtils.navigateTo(
                      context,
                      AppRoutes.postInfo,
                      arguments: post,
                    ),
                    onLikeTap: () => feedVM.likePost(post.id),
                  );
                },
              ),
      ),

      floatingActionButton: userState.user != null
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                NavigationUtils.navigateTo(
                  context,
                  AppRoutes.createPost,
                  arguments: userState.user,
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
