import 'package:flutter/material.dart';
import 'package:lingora/core/platfrom.dart';

class AppDimens {
  // Spacing
  static const double spacingS = 4;
  static const double spacingM = 8;
  static const double spacingL = 16;

  static const double wrapperPadding = 24.0;
  static const double sectionBetween = 32.0;
  static const double subElementBetween = 8.0;
  static const double cardBetween = 6.0;

  // Spacing for content and titles
  static const double titleContentBetween = 24.0;
  static const double sectionSpacing = 16.0;

  // Smaller spacing values for elements
  static const double buttonTagHorizontal = 8.0;
  static const double elementBetween = 6.0;

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

  static double textSize(BuildContext context) {
    if (AppPlatform.isPhone(context)) return 16;
    if (AppPlatform.isTablet(context)) return 18;
    if (AppPlatform.isDesktop(context)) return 14;
    return 16; // fallback
  }
}
