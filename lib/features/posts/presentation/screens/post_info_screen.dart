import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/time_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';
import 'package:pump/features/posts/presentation/providers/post_providers.dart';
import 'package:pump/features/posts/presentation/viewmodels/post_info_viewmodel.dart';
import 'package:pump/features/posts/presentation/widgets/comment_widget.dart';

import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/app_text_input.dart';
import '../../domain/entities/comment.dart';

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

  PostInfoViewModel get _postInfoViewModel =>
      ref.read(postInfoViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    startMinuteRebuild();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postInfoViewModel.resetComments();
      _postInfoViewModel.setPost(widget.post);
      _postInfoViewModel.getComments(widget.post.id);
    });

    _scrollController.addListener(() {
      final state = ref.read(postInfoViewModelProvider);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (state.hasNext && !state.isLoading) {
          _postInfoViewModel.getComments(widget.post.id, isLoadMore: true);
        }
      }
    });
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
    final state = ref.watch(postInfoViewModelProvider);
    final post = state.post;
    final relativeTime = TimeUtils.timeAgo(post.createdAt);

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
        isLoading: state.isLoading,
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.dimen8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(post, relativeTime),
                  UiUtils.addVerticalSpaceM(),
                  _buildPostInfo(post),
                  UiUtils.addVerticalSpaceM(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLikeButton(post),
                      _buildCommentButton(),
                      _buildShareButton(),
                    ],
                  ),
                  UiUtils.addVerticalSpaceL(),
                  _buildLikesAndShares(post),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimen8,
                ),
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  final comment = state.comments[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentWidget(
                        comment: comment,
                        isReplying: state.commentReplyingTo?.id == comment.id,
                        onReply: (selectedComment) {
                          _postInfoViewModel.setCommentReplyingTo(
                            selectedComment,
                          );

                          if (!comment.isRepliesLoaded &&
                              comment.repliesCount > 0) {
                            _postInfoViewModel.getReplies(post.id, comment.id);
                          }

                          _focusNode.requestFocus();

                          _commentController.text =
                              "@${selectedComment.author} ";

                          _commentController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset: _commentController.text.length,
                                ),
                              );
                        },
                        onLikeTap: () =>
                            _postInfoViewModel.likeComment(comment.id),
                      ),
                      if (comment.repliesCount > 0 ||
                          comment.replies.isNotEmpty)
                        _buildCommentReplies(
                          comment: comment,
                          replies: comment.replies,
                          postId: post.id,
                          state: state,
                        ),
                    ],
                  );
                },
              ),
            ),
            AppTextInput(
              controller: _commentController,
              focusNode: _focusNode,
              onSend: () {
                _postInfoViewModel.createComment(
                  post.id,
                  _commentController.text.trim(),
                );
                _commentController.clear();
                _focusNode.unfocus();
              },
              onAttach: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentReplies({
    required Comment comment,
    required List<Comment> replies,
    required String postId,
    required PostInfoState state,
  }) {
    final hasSingleReply = comment.repliesCount == 1;
    final label = hasSingleReply ? "reply" : "replies";

    final text = comment.isRepliesLoaded
        ? (comment.hasMoreReplies ? "View more replies" : "No more replies")
        : "View ${comment.repliesCount} $label";

    final canLoadMore = !comment.isRepliesLoaded || comment.hasMoreReplies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comment.repliesCount > 0)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.dimen40,
              top: AppDimens.dimen4,
            ),
            child: InkWell(
              onTap: canLoadMore
                  ? () {
                      final isLoadMore =
                          comment.isRepliesLoaded && comment.hasMoreReplies;

                      _postInfoViewModel.getReplies(
                        postId,
                        comment.id,
                        isLoadMore: isLoadMore,
                      );
                    }
                  : null,
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDisabled,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        UiUtils.addVerticalSpaceS(),
        ...replies.map(
          (reply) => Padding(
            padding: const EdgeInsets.only(left: AppDimens.dimen40),
            child: CommentWidget(
              comment: reply,
              isReplying: state.commentReplyingTo?.id == reply.id,
            ),
          ),
        ),
        UiUtils.addVerticalSpaceL(),
      ],
    );
  }

  Widget _buildHeader(Post post, String relativeTime) {
    final initial = post.userName.isNotEmpty ? post.userName[0] : '?';

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: AppDimens.dimen16,
          child: Text(
            initial,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        UiUtils.addHorizontalSpaceM(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.userName,
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
        const Spacer(),
        if (post.isOwnedByCurrentUser)
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.ellipsis,
              size: AppDimens.dimen16,
            ),
            onPressed: () {
              _showPostOptions(context, post);
            },
          ),
      ],
    );
  }

  Widget _buildPostInfo(Post post) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen4),
      child: post.title.isEmpty
          ? Text(post.description, style: AppTextStyles.body)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: AppTextStyles.heading3),
                UiUtils.addVerticalSpaceS(),
                Text(post.description, style: AppTextStyles.body),
              ],
            ),
    );
  }

  Widget _buildLikesAndShares(Post post) {
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
              '${post.likesCount}',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          '${post.sharesCount} ${AppStrings.shares}',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLikeButton(Post post) {
    final isLiked = post.isLikedByCurrentUser;

    return InkWell(
      onTap: () => _postInfoViewModel.likePost(post.id),
      borderRadius: BorderRadius.circular(AppDimens.dimen4),
      child: Row(
        children: [
          Icon(
            isLiked
                ? FontAwesomeIcons.solidThumbsUp
                : FontAwesomeIcons.thumbsUp,
            size: AppDimens.dimen16,
            color: isLiked ? AppColors.info : AppColors.textDisabled,
          ),
          UiUtils.addHorizontalSpaceS(),
          Text(
            isLiked ? AppStrings.liked : AppStrings.like,
            style: AppTextStyles.bodySmall.copyWith(
              color: isLiked ? AppColors.info : AppColors.textDisabled,
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

  void _showPostOptions(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: AppColors.surface,
              leading: const Icon(
                FontAwesomeIcons.pen,
                size: AppDimens.dimen16,
              ),
              title: Text(AppStrings.editPost, style: AppTextStyles.bodySmall),
              onTap: () {
                _onEditPost(post);
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
                AppStrings.deletePost,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
              onTap: () {
                _onDeletePost();
              },
            ),
          ],
        );
      },
    );
  }

  void _onEditPost(Post post) {
    NavigationUtils.navigateTo(context, AppRoutes.createPost, arguments: post);
  }

  void _onDeletePost() {}
}
