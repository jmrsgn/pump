import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/main_feed_state.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../domain/helpers/post_like_helpers.dart';

class MainFeedViewmodel extends BaseViewmodel<MainFeedState> {
  final GetPostsUseCase _getPostsUseCase;
  final LikePostUseCase _likePostUseCase;

  MainFeedViewmodel(this._getPostsUseCase, this._likePostUseCase)
    : super(MainFeedState.initial());

  @override
  MainFeedState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void incrementCommentCount(String postId) {
    state = state.copyWith(
      posts: state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(commentsCount: post.commentsCount + 1);
        }
        return post;
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // getPosts
  // ---------------------------------------------------------------------------

  Future<void> getPosts() async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getPosts]");

    if (state.isLoading) return;

    setLoading(true);

    try {
      final response = await _getPostsUseCase.execute();

      if (!response.isSuccess) {
        return emitError(response.error!.message);
      }

      state = state.copyWith(
        isLoading: false,
        posts: response.data,
        errorMessage: null,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getPosts", e, stack);
      emitUnexpectedError();
    }
  }

  // ---------------------------------------------------------------------------
  // likePost (optimistic update)
  // ---------------------------------------------------------------------------

  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final currentPost = state.posts[postIndex];
    final wasLiked = currentPost.isLikedByCurrentUser;

    // Optimistic UI update
    final updatedPosts = wasLiked
        ? PostLikeHelpers.applyLocalUnlikeToList(state.posts, postId)
        : PostLikeHelpers.applyLocalLikeToList(state.posts, postId);

    state = state.copyWith(posts: updatedPosts);

    try {
      final response = await _likePostUseCase.execute(postId);

      if (!response.isSuccess) {
        // rollback on failure
        state = state.copyWith(posts: state.posts);
        return emitError(response.error!.message);
      }

      final updatedPost = response.data!;

      final newPosts = [...state.posts];
      newPosts[postIndex] = updatedPost;

      state = state.copyWith(posts: newPosts, errorMessage: null);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);

      // rollback on crash
      state = state.copyWith(posts: state.posts);

      emitUnexpectedError();
    }
  }
}
