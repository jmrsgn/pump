import '../../../../core/presentation/state/ui_state.dart';
import '../../domain/entity/post.dart';

class MainFeedState extends UiState {
  final List<Post> posts;
  final Post post;
  final int currentPage;
  final bool hasNext;
  final String? successMessage;

  const MainFeedState({
    required super.isLoading,
    super.errorMessage,
    required this.posts,
    required this.post,
    required this.currentPage,
    required this.hasNext,
    this.successMessage,
  });

  @override
  MainFeedState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Post>? posts,
    Post? post,
    int? currentPage,
    bool? hasNext,
    String? successMessage,
  }) {
    return MainFeedState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      posts: posts ?? this.posts,
      post: post ?? this.post,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  factory MainFeedState.initial() {
    return MainFeedState(
      isLoading: false,
      errorMessage: null,
      posts: const [],
      post: Post.empty(),
      currentPage: 0,
      hasNext: true,
      // Assume more data initially
      successMessage: null,
    );
  }
}
