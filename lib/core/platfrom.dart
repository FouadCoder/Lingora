import 'package:flutter/material.dart';

class AppPlatform {
  // Is Desktop
  static bool isDesktop(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 1000;
  }

  // Is Tablet
  static bool isTablet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600 && screenWidth <= 1000;
  }

// Is Phone
  static bool isPhone(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth <= 600;
  }
}
