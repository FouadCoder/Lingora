import 'package:flutter/material.dart';
import 'package:lingora/core/app_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBgDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBgDark,
    foregroundColor: AppColors.text,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightText,
    onPrimary: AppColors.lightBgLight,
    secondary: AppColors.brandOrange,
    surface: AppColors.lightBg,
    onSecondary: AppColors.text,
    onSurface: AppColors.bg,
    outline: AppColors.textMuted,
    shadow: Colors.black12,
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandOrange,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.brandOrange,
      side: const BorderSide(color: AppColors.brandOrange, width: 1.5),
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
      borderSide: BorderSide(color: AppColors.brandOrange, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    labelStyle: TextStyle(color: AppColors.text),
    hintStyle: TextStyle(color: AppColors.textMuted),
  ),

  // Text
  textTheme: const TextTheme(
    bodySmall: TextStyle(fontSize: 14, color: AppColors.lightTextMuted),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.lightText),
    titleMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightText),
  ),

// shimmerBox(height: 26); for titleMedium text
// shimmerBox(height: 20);  for bodyMedium
// shimmerBox(height: 18); for bodySmall
);
