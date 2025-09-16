import 'package:flutter/material.dart';

extension ShimmerTheme on ThemeData {
  // Shimmer colors
  Color get shimmerBase => brightness == Brightness.light
      ? Colors.grey.shade300
      : Colors.grey.shade800;

  Color get shimmerHighlight => brightness == Brightness.light
      ? Colors.grey.shade100
      : Colors.grey.shade600;

  // Suggested heights for text styles
  double get shimmerHeightTitleMedium => 26;
  double get shimmerHeightBodyMedium => 20;
  double get shimmerHeightBodySmall => 18;

  // Suggested radius for each height
  double get shimmerRadiusTitleMedium => 12;
  double get shimmerRadiusBodyMedium => 10;
  double get shimmerRadiusBodySmall => 8;
}
