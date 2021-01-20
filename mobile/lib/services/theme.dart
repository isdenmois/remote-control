import 'package:flutter/material.dart';

class AppColors {
  final Color primaryColor;
  final Color background;
  final Color buttonBackground;

  AppColors({this.primaryColor, this.background, this.buttonBackground});
}

final Map<Brightness, AppColors> colorSchemes = {
  Brightness.light: AppColors(
    primaryColor: Colors.black,
    background: Colors.white,
    buttonBackground: Colors.grey[100],
  ),
  Brightness.dark: AppColors(
    primaryColor: Color(0xFFE1E1E1),
    background: Color(0xFF121212),
    buttonBackground: Color(0xFF2D2D2D),
  ),
};

class AppTheme {
  static generate(Brightness brightness) {
    final colors = colorSchemes[brightness];

    return ThemeData(
      brightness: brightness,
      backgroundColor: colors.background,
      primaryColor: colors.primaryColor,
      scaffoldBackgroundColor: colors.background,
      buttonColor: colors.buttonBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: colors.buttonBackground,
          onPrimary: colors.primaryColor,
        ),
      ),
    );
  }

  static light() => generate(Brightness.light);
  static dark() => generate(Brightness.dark);
}
