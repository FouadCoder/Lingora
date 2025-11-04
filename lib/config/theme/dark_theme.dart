import 'package:flutter/material.dart';

import 'package:lingora/config/theme/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bgDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bgDark,
    foregroundColor: AppColors.text,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.text,
    secondary: AppColors.brandOrange,
    surface: AppColors.bg,
    onPrimary: AppColors.bgLight,
    onSecondary: AppColors.text,
    onSurface: AppColors.bgLight,
    outline: AppColors.textMuted,
    shadow: Colors.white24,
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.text,
      foregroundColor: AppColors.bgDark,
      minimumSize: const Size.fromHeight(56),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.text,
      side: const BorderSide(color: AppColors.textMuted),
      minimumSize: const Size.fromHeight(56),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  // Inputs
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textMuted, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textMuted, width: 0.5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.text, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    labelStyle: TextStyle(color: AppColors.text),
    hintStyle: TextStyle(color: AppColors.textMuted),
  ),

  // Text
  textTheme: const TextTheme(
    bodySmall: TextStyle(fontSize: 14, color: AppColors.textMuted),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.text),
    titleMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text),
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  ),

// shimmerBox(height: 26 , radius: 12); for titleMedium text
// shimmerBox(height: 20 , radius: 8);  for bodyMedium
// shimmerBox(height: 18 , radius : 6); for bodySmall
);
