import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2962FF);
  static const Color secondaryColor = Color(0xFF00B8D4);
  static const Color successColor = Color(0xFF00C853);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color onPrimaryColor = Colors.white;
  static const Color onSecondaryColor = Colors.black;
  static const Color onBackgroundColor = Color(0xFF212121);
  static const Color onSurfaceColor = Color(0xFF212121);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: onBackgroundColor,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: onBackgroundColor,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: onBackgroundColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    color: onBackgroundColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    color: onSurfaceColor,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: onPrimaryColor,
  );

  // Theme Data
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      error: errorColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: onPrimaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: onPrimaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      labelLarge: labelLarge,
    ),
  );
}

// Custom text styles for specific use cases
extension CustomTextStyles on TextTheme {
  TextStyle get cardTitle => const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppTheme.onBackgroundColor,
      );

  TextStyle get cardSubtitle => const TextStyle(
        fontSize: 14.0,
        color: Colors.grey,
      );

  TextStyle get errorText => const TextStyle(
        color: AppTheme.errorColor,
        fontSize: 14.0,
      );
}

// Custom spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
