import 'package:flutter/material.dart';

class AppConstants {
  // App information
  static const String appName = 'Flutter Space Travel App';
  static const String appVersion = '1.0.0';
  
  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 3000);
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);
  
  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeInOutCubic;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusCircular = 100.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;
  
  // Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  // Button sizes
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
  
  // Card sizes
  static const double cardWidthS = 120.0;
  static const double cardWidthM = 160.0;
  static const double cardWidthL = 240.0;
  static const double cardWidthXL = 320.0;
  
  static const double cardHeightS = 160.0;
  static const double cardHeightM = 200.0;
  static const double cardHeightL = 280.0;
  static const double cardHeightXL = 360.0;
  
  // Text constants
  static const String splashText = 'Embark on an Interstellar Journey';
  static const String welcomeTitle = 'Welcome, Explorer';
  static const String welcomeSubtitle = 'Your gateway to the cosmos awaits';
  
  // Navigation routes
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String planetDetailRoute = '/planet-detail';
  static const String bookMissionRoute = '/book-mission';
  static const String missionProgressRoute = '/mission-progress';
  static const String settingsRoute = '/settings';
  
  // Planet data
  static const List<String> planetNames = [
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune',
    'Kepler-186f',
    'TRAPPIST-1e',
    'HD 209458 b',
    'Proxima Centauri b',
  ];
  
  // Mission types
  static const List<String> missionTypes = [
    'Orbital Tour',
    'Surface Expedition',
    'Research Mission',
    'Colonization Project',
    'Mining Operation',
    'Luxury Cruise',
  ];
}