class AppErrorStrings {
  AppErrorStrings._();

  // Generic
  static const anUnexpectedErrorOccurred = "An unexpected error occurred";

  // Auth
  static const userLoginFailed = "User login failed";
  static const userRegistrationFailed = "User registration failed";
  static const tokenIsMissingWillNotProceedWithApiCall =
      "Token is missing, will not proceed with API call";
  static const userIsNotAuthenticated = "User is not authenticated";
  static const userIsMissing = "User is missing";

  // Posts
  static const postDescriptionIsRequired = "Post description is required";
}
