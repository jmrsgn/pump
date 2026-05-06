class UpdatePostRequest {
  String title;
  String description;

  UpdatePostRequest({required this.title, required this.description});

  factory UpdatePostRequest.fromJson(Map<String, dynamic> json) {
    return UpdatePostRequest(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
