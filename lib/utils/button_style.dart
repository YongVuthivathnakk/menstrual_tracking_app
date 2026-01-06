import 'package:flutter/material.dart';

enum ColorTheme { blue, orange }

MaterialColor getColorTheme(ColorTheme colorTheme) {
  switch (colorTheme) {
    case ColorTheme.blue:
      return Colors.blue;
    case ColorTheme.orange:
      return Colors.orange;
  }
}

class AppStyle {
  static ButtonStyle selectedButtonStyle({
    required bool isSelected,
    required ColorTheme colorTheme,
  }) {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? getColorTheme(colorTheme) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      elevation: isSelected ? 8 : 1,
      splashFactory: NoSplash.splashFactory,
      shadowColor: Colors.black54,
      backgroundColor: isSelected
          ? getColorTheme(colorTheme).shade50
          : Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
