import 'package:flutter/material.dart';
import 'package:pump/core/routes.dart';

class NavigationUtils {
  NavigationUtils._();

  static void handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  // Push a new route (keeps previous)
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  // Replace current route (no going back)
  static Future<T?> replaceWith<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  // Deletes all navigation stack and go to designated route
  static Future<T?> navigateAndRemoveAll<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Safely pops the current route and optionally returns a result
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }
}
