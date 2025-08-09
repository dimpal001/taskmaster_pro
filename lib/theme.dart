import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants/app_color.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'FKGroteskNeueTrial',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightForeground,
      foregroundColor: Colors.black87,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightBackground,
      surfaceContainer: AppColors.lightForeground,
      onPrimary: AppColors.lightText1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'FKGroteskNeueTrial',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkBackground,
      surfaceContainer: AppColors.darkForeground,
      onPrimary: AppColors.darkText1,
    ),
  );
}
