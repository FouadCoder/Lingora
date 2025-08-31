import 'package:flutter/material.dart';
import 'package:lingora/core/app_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.bg,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bgLight,
    foregroundColor: AppColors.text,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.text,
    secondary: AppColors.brandOrange,
    surface: AppColors.bgLight,
    onPrimary: Colors.white,
    onSecondary: AppColors.text,
    onSurface: AppColors.text,
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

  // Cards
  cardTheme: const CardTheme(
    color: AppColors.bgLight,
    elevation: 1,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
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
    bodySmall: TextStyle(fontSize: 14, color: AppColors.textMuted),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.text),
    titleMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text),
  ),
);
