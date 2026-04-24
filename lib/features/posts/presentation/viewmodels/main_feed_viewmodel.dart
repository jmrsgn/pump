import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/main_feed_state.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../domain/helpers/post_like_helpers.dart';

class MainFeedViewModel extends BaseViewModel<MainFeedState> {
  final GetPostsUseCase _getPostsUseCase;
  final LikePostUseCase _likePostUseCase;

  MainFeedViewModel(this._getPostsUseCase, this._likePostUseCase)
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

  // getPosts ------------------------------------------------------------------
  Future<void> getPosts({bool isLoadMore = false}) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getPosts]");
    if (state.isLoading) return;

    setLoading(true);

    try {
      final nextPage = isLoadMore ? state.currentPage + 1 : 0;

      final result = await _getPostsUseCase.execute(nextPage);

      if (!result.isSuccess || result.data == null) {
        setLoading(false);
        return emitError(result.error!.message);
      }

      final paged = result.data!;

      state = state.copyWith(
        isLoading: false,
        currentPage: paged.page,
        hasNext: (paged.page + 1) * paged.size < paged.totalElements,
        posts: isLoadMore ? [...state.posts, ...paged.content] : paged.content,
        errorMessage: null,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getPosts", e, stack);
      emitUnexpectedError();
    }
  }

  // likePost (optimistic update) ----------------------------------------------
  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) {
      LoggerUtility.d(
        runtimeType.toString(),
        "Post with postId $postId not found",
      );
      return;
    }

    final originalPosts = List.of(state.posts); // backup
    final currentPost = state.posts[postIndex];
    final wasLiked = currentPost.isLikedByCurrentUser;

    // Optimistic UI update
    final updatedPosts = wasLiked
        ? PostLikeHelpers.applyLocalUnlikeToList(state.posts, postId)
        : PostLikeHelpers.applyLocalLikeToList(state.posts, postId);

    state = state.copyWith(posts: updatedPosts);

    try {
      final result = await _likePostUseCase.execute(postId);

      if (!result.isSuccess || result.data == null) {
        // rollback correctly
        state = state.copyWith(posts: originalPosts);
        return emitError(result.error?.message ?? "Like post failed");
      }

      final updatedPost = result.data!;
      final newPosts = List.of(state.posts);

      final safeIndex = newPosts.indexWhere((p) => p.id == updatedPost.id);
      // If post not found, silent ignore
      if (safeIndex != -1) {
        newPosts[safeIndex] = updatedPost;
      }

      state = state.copyWith(posts: newPosts, errorMessage: null);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);
      // rollback correctly
      state = state.copyWith(posts: originalPosts);
      emitUnexpectedError();
    }
  }
}
