class PagedResponse<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;

  PagedResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedResponse(
      content: (json['content'] as List? ?? [])
          .map((e) => fromJsonT(e))
          .toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
    );
  }
}
