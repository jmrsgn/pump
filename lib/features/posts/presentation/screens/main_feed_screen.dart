import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/providers/user_providers.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';
import 'package:pump/features/posts/presentation/widgets/post_widget.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class MainFeedScreen extends ConsumerStatefulWidget {
  const MainFeedScreen({super.key});

  @override
  ConsumerState<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends ConsumerState<MainFeedScreen> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(userViewModelProvider.notifier).initializeCurrentUser();
    //   ref.read(mainFeedViewModelProvider.notifier).getPosts();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // States
    final userState = ref.watch(userViewModelProvider);
    final mainFeedState = ref.watch(mainFeedViewModelProvider);

    // ViewModels
    final logoutViewModel = ref.read(logoutViewModelProvider.notifier);
    final mainFeedViewModel = ref.read(mainFeedViewModelProvider.notifier);

    final posts = mainFeedState.posts;

    // -------------------------------------------------------------------------

    return CustomScaffold(
      isLoading: userState.isLoading || mainFeedState.isLoading,
      appBarLeadingIcon: Icons.menu,
      onAppBarLeadingIconPressed: (context) {
        Scaffold.of(context).openDrawer();
      },
      backgroundColor: AppColors.background,

      drawer: userState.user == null
          ? const SizedBox.shrink()
          : AppDrawer(
              currentUser: userState.user!,
              selectedRoute: AppRoutes.mainFeed,
              onSignOut: () async {
                await logoutViewModel.logout();
                if (context.mounted) {
                  NavigationUtils.replaceWith(context, AppRoutes.login);
                }
              },
            ),

      body: RefreshIndicator.noSpinner(
        onRefresh: () async {
          await mainFeedViewModel.getPosts();
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: AppDimens.padding80),
          itemCount: 10,
          itemBuilder: (context, index) {
            final post = Post(
              id: index.toString(),
              title: "Title " + index.toString(),
              description:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eleifend odio a tempus maximus. Morbi consequat iaculis velit lobortis lobortis. Nunc nec aliquam nunc. Donec condimentum nulla at congue venenatis. Morbi scelerisque vehicula eros, sit amet viverra nibh vehicula et. Curabitur nec magna vitae enim maximus suscipit in in orci. Sed dignissim turpis vitae sodales lobortis. Mauris leo elit, tincidunt a semper vel, pharetra sit amet nisl.",
              userId: "userId",
              userName: "User Name 1",
              userProfileImageUrl: "",
              createdAt: DateTime.timestamp(),
              updatedAt: DateTime.timestamp(),
              likesCount: 0,
              commentsCount: 0,
              sharesCount: 0,
              comments: [],
              isLikedByCurrentUser: false,
            );

            return PostWidget(
              post: post,
              onLikeTap: () => mainFeedViewModel.likePost(post.id),
              onTap: () {
                NavigationUtils.navigateTo(
                  context,
                  AppRoutes.postInfo,
                  arguments: post,
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: userState.user != null
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
              onPressed: () {
                NavigationUtils.navigateTo(
                  context,
                  AppRoutes.createPost,
                  arguments: userState.user,
                );
              },
            )
          : null,
    );
  }
}
