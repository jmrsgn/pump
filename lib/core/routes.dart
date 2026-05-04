import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/screens/invalid_route.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/auth/presentation/screens/login_screen.dart';
import 'package:pump/features/auth/presentation/screens/register_screen.dart';
import 'package:pump/features/chat/presentation/screens/messages.dart';
import 'package:pump/features/coaching/presentation/screens/client_overview_screen.dart';
import 'package:pump/features/coaching/presentation/screens/clients_screen.dart';
import 'package:pump/features/info/presentation/screens/contact.dart';
import 'package:pump/features/info/presentation/screens/feedback.dart';
import 'package:pump/features/posts/presentation/screens/create_post_screen.dart';
import 'package:pump/features/posts/presentation/screens/liked_posts_screen.dart';
import 'package:pump/features/posts/presentation/screens/post_info_screen.dart';

import '../features/info/presentation/screens/about.dart';
import '../features/posts/domain/entities/post.dart';
import '../features/posts/presentation/screens/main_feed_screen.dart';
import '../features/profile/presentation/screens/user_profile.dart';
import 'domain/entities/user.dart';

class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Coaching
  static const String coaching = '/coaching';
  static const String clientOverview = '/client_overview';

  // Posts
  static const String mainFeed = '/main_feed';
  static const String likedPosts = '/liked_posts';
  static const String createPost = '/create_post';
  static const String postInfo = '/post_info';

  // User
  static const String userProfile = '/user_profile';
  static const String messages = '/messages';

  // Info
  static const String contact = '/contact';
  static const String feedback = '/feedback';
  static const String about = '/about';

  /// Safely extract a User argument from RouteSettings
  static User? extractUserArg(RouteSettings settings) {
    final args = settings.arguments;
    if (args is User) return args;

    LoggerUtility.e(
      "AppRoutes",
      AppStrings.routeError,
      "Route ${settings.name} requires a User argument, got: ${args?.runtimeType}",
    );
    return null;
  }

  /// Safely extract a Post argument from RouteSettings
  static Post? extractPostArg(RouteSettings settings) {
    final args = settings.arguments;
    if (args is Post) return args;

    LoggerUtility.e(
      "AppRoutes",
      AppStrings.routeError,
      "Route ${settings.name} requires a Post argument, got: ${args?.runtimeType}",
    );
    return null;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case login:
          return MaterialPageRoute(builder: (_) => LoginScreen());
        case register:
          return MaterialPageRoute(builder: (_) => RegisterScreen());
        case coaching:
          return MaterialPageRoute(builder: (_) => const ClientsScreen());
        case clientOverview:
          return MaterialPageRoute(
            builder: (_) => const ClientOverviewScreen(),
          );
        case mainFeed:
          return MaterialPageRoute(builder: (_) => MainFeedScreen());
        case likedPosts:
          return MaterialPageRoute(builder: (_) => const LikedPostsScreen());

        case createPost:
          final user = extractUserArg(settings);
          if (user == null) {
            return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
          }
          final post = extractPostArg(settings);
          return MaterialPageRoute(
            builder: (_) => CreatePostScreen(currentUser: user, post: post),
          );

        case postInfo:
          final post = extractPostArg(settings);
          if (post == null) {
            return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
          }
          return MaterialPageRoute(builder: (_) => PostInfoScreen(post: post));

        case userProfile:
          final user = extractUserArg(settings);
          if (user == null) {
            return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
          }
          return MaterialPageRoute(
            builder: (_) => UserProfileScreen(currentUser: user),
          );

        case messages:
          return MaterialPageRoute(
            builder: (_) =>
                const MessagesScreen(titleName: "John Martin Marasigan"),
          );
        case contact:
          return MaterialPageRoute(builder: (_) => const ContactScreen());
        case feedback:
          return MaterialPageRoute(builder: (_) => const FeedbackScreen());
        case about:
          return MaterialPageRoute(builder: (_) => const AboutScreen());

        default:
          return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
      }
    } catch (e, stack) {
      LoggerUtility.e("AppRoutes", AppStrings.routeError, e.toString(), stack);
      return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
    }
  }
}
