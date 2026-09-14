import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/app/app_strings.dart';
import '../app_routes.dart';

enum AppMenuItem {
  coaching(
    title: AppStrings.coaching,
    icon: FontAwesomeIcons.userGroup,
    route: AppRoutes.coaching,
  ),
  profile(
    title: AppStrings.profile,
    icon: FontAwesomeIcons.user,
    route: AppRoutes.userProfile,
  ),
  messages(
    title: AppStrings.messages,
    icon: FontAwesomeIcons.message,
    route: AppRoutes.messages,
  ),
  favorites(
    title: AppStrings.likedPosts,
    icon: FontAwesomeIcons.thumbsUp,
    route: AppRoutes.likedPosts,
  ),
  contact(
    title: AppStrings.contact,
    icon: FontAwesomeIcons.envelope,
    route: AppRoutes.contact,
  ),
  feedback(
    title: AppStrings.feedback,
    icon: FontAwesomeIcons.comments,
    route: AppRoutes.feedback,
  ),
  about(
    title: AppStrings.about,
    icon: FontAwesomeIcons.circleQuestion,
    route: AppRoutes.about,
  );

  final String title;
  final FaIconData icon;
  final String route;

  const AppMenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}
