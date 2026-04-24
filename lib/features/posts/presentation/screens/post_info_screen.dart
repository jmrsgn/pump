import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/time_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';
import 'package:pump/features/posts/presentation/widgets/comment_widget.dart';

import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/app_text_input.dart';

class PostInfoScreen extends ConsumerStatefulWidget {
  final Post post;

  const PostInfoScreen({super.key, required this.post});

  @override
  ConsumerState<PostInfoScreen> createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends ConsumerState<PostInfoScreen>
    with RebuildEveryMinute {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Get all comments from server on initial load of the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postInfoViewModelProvider.notifier).getComments(widget.post.id);
    });

    startMinuteRebuild();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    stopMinuteRebuild();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final relativeTime = TimeUtils.timeAgo(widget.post.createdAt);

    final postInfoState = ref.watch(postInfoViewModelProvider);

    final comments = postInfoState.comments;

    // Listen for new comments and scroll down
    ref.listen<PostInfoState>(postInfoViewModelProvider, (previous, next) {
      final wasLoading = previous?.isLoading ?? false;
      final isFinished = wasLoading && !next.isLoading;

      if (!isFinished || !mounted) return;

      if ((previous?.comments.length != next.comments.length) &&
          next.errorMessage == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: UIConstants.milliseconds350),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isLoading: postInfoState.isLoading,
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.dimen8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(relativeTime),
                  UiUtils.addVerticalSpaceM(),
                  _buildPostInfo(),
                  UiUtils.addVerticalSpaceM(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLikeButton(),
                      _buildCommentButton(),
                      _buildShareButton(),
                    ],
                  ),
                  UiUtils.addVerticalSpaceL(),
                  _buildLikesAndShares(),
                ],
              ),
            ),

            // Only comments section is scrollable
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimen8,
                ),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final c = comments[index];

                  return Column(
                    children: [
                      CommentWidget(comment: c),
                      if (index < comments.length - 1)
                        UiUtils.addVerticalSpaceL(),
                    ],
                  );
                },
              ),
            ),

            // Input is fixed at the bottom
            AppTextInput(
              controller: _commentController,
              focusNode: _focusNode,
              onSend: () {
                ref
                    .watch(postInfoViewModelProvider.notifier)
                    .createComment(
                      _commentController.text.trim(),
                      widget.post.id,
                    );
                // Clear input field
                _commentController.clear();
              },
              onAttach: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String relativeTime) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: AppDimens.dimen16,
          child: Text(
            widget.post.userName[0],
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        UiUtils.addHorizontalSpaceM(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.userName,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              relativeTime,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen4),
      child: widget.post.title.isEmpty
          ? Text(widget.post.description, style: AppTextStyles.body)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title, style: AppTextStyles.heading3),
                UiUtils.addVerticalSpaceS(),
                Text(widget.post.description, style: AppTextStyles.body),
              ],
            ),
    );
  }

  Widget _buildLikesAndShares() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.solidThumbsUp,
              color: AppColors.info,
              size: AppDimens.dimen12,
            ),
            UiUtils.addHorizontalSpaceS(),
            Text(
              '${widget.post.likesCount}',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          '${widget.post.sharesCount} ${AppStrings.shares}',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    final isLikedByCurrentUser = widget.post.isLikedByCurrentUser;

    return InkWell(
      onTap: () =>
          ref.read(postInfoViewModelProvider.notifier).likePost(widget.post.id),
      borderRadius: BorderRadius.circular(AppDimens.dimen4),
      child: Row(
        children: [
          Icon(
            isLikedByCurrentUser
                ? FontAwesomeIcons.solidThumbsUp
                : FontAwesomeIcons.thumbsUp,
            size: AppDimens.dimen16,
            color: isLikedByCurrentUser
                ? AppColors.info
                : AppColors.textDisabled,
          ),
          UiUtils.addHorizontalSpaceS(),
          Text(
            isLikedByCurrentUser ? AppStrings.liked : AppStrings.like,
            style: AppTextStyles.bodySmall.copyWith(
              color: isLikedByCurrentUser
                  ? AppColors.info
                  : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentButton() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.comment,
          color: AppColors.textDisabled,
          size: AppDimens.dimen16,
        ),
        UiUtils.addHorizontalSpaceS(),
        Text(
          AppStrings.comment,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.share,
          color: AppColors.textDisabled,
          size: AppDimens.dimen16,
        ),
        UiUtils.addHorizontalSpaceS(),
        Text(
          AppStrings.share,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ],
    );
  }
}
