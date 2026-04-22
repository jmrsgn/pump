import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';
import 'package:pump/features/posts/presentation/viewmodels/create_post_viewmodel.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/domain/entities/user.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/routes.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/utils/ui_utils.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final User currentUser;

  const CreatePostScreen({super.key, required this.currentUser});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CreatePostViewModel get _createPostViewModel =>
      ref.read(createPostViewModelProvider.notifier);

  void _onSubmitPost() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    _createPostViewModel.createPost(title, description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    final user = widget.currentUser;
    return user.profileImageUrl == ""
        ? CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: AppDimens.radius16,
            child: Text(
              widget.currentUser.firstName[0],
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        : CircleAvatar(
            backgroundImage: AssetImage(widget.currentUser.profileImageUrl),
            radius: AppDimens.radius16,
          );
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostViewModelProvider);

    // Listeners
    ref.listen<UiState>(createPostViewModelProvider, (previous, next) {
      final wasLoading = previous?.isLoading ?? false;
      final isFinished = wasLoading && !next.isLoading;

      if (!isFinished || !mounted) return;

      if (next.errorMessage == null) {
        UiUtils.showSnackBarSuccess(
          context,
          message: "Post created successfully",
        );

        NavigationUtils.replaceWith(context, AppRoutes.mainFeed);
      } else {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }
    });

    return CustomScaffold(
      isLoading: createPostState.isLoading,
      appBarTitle: AppStrings.createPost,
      appBarActions: [
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.paperPlane,
            size: AppDimens.dimen20,
          ),
          onPressed: createPostState.isLoading ? null : _onSubmitPost,
        ),
      ],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  _buildAvatar(),
                  UiUtils.addHorizontalSpaceS(),
                  Expanded(
                    child: Text(
                      '${widget.currentUser.firstName} ${widget.currentUser.lastName}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              UiUtils.addVerticalSpaceM(),

              // Title
              TextField(
                controller: _titleController,
                maxLines: UIConstants.maxLines1,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimens.padding8,
                  ),
                ),
                style: AppTextStyles.heading3,
              ),

              UiUtils.addVerticalSpaceS(),

              // Description
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
