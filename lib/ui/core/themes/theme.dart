import 'package:flutter/material.dart';
import 'package:todos_app/ui/core/themes/colors.dart';

abstract final class AppTheme {
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey3,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.grey3,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.grey3,
    ),
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.grey3,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: _appBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    segmentedButtonTheme: _segmentedButtonTheme,
    checkboxTheme: _checkboxTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    scaffoldBackgroundColor: AppColors.primarySwatch[50],
  );

  static const _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  );

  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  );

  static final _segmentedButtonTheme = SegmentedButtonThemeData(
    style: ButtonStyle(
      side: WidgetStateProperty.all(BorderSide.none),
      backgroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryColor;
          }
          return Colors.grey[300]!;
        },
      ),
      foregroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.grey;
        },
      ),
    ),
  );

  static const _checkboxTheme = CheckboxThemeData(
    side: BorderSide(
      color: Colors.grey,
      width: 2,
    ),
  );
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) {
          return Colors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryColor.withAlpha(150);
          }

          return AppColors.primaryColor;
        },
      ),
    ),
  );
}
