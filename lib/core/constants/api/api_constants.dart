class ApiConstants {
  ApiConstants._();

  static const Map<String, String> headerTypeJson = {
    'Content-Type': 'application/json',
  };
  static const Map<String, String> headerTypeTextPlain = {
    'Content-Type': 'text/plain',
  };

  // ---------------------------------------------------------------------------

  /**
   * http://10.0.2.2:<port> - for Android Emulator
   * http://localhost:<port> - for IOS Simulator
   */

  static const String authServiceHost = 'http://10.0.2.2:8081';

  static const String authServiceBaseUrl = '$authServiceHost/api/v1';

  static const String socialServiceHost = 'http://10.0.2.2:8080';

  static const String socialServiceBaseUrl = '$socialServiceHost/api/v1';

  static const String coachingServiceHost = 'http://10.0.2.2:8082';

  static const String coachingServiceBaseUrl = '$coachingServiceHost/api/v1';

  // ---------------------------------------------------------------------------

  // Auth service endpoints
  static const String loginUrl = "$authServiceBaseUrl/auth/login";
  static const String registerUrl = "$authServiceBaseUrl/auth/register";

  // Social service endpoints
  static const String profileUrl = "$socialServiceBaseUrl/user/profile";
  static const String postUrl = "$socialServiceBaseUrl/posts";

  static String getPostInfoUrl(String postId) => "$postUrl/$postId";

  static String getLikePostUrl(String postId) => "$postUrl/$postId/like";

  static String getCommentsUrl(String postId) => "$postUrl/$postId/comments";

  static String getCommentRepliesUrl(String postId, String commentId) =>
      "${getCommentsUrl(postId)}/$commentId/replies";

  static String getLikeCommentUrl(String postId, String commentId) =>
      "$postUrl/$postId/comments/$commentId/like";

  // Coaching service endpoints
  static const String createClientUserUrl = "$authServiceBaseUrl/users/create";
}
