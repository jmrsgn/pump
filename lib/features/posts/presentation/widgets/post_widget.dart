import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/posts/domain/entities/post.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/utils/time_utils.dart';

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback? onPostInfoTap;
  final VoidCallback? onLikeTap;

  const PostWidget({
    super.key,
    required this.post,
    this.onPostInfoTap,
    this.onLikeTap,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget>
    with RebuildEveryMinute {
  @override
  void initState() {
    super.initState();
    startMinuteRebuild();
  }

  @override
  void dispose() {
    stopMinuteRebuild();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final relativeTime = TimeUtils.timeAgo(widget.post.createdAt);

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimens.dimen4),
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.dimen8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header user info
            Container(
              padding: const EdgeInsets.all(AppDimens.dimen4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.post.userProfileImageUrl == null ||
                          widget.post.userProfileImageUrl!.isEmpty
                      ? CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: AppDimens.dimen16,
                          child: Text(
                            widget.post.userName[0],
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage(
                            widget.post.userProfileImageUrl!,
                          ),
                          radius: AppDimens.dimen16,
                        ),

                  UiUtils.addHorizontalSpaceM(),

                  // Use Expanded to let name/status take flexible width
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.post.userName,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          relativeTime,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            UiUtils.addVerticalSpaceS(),

            _buildPostInfo(),

            UiUtils.addVerticalSpaceS(),

            // Post likes, comments and shares count
            Row(
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
                      widget.post.likesCount.toString(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onPostInfoTap,
                      child: Text(
                        '${widget.post.commentsCount} ${AppStrings.comments}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                    UiUtils.addHorizontalSpaceS(),
                    Text(
                      '${widget.post.sharesCount} ${AppStrings.shares}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            UiUtils.addVerticalSpaceL(),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLikeButton(),
                _buildCommentButton(),
                _buildShareButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInfo() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPostInfoTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.dimen4),
        child: widget.post.title.isEmpty
            ? Text(
                widget.post.description,
                style: AppTextStyles.body,
                maxLines: UIConstants.maxLines3,
                overflow: TextOverflow.ellipsis,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.title, style: AppTextStyles.heading3),
                  UiUtils.addVerticalSpaceS(),
                  Text(
                    widget.post.description,
                    style: AppTextStyles.body,
                    maxLines: UIConstants.maxLines3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLikeButton() {
    final isLikedByCurrentUser = widget.post.isLikedByCurrentUser;

    return InkWell(
      onTap: widget.onLikeTap,
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
    return GestureDetector(
      onTap: widget.onPostInfoTap,
      child: Row(
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
      ),
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
