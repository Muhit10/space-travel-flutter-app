import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Space theme colors
  static const Color deepSpace = Color(0xFF0A0E21);
  static const Color spaceBlue = Color(0xFF1F2A44);
  static const Color spacePurple = Color(0xFF3E1F47);
  static const Color neonBlue = Color(0xFF4FCBFF);
  static const Color neonPink = Color(0xFFFF2A6D);
  static const Color starWhite = Color(0xFFF8F8FF);
  static const Color meteorGrey = Color(0xFF9E9E9E);
  static const Color spaceGrey = Color(0xFF4A4A4A);
  static const Color marsRed = Color(0xFFD32F2F);
  static const Color moonGray = Color(0xFFBDBDBD);
  static const Color jupiterOrange = Color(0xFFFF9800);
  static const Color asteroidBrown = Color(0xFF8D6E63);
  static const Color cosmicPurple = Color(0xFF6A1B9A);
  static const Color nebulaPink = Color(0xFFEC407A);
  static const Color galaxyBlue = Color(0xFF1A237E);
  
  // Gradients
  static const LinearGradient spaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      deepSpace,
      spaceBlue,
      spacePurple,
    ],
  );
  
  static const LinearGradient glowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      neonBlue,
      neonPink,
    ],
  );
  
  // Text styles
  static TextStyle get headingLarge => GoogleFonts.orbitron(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: starWhite,
    letterSpacing: 1.5,
  );
  
  static TextStyle get headingMedium => GoogleFonts.orbitron(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: starWhite,
    letterSpacing: 1.2,
  );
  
  static TextStyle get headingSmall => GoogleFonts.orbitron(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: starWhite,
    letterSpacing: 1.0,
  );
  
  static TextStyle get titleMedium => GoogleFonts.orbitron(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: starWhite,
    letterSpacing: 0.8,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.exo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: starWhite,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.exo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: starWhite,
  );
  
  static TextStyle get bodySmall => GoogleFonts.exo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: meteorGrey,
  );
  
  static TextStyle get buttonText => GoogleFonts.orbitron(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: starWhite,
    letterSpacing: 1.0,
  );
  
  static TextStyle get captionText => GoogleFonts.exo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: starWhite,
    letterSpacing: 0.5,
  );
  
  // Theme data
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepSpace,
    primaryColor: neonBlue,
    colorScheme: const ColorScheme.dark(
      primary: neonBlue,
      secondary: neonPink,
      background: deepSpace,
      surface: spaceBlue,
      error: Colors.redAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: headingMedium,
      iconTheme: const IconThemeData(color: starWhite),
    ),
    textTheme: TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      displaySmall: headingSmall,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonBlue,
        foregroundColor: starWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: neonBlue,
        side: const BorderSide(color: neonBlue, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: neonBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    cardTheme: CardTheme(
      color: spaceBlue.withOpacity(0.7),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: spaceBlue.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: neonBlue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: neonBlue, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: meteorGrey),
      hintStyle: bodyMedium.copyWith(color: meteorGrey.withOpacity(0.7)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: spaceBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: deepSpace,
      selectedItemColor: neonBlue,
      unselectedItemColor: meteorGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: bodySmall.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: bodySmall,
    ),
    dividerTheme: const DividerThemeData(
      color: meteorGrey,
      thickness: 0.5,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: neonBlue,
      circularTrackColor: spaceBlue,
      linearTrackColor: spaceBlue,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: neonBlue,
      inactiveTrackColor: spaceBlue,
      thumbColor: neonPink,
      overlayColor: neonPink.withOpacity(0.2),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return neonPink;
        return meteorGrey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return neonBlue.withOpacity(0.5);
        return spaceBlue;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return neonBlue;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(starWhite),
      side: const BorderSide(color: neonBlue, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return neonBlue;
        return meteorGrey;
      }),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: spaceBlue,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: headingSmall,
      contentTextStyle: bodyMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: spaceBlue,
      contentTextStyle: bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: spaceBlue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: bodySmall.copyWith(color: starWhite),
    ),
  );
}