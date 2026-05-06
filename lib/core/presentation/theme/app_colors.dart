import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Colors
  static const Color primary = Color(0xFFD96A1B); // Power Orange
  static const Color primaryDark = Color(0xFFB65516); // Pressed/Active
  static const Color primaryLight = Color(0xFFE98A3A); // Hover/Highlights

  // Backgrounds and Surfaces (Deep gym aesthetic)
  static const Color background = Color(0xFF0A0A0A); // Slightly deeper black
  static const Color surface = Color(0xFF141414); // Elevated cards
  static const Color surfaceLight = Color(0xFF1B1B1B); // Slight elevation

  // Text Colors (optimized for low-light UI)
  static const Color textPrimary = Color(0xFFE6E6E6); // High contrast
  static const Color textSecondary = Color(0xFF9E9E9E); // Subtext
  static const Color textDisabled = Color(0xFF5C5C5C); // Disabled
  static const Color textHint = Color(0xFF707070); // Input hints
  static const Color textOnPrimary = Colors.white;

  // Functional Colors (slightly toned to match strong brand)
  static const Color success = Color(0xFF19A65C); // Strong, not too neon
  static const Color warning = Color(0xFFE08E1A); // Warmer warning
  static const Color error = Color(0xFFD6453A); // Deeper, strong red
  static const Color info = Color(0xFF4DA3FF); // Clean blue

  // Component Colors
  static const Color appBar = background;
  static const Color bottomNav = Color(0xFF101010);
  static const Color drawerBackground = Color(0xFF101010);
  static const Color drawerSelected = primary;
  static const Color drawerUnselected = textSecondary;

  // Inputs & Borders
  static const Color inputBackground = Color(0xFF242424);
  static const Color inputBorder = Color(0xFF333333);
  static const Color inputFocusedBorder = primary;
  static const Color divider = Color(0xFF2E2E2E);

  // Overlays / Shadows
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color shadow = Color(0x33000000); // 20% black subtle shadow

  // SnackBar Colors (toned to brand)
  static const Color snackBarError = Color(0xFFE0624B); // Warmer red-orange
  static const Color snackBarSuccess = Color(0xFF00A98A); // Muted teal
  static const Color snackBarInfo = Color(0xFF8F47C2); // Deep, modern purple
}
