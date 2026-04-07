import 'package:pump/core/presentation/providers/ui_state.dart';

import '../../domain/entities/post.dart';

class MainFeedState extends UiState {
  final List<Post> posts;
  final Post post;
  final int currentPage;
  final bool hasNext;

  const MainFeedState({
    required super.isLoading,
    super.errorMessage,
    required this.posts,
    required this.post,
    required this.currentPage,
    required this.hasNext,
  });

  @override
  MainFeedState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Post>? posts,
    Post? post,
    int? currentPage,
    bool? hasNext,
  }) {
    return MainFeedState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      posts: posts ?? this.posts,
      post: post ?? this.post,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  factory MainFeedState.initial() {
    return MainFeedState(
      isLoading: false,
      errorMessage: null,
      posts: const [],
      post: Post.empty(),
      currentPage: 0,
      hasNext: true, // Assume more data initially
    );
  }
}
