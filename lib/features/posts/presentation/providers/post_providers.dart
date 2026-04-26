import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/providers/user_providers.dart';
import 'package:pump/features/posts/data/services/comment_service.dart';
import 'package:pump/features/posts/data/services/post_service.dart';
import 'package:pump/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_replies_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/main_feed_state.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';
import 'package:pump/features/posts/presentation/viewmodels/create_post_viewmodel.dart';
import 'package:pump/features/posts/presentation/viewmodels/main_feed_viewmodel.dart';
import 'package:pump/features/posts/presentation/viewmodels/post_info_viewmodel.dart';

import '../../../../core/presentation/providers/ui_state.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/usecases/create_comment_usecase.dart';

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

final createCommentUseCaseProvider = Provider<CreateCommentUseCase>(
  (ref) => CreateCommentUseCase(ref.watch(commentRepositoryProvider)),
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

final getAuthenticatedUserUseCaseProvider =
    Provider<GetAuthenticatedUserUseCase>(
      (ref) => GetAuthenticatedUserUseCase(ref.watch(userRepositoryProvider)),
    );

// ViewModels
final createPostViewModelProvider =
    StateNotifierProvider<CreatePostViewModel, UiState>((ref) {
      return CreatePostViewModel(ref.watch(createPostUseCaseProvider));
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
        ref.watch(getCommentsUseCaseProvider),
        ref.watch(getRepliesUseCaseProvider),
        ref.watch(likePostUseCaseProvider),
      );
    });
