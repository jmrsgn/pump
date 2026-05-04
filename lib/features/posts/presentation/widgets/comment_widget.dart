import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/utils/time_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../domain/entities/comment.dart';

class CommentWidget extends ConsumerStatefulWidget {
  final Comment comment;
  final void Function(Comment comment)? onReply;
  final bool isReplying;
  final VoidCallback? onLikeTap;

  const CommentWidget({
    super.key,
    required this.comment,
    this.onReply,
    this.isReplying = false,
    this.onLikeTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends ConsumerState<CommentWidget>
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
    final relativeTime = TimeUtils.timeAgo(widget.comment.createdAt);
    final isLikedByCurrentUser = widget.comment.isLikedByCurrentUser;

    return GestureDetector(
      // Makes the entire rectangular area clickable
      behavior: HitTestBehavior.opaque,
      onLongPress: widget.comment.isOwnedByCurrentUser
          ? () => _showCommentOptions(context)
          : null,
      onSecondaryTap: widget.comment.isOwnedByCurrentUser
          ? () => _showCommentOptions(context)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            widget.comment.authorProfileImageUrl == null ||
                    widget.comment.authorProfileImageUrl!.isEmpty
                ? CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: AppDimens.dimen16,
                    child: Text(
                      widget.comment.author[0],
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: AssetImage(
                      widget.comment.authorProfileImageUrl!,
                    ),
                    radius: AppDimens.dimen16,
                  ),

            UiUtils.addHorizontalSpaceM(),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.author,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                      height: AppDimens.textHeight1,
                    ),
                  ),
                  UiUtils.addVerticalSpaceS(),
                  Text(
                    widget.comment.comment,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  UiUtils.addVerticalSpaceXS(),
                  Row(
                    children: [
                      Text(
                        relativeTime,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                      UiUtils.addHorizontalSpaceXL(),
                      InkWell(
                        onTap: () => widget.onReply?.call(widget.comment),
                        child: Text(
                          AppStrings.reply,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: widget.onLikeTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.comment.likesCount.toString(),
                              style: AppTextStyles.caption,
                            ),
                            UiUtils.addHorizontalSpaceS(),
                            Icon(
                              isLikedByCurrentUser
                                  ? FontAwesomeIcons.solidThumbsUp
                                  : FontAwesomeIcons.thumbsUp,
                              size: AppDimens.dimen16,
                              color: isLikedByCurrentUser
                                  ? AppColors.info
                                  : AppColors.textDisabled,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: AppColors.surface,
                leading: const Icon(
                  FontAwesomeIcons.pen,
                  size: AppDimens.dimen16,
                ),
                title: Text(
                  AppStrings.editComment,
                  style: AppTextStyles.bodySmall,
                ),
                onTap: () {
                  _onEditComment();
                },
              ),
              ListTile(
                tileColor: AppColors.surface,
                leading: const Icon(
                  FontAwesomeIcons.trash,
                  size: AppDimens.dimen16,
                  color: AppColors.error,
                ),
                title: Text(
                  AppStrings.deleteComment,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  _onDeleteComment();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onEditComment() {}

  void _onDeleteComment() {}
}
