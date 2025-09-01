import 'package:flutter/material.dart';
import 'package:lingora/core/platfrom.dart';

class AppDimens {
  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 12;
  static const double spacingL = 16;
  static const double spacingXL = 24;
  static const double spacingXXL = 32;

  // Container padding
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  // Border radius
  static const double radiusS = 4;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusXL = 16;
  static const double radiusXXL = 24;

  // Icon sizes
  static const double iconS = 16;
  static const double iconM = 20;
  static const double iconL = 24;
  static const double iconXL = 32;
}

class AppButtonSizes {
  static double height(BuildContext context) {
    if (AppPlatform.isPhone(context)) return 48;
    if (AppPlatform.isTablet(context)) return 56;
    if (AppPlatform.isDesktop(context)) return 40;
    return 48; // fallback
  }

  static double width(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (AppPlatform.isPhone(context)) return screenWidth; // full width
    if (AppPlatform.isTablet(context)) return 300;
    if (AppPlatform.isDesktop(context)) return 200;
    return screenWidth;
  }
}
