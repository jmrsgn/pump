import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/domain/entities/user.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';
import 'package:pump/features/posts/presentation/viewmodels/create_post_viewmodel.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../../../core/presentation/providers/user_providers.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/routes.dart';
import '../../../../core/utils/image_picker_utils.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../domain/entities/post.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final Post? post;

  const CreatePostScreen({super.key, this.post});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  CreatePostViewModel get _createPostViewModel =>
      ref.read(createPostViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _descriptionController.text = widget.post!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onUploadImage() async {
    final image = await ImagePickerUtils.pickImageFromGallery();

    if (image == null) return;

    setState(() {
      _selectedImage = image;
    });
  }

  Widget _buildAvatar(User user) {
    return user.profileImageUrl.isEmpty
        ? CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            radius: AppDimens.dimen16,
            child: Text(
              user.firstName[0],
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          )
        : CircleAvatar(
            backgroundImage: AssetImage(user.profileImageUrl),
            radius: AppDimens.dimen16,
          );
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostViewModelProvider);
    final userState = ref.watch(userViewModelProvider);
    final user = userState.user!;

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
      appBarTitle: widget.post == null
          ? AppStrings.createPost
          : AppStrings.editPost,
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.dimen10,
            vertical: AppDimens.dimen16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAvatar(user),

                          UiUtils.addHorizontalSpaceM(),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                UiUtils.addVerticalSpaceXS(),

                                Text(
                                  widget.post == null
                                      ? AppStrings.creatingANewPost
                                      : AppStrings.editingYourPost,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.dimen10,
                              vertical: AppDimens.dimen6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              AppStrings.public,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      UiUtils.addVerticalSpaceXL(),

                      // Title field
                      TextField(
                        controller: _titleController,
                        maxLines: UIConstants.maxLines1,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppStrings.whatsOnYourMind,
                          hintStyle: AppTextStyles.heading3.copyWith(
                            color: AppColors.textDisabled,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTextStyles.heading3,
                      ),

                      if (_selectedImage != null) ...[
                        UiUtils.addVerticalSpaceS(),

                        Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),

                        UiUtils.addVerticalSpaceM(),
                      ],

                      // Description field
                      TextField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: AppStrings.postDescriptionHint,
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textDisabled,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed:
                              true, // Prevent removing of space when description is too long
                        ),
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
              ),
              _buildImagePickerButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitPost() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (widget.post == null) {
      _createPostViewModel.createPost(title, description);
    } else {
      _createPostViewModel.updatePost(widget.post!.id, title, description);
    }
  }

  Widget _buildImagePickerButton() {
    // Upload image button
    return AnimatedSwitcher(
      duration: Duration(milliseconds: UIConstants.milliseconds180),
      child: MediaQuery.of(context).viewInsets.bottom > 0
          ? Container(
              key: const ValueKey("keyboard_toolbar"),
              padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen12),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(AppDimens.dimen12),
                    onTap: _onUploadImage,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimens.dimen10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppDimens.dimen12),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.primary,
                        size: AppDimens.dimen20,
                      ),
                    ),
                  ),

                  UiUtils.addHorizontalSpaceM(),

                  Expanded(
                    child: Text(
                      AppStrings.addImagesToYourPost,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
