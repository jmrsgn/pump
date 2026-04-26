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

    // Get comments on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Assign post param to state post
      _postInfoViewModel.setPost(widget.post);
      _postInfoViewModel.getComments(widget.post.id);
    });

    _scrollController.addListener(() {
      final postInfoState = ref.read(postInfoViewModelProvider);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (postInfoState.hasNext && !postInfoState.isLoading) {
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
    final postInfoState = ref.watch(postInfoViewModelProvider);

    final post = postInfoState.post;

    final relativeTime = TimeUtils.timeAgo(post.createdAt);

    final topLevelComments = postInfoState.comments;

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
                itemCount: topLevelComments.length,
                itemBuilder: (context, index) {
                  final comment = topLevelComments[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentWidget(
                        comment: comment,
                        onReply: (selectedComment) {
                          // Show keyboard and focus
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
                      ),

                      (comment.repliesCount > 0 && !comment.isRepliesLoaded)
                          ? _buildCommentReplies(
                              comment: comment,
                              replies: comment.replies,
                              postId: post.id,
                            )
                          : SizedBox.shrink(),
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
                // Hide keyboard
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
  }) {
    final hasSingleReply = comment.repliesCount == 1;
    final label = hasSingleReply ? "reply" : "replies";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.dimen40,
            top: AppDimens.dimen4,
          ),
          child: InkWell(
            onTap: () {
              _postInfoViewModel.getReplies(postId, comment.id);
            },
            child: Text(
              "View ${comment.repliesCount} $label",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDisabled,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        ...replies.map(
          (reply) => Padding(
            padding: const EdgeInsets.only(left: AppDimens.dimen40),
            child: CommentWidget(comment: reply),
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
}
