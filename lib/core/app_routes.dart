import 'package:flutter/material.dart';
import 'package:pump/core/presentation/screens/invalid_route.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/auth/presentation/screens/login_screen.dart';
import 'package:pump/features/auth/presentation/screens/register_screen.dart';
import 'package:pump/features/chat/presentation/screens/messages.dart';
import 'package:pump/features/coaching/presentation/screens/client_overview_screen.dart';
import 'package:pump/features/coaching/presentation/screens/payment_method_screen.dart';
import 'package:pump/features/coaching/presentation/screens/my_coach_screen.dart';
import 'package:pump/features/coaching/presentation/screens/clients_screen.dart';
import 'package:pump/features/coaching/presentation/screens/coaching_screen.dart';
import 'package:pump/features/info/presentation/screens/contact_screen.dart';
import 'package:pump/features/info/presentation/screens/feedback_screen.dart';
import 'package:pump/features/posts/presentation/screens/create_post_screen.dart';
import 'package:pump/features/posts/presentation/screens/liked_posts_screen.dart';
import 'package:pump/features/posts/presentation/screens/post_info_screen.dart';
import 'package:pump/features/coaching/presentation/screens/create_training_block_screen.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';

import '../features/coaching/presentation/screens/enroll_client_screen.dart';
import '../features/info/presentation/screens/about_screen.dart';
import '../features/posts/domain/entity/post.dart';
import '../features/posts/presentation/screens/main_feed_screen.dart';
import '../features/profile/presentation/screens/user_profile.dart';
import 'domain/entity/user.dart';

class AppRoutes {
  AppRoutes._();

  static const String _debugTag = 'AppRoutes';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Coaching
  static const String coaching = '/coaching';
  static const String clientOverview = '/client_overview';
  static const String enrollClient = '/enroll_client';
  static const String myCoach = '/my_coach';
  static const String paymentMethod = '/payment_method';
  static const String clients = '/clients';
  static const String createTrainingBlock = '/create_training_block';

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
      _debugTag,
      "Route ${settings.name} requires a User argument, got: ${args?.runtimeType}",
    );
    return null;
  }

  /// Safely extract a Post argument from RouteSettings
  static Post? extractPostArg(RouteSettings settings) {
    final args = settings.arguments;
    if (args is Post) return args;

    LoggerUtility.e(
      _debugTag,
      "Route ${settings.name} requires a Post argument, got: ${args?.runtimeType}",
    );
    return null;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        // ---------------------------------------------------------------------------
        // Auth
        // ---------------------------------------------------------------------------
        case login:
          return MaterialPageRoute(builder: (_) => LoginScreen());
        case register:
          return MaterialPageRoute(builder: (_) => RegisterScreen());

        // ---------------------------------------------------------------------------
        // Coaching
        // ---------------------------------------------------------------------------
        case coaching:
          return MaterialPageRoute(builder: (_) => CoachingScreen());
        case clientOverview:
          final client = settings.arguments as ClientUser;

          return MaterialPageRoute(
            builder: (_) => ClientOverviewScreen(client: client),
          );
        case enrollClient:
          return MaterialPageRoute(builder: (_) => const EnrollClientScreen());
        case clients:
          return MaterialPageRoute(builder: (_) => const ClientsScreen());
        case myCoach:
          return MaterialPageRoute(builder: (_) => const MyCoachScreen());
        case paymentMethod:
          return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
        case createTrainingBlock:
          final args = settings.arguments;

          if (args is! CreateTrainingBlockArgs) {
            return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
          }

          return MaterialPageRoute(
            builder: (_) => CreateTrainingBlockScreen(
              clientName: args.clientName,
              clientAge: args.clientAge,
              clientGender: args.clientGender,
              clientHeight: args.clientHeight,
              clientCurrentWeight: args.clientCurrentWeight,
              clientGoalWeight: args.clientGoalWeight,
              clientFitnessGoal: args.clientFitnessGoal,
            ),
          );

        // ---------------------------------------------------------------------------
        // Social
        // ---------------------------------------------------------------------------
        case mainFeed:
          return MaterialPageRoute(builder: (_) => MainFeedScreen());
        case likedPosts:
          return MaterialPageRoute(builder: (_) => const LikedPostsScreen());
        case createPost:
          final post = extractPostArg(settings);
          return MaterialPageRoute(
            builder: (_) => CreatePostScreen(post: post),
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

        // ---------------------------------------------------------------------------
        // Info
        // ---------------------------------------------------------------------------
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
      LoggerUtility.e(_debugTag, e.toString(), stack);
      return MaterialPageRoute(builder: (_) => InvalidRouteScreen());
    }
  }
}

// FOR NOW
class CreateTrainingBlockArgs {
  final String clientName;
  final int clientAge;
  final String clientGender;
  final double clientHeight;
  final double clientCurrentWeight;
  final double clientGoalWeight;
  final String clientFitnessGoal;

  const CreateTrainingBlockArgs({
    required this.clientName,
    required this.clientAge,
    required this.clientGender,
    required this.clientHeight,
    required this.clientCurrentWeight,
    required this.clientGoalWeight,
    required this.clientFitnessGoal,
  });
}
