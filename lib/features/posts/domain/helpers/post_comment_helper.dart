import '../entities/comment.dart';
import '../entities/post.dart';

class PostCommentHelper {
  PostCommentHelper._();

  // ---------------------------------------------------------------------------
  // Post helpers
  // ---------------------------------------------------------------------------
  /// Apply local like to a specific post in the list using postId
  static List<Post> applyLocalLikeToPostInList(
    List<Post> posts,
    String postId,
  ) {
    return posts.map((p) {
      if (p.id == postId) {
        return p.copyWith(
          likesCount: p.likesCount + 1,
          isLikedByCurrentUser: true,
        );
      }
      return p;
    }).toList();
  }

  /// Apply local unlike to a specific post in the list using postId
  static List<Post> applyLocalUnlikeToPostInList(
    List<Post> posts,
    String postId,
  ) {
    return posts.map((p) {
      if (p.id == postId) {
        return p.copyWith(
          likesCount: p.likesCount > 0 ? p.likesCount - 1 : 0,
          isLikedByCurrentUser: false,
        );
      }
      return p;
    }).toList();
  }

  /// Apply local like for a single post
  static Post applyLocalLikeToPost(Post post) {
    return post.copyWith(
      likesCount: post.likesCount + 1,
      isLikedByCurrentUser: true,
    );
  }

  /// Apply local unlike for a single post
  static Post applyLocalUnlikeToPost(Post post) {
    return post.copyWith(
      likesCount: post.likesCount > 0 ? post.likesCount - 1 : 0,
      isLikedByCurrentUser: false,
    );
  }

  /// Increment comments count for a specific post in a list
  static List<Post> incrementPostCommentsCountInList(
    List<Post> posts,
    String postId,
  ) {
    return posts.map((p) {
      if (p.id == postId) {
        return p.copyWith(commentsCount: p.commentsCount + 1);
      }
      return p;
    }).toList();
  }

  /// Increment comments count for a single post
  static Post incrementPostCommentsCount(Post post) {
    return post.copyWith(commentsCount: post.commentsCount + 1);
  }

  /// Replace post in list of posts
  static List<Post> replacePostInList(List<Post> posts, Post post) {
    return posts.map((p) {
      if (p.id == post.id) {
        return post;
      }
      return p;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Comment helpers
  // ---------------------------------------------------------------------------
  /// Apply local like to a specific comment in the list using commentId
  static List<Comment> applyLocalLikeToCommentInList(
    List<Comment> comments,
    String commentId,
  ) {
    return comments.map((c) {
      if (c.id == commentId) {
        return c.copyWith(
          likesCount: c.likesCount + 1,
          isLikedByCurrentUser: true,
        );
      }
      return c;
    }).toList();
  }

  /// Apply local unlike to a specific comment in the list using commentId
  static List<Comment> applyLocalUnlikeToCommentInList(
    List<Comment> comments,
    String commentId,
  ) {
    return comments.map((c) {
      if (c.id == commentId) {
        return c.copyWith(
          likesCount: c.likesCount > 0 ? c.likesCount - 1 : 0,
          isLikedByCurrentUser: false,
        );
      }
      return c;
    }).toList();
  }

  /// Add comment to existing list of comments
  static List<Comment> addCommentInList(
    List<Comment> comments,
    Comment newComment,
  ) {
    return [...comments, newComment];
  }

  /// Remove comment from existing list of comments
  static List<Comment> removeCommentInList(
    List<Comment> comments,
    Comment targetComment,
  ) {
    return comments.where((c) => c != targetComment).toList();
  }

  /// Replace comment from existing list of comments
  static List<Comment> replaceCommentInList(
    List<Comment> comments,
    Comment updatedComment,
  ) {
    return comments.map((c) {
      if (c.id == updatedComment.id) {
        return updatedComment;
      }

      if (c.replies.isNotEmpty) {
        return c.copyWith(
          replies: replaceCommentInList(c.replies, updatedComment),
        );
      }

      return c;
    }).toList();
  }

  /// Add reply to existing list of replies
  static List<Comment> addReplyInList(
    List<Comment> comments,
    String parentCommentId,
    Comment reply,
  ) {
    return comments.map((c) {
      if (c.id == parentCommentId) {
        return c.copyWith(replies: [...c.replies, reply]);
      }
      return c;
    }).toList();
  }

  /// Remove reply from existing list of replies
  static List<Comment> removeReplyInList(
    List<Comment> comments,
    String parentCommentId,
    Comment reply,
  ) {
    return comments.map((c) {
      if (c.id == parentCommentId) {
        return c.copyWith(replies: c.replies.where((r) => r != reply).toList());
      }
      return c;
    }).toList();
  }

  /// Replace temporary reply with actual reply from server
  static List<Comment> replaceReplyInList(
    List<Comment> comments,
    String parentId,
    Comment tempReply,
    Comment actualReply,
  ) {
    return comments.map((c) {
      if (c.id == parentId) {
        final replies = List<Comment>.from(c.replies);
        final index = replies.indexWhere(
          (r) => r.createdAt == tempReply.createdAt,
        );

        if (index != -1) {
          replies[index] = actualReply;
        }

        return c.copyWith(replies: replies);
      }
      return c;
    }).toList();
  }

  /// Merge existing replies with new replies
  static List<Comment> mergeReplies({
    required List<Comment> existingReplies,
    required List<Comment> newReplies,
    required bool isLoadMore,
  }) {
    if (!isLoadMore) return newReplies;

    return [
      ...existingReplies,
      ...newReplies.where((r) => !existingReplies.any((e) => e.id == r.id)),
    ];
  }
}
