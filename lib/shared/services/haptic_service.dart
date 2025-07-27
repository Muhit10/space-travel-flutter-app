import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
  success,
  error,
  warning,
}

class HapticService {
  // Singleton instance
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();
  
  // User preferences
  late UserPreferencesProvider _preferences;
  
  // Initialize with preferences
  void initialize(UserPreferencesProvider preferences) {
    _preferences = preferences;
  }
  
  // Trigger haptic feedback
  Future<void> feedback(HapticFeedbackType type) async {
    // Check if haptics are enabled
    if (!_preferences.hapticsEnabled) return;
    
    try {
      switch (type) {
        case HapticFeedbackType.light:
          await HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selection:
          await HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.success:
          // Custom pattern for success
          await HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 50));
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.error:
          // Custom pattern for error
          await HapticFeedback.heavyImpact();
          await Future.delayed(const Duration(milliseconds: 100));
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.warning:
          // Custom pattern for warning
          await HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 100));
          await HapticFeedback.lightImpact();
          break;
      }
    } catch (e) {
      debugPrint('Error triggering haptic feedback: $e');
    }
  }
  
  // Vibrate with custom pattern
  Future<void> vibrate(List<int> pattern) async {
    // Check if haptics are enabled
    if (!_preferences.hapticsEnabled) return;
    
    try {
      // Implement custom vibration pattern
      for (int i = 0; i < pattern.length; i++) {
        if (i % 2 == 0) {
          // Even indices are vibration durations
          if (pattern[i] > 0) {
            await HapticFeedback.vibrate();
          }
        } else {
          // Odd indices are pause durations
          if (pattern[i] > 0) {
            await Future.delayed(Duration(milliseconds: pattern[i]));
          }
        }
      }
    } catch (e) {
      debugPrint('Error with custom vibration pattern: $e');
    }
  }
}