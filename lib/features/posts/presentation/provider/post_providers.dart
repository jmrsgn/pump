import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/provider/user_providers.dart';
import 'package:pump/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:pump/features/posts/domain/usecases/create_reply_usecase.dart';
import 'package:pump/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_replies_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:pump/features/posts/presentation/state/post_info_state.dart';
import 'package:pump/features/posts/presentation/viewmodels/create_post_viewmodel.dart';
import 'package:pump/features/posts/presentation/viewmodels/main_feed_viewmodel.dart';
import 'package:pump/features/posts/presentation/viewmodels/post_info_viewmodel.dart';

import '../../../../core/presentation/state/ui_state.dart';
import '../../data/repository/comment_repository_impl.dart';
import '../../data/repository/post_repository_impl.dart';
import '../../data/service/comment_service.dart';
import '../../data/service/post_service.dart';
import '../../domain/usecases/create_comment_usecase.dart';
import '../state/main_feed_state.dart';

// Services
final postServiceProvider = Provider<PostService>((ref) => PostService());
final commentServiceProvider = Provider<CommentService>(
  (ref) => CommentService(),
);

// Repositories
final postRepositoryProvider = Provider<PostRepositoryImpl>(
  (ref) => PostRepositoryImpl(
    ref.watch(postServiceProvider),
    ref.watch(userRepositoryProvider),
  ),
);

final commentRepositoryProvider = Provider<CommentRepositoryImpl>(
  (ref) => CommentRepositoryImpl(
    ref.watch(commentServiceProvider),
    ref.watch(userRepositoryProvider),
  ),
);

// UseCases
final createPostUseCaseProvider = Provider<CreatePostUseCase>(
  (ref) => CreatePostUseCase(ref.watch(postRepositoryProvider)),
);

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>(
  (ref) => UpdatePostUseCase(ref.watch(postRepositoryProvider)),
);

final createCommentUseCaseProvider = Provider<CreateCommentUseCase>(
  (ref) => CreateCommentUseCase(ref.watch(commentRepositoryProvider)),
);

final createReplyUseCaseProvider = Provider<CreateReplyUseCase>(
  (ref) => CreateReplyUseCase(ref.watch(commentRepositoryProvider)),
);

final getPostsUseCaseProvider = Provider<GetPostsUseCase>(
  (ref) => GetPostsUseCase(ref.watch(postRepositoryProvider)),
);

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>(
  (ref) => GetCommentsUseCase(ref.watch(commentRepositoryProvider)),
);

final getRepliesUseCaseProvider = Provider<GetRepliesUseCase>(
  (ref) => GetRepliesUseCase(ref.watch(commentRepositoryProvider)),
);

final likePostUseCaseProvider = Provider<LikePostUseCase>(
  (ref) => LikePostUseCase(ref.watch(postRepositoryProvider)),
);

final likeCommentUseCaseProvider = Provider<LikeCommentUseCase>(
  (ref) => LikeCommentUseCase(ref.watch(commentRepositoryProvider)),
);

final deletePostUseCaseProvider = Provider<DeletePostUseCase>(
  (ref) => DeletePostUseCase(ref.watch(postRepositoryProvider)),
);

final getAuthenticatedUserUseCaseProvider =
    Provider<GetAuthenticatedUserUseCase>(
      (ref) => GetAuthenticatedUserUseCase(ref.watch(userRepositoryProvider)),
    );

// ViewModels
final createPostViewModelProvider =
    StateNotifierProvider<CreatePostViewModel, UiState>((ref) {
      return CreatePostViewModel(
        ref.watch(createPostUseCaseProvider),
        ref.watch(updatePostUseCaseProvider),
      );
    });

final mainFeedViewModelProvider =
    StateNotifierProvider<MainFeedViewModel, MainFeedState>((ref) {
      return MainFeedViewModel(
        ref.watch(getPostsUseCaseProvider),
        ref.watch(likePostUseCaseProvider),
      );
    });

final postInfoViewModelProvider =
    StateNotifierProvider<PostInfoViewModel, PostInfoState>((ref) {
      return PostInfoViewModel(
        ref,
        ref.watch(getAuthenticatedUserUseCaseProvider),
        ref.watch(createCommentUseCaseProvider),
        ref.watch(createReplyUseCaseProvider),
        ref.watch(getCommentsUseCaseProvider),
        ref.watch(getRepliesUseCaseProvider),
        ref.watch(likePostUseCaseProvider),
        ref.watch(likeCommentUseCaseProvider),
        ref.watch(deletePostUseCaseProvider),
      );
    });
