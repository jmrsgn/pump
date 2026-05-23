class CreateCommentRequest {
  String comment;
  String userId;

  CreateCommentRequest({required this.comment, required this.userId});

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) {
    return CreateCommentRequest(
      comment: json['comment'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['userId'] = userId;
    return data;
  }
}
