import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primaryColor = Color(0xFF004E8C);
  static const secondaryColor = Color(0xFF3D8ED9);

  static const grey3 = Color(0xFFA4A4A4);

  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF004E8C),
  );

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF004E8C,
    <int, Color>{
      50: Color(0xFFE0EBF4),
      100: Color(0xFFB3CCE3),
      200: Color(0xFF80AAD0),
      300: Color(0xFF4D88BD),
      400: Color(0xFF2670AF),
      500: Color(0xFF004E8C),
      600: Color(0xFF004783),
      700: Color(0xFF003D78),
      800: Color(0xFF00356E),
      900: Color(0xFF00255B),
    },
  );
}
