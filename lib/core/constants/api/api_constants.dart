class ApiConstants {
  ApiConstants._();

  static const Map<String, String> headerType = {
    'Content-Type': 'application/json',
  };
  static const String authServiceBaseUrl =
      'http://10.0.2.2:8081/api/v1'; // for Android emulator
  static const String socialServiceBaseUrl =
      'http://10.0.2.2:8081/api/v1'; // for Android emulator
  // For iOS simulator, use http://localhost:8080/api/v1

  // Auth
  static const String loginUrl = "$authServiceBaseUrl/auth/login";
  static const String registerUrl = "$authServiceBaseUrl/auth/register";

  // Profile
  static const String profileUrl = "$socialServiceBaseUrl/user/profile";

  // Post
  static const String postUrl = "$socialServiceBaseUrl/post";

  static String getLikePostUrl(String postId) => "$postUrl/$postId/like";

  // Comment
  static String getCommentUrl(String postId) => "$postUrl/$postId/comment";
}
