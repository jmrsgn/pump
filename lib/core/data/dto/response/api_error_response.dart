class ApiErrorResponse {
  final int status;
  final String error;
  final String? message;

  ApiErrorResponse({required this.status, required this.error, this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      status: json['status'],
      error: json['error'],
      message: json['message'],
    );
  }
}
