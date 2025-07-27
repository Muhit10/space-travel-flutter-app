import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_01_space_travel/shared/models/graphics_quality.dart';

class UserPreferencesProvider extends ChangeNotifier {
  // Shared preferences instance
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  
  // Preference keys
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _hapticsEnabledKey = 'haptics_enabled';
  static const String _animationsEnabledKey = 'animations_enabled';
  static const String _graphicsQualityKey = 'graphics_quality';
  static const String _autoPlayAnimationsKey = 'auto_play_animations';
  static const String _showTutorialKey = 'show_tutorial';
  static const String _userNameKey = 'user_name';
  static const String _userAvatarKey = 'user_avatar';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  
  // Default values
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  bool _animationsEnabled = true;
  GraphicsQuality _graphicsQuality = GraphicsQuality.high;
  bool _autoPlayAnimations = true;
  bool _showTutorial = true;
  String _userName = 'Space Explorer';
  String _userAvatar = 'assets/images/avatars/default_avatar.png';
  bool _onboardingCompleted = false;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get animationsEnabled => _animationsEnabled;
  GraphicsQuality get graphicsQuality => _graphicsQuality;
  bool get highQualityGraphics => _graphicsQuality == GraphicsQuality.high;
  bool get autoPlayAnimations => _autoPlayAnimations;
  bool get showTutorial => _showTutorial;
  String get userName => _userName;
  String get userAvatar => _userAvatar;
  bool get onboardingCompleted => _onboardingCompleted;
  
  // Constructor
  UserPreferencesProvider() {
    _initPreferences();
  }
  
  // Public initialize method that can be awaited
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _initPreferences();
    }
    return;
  }
  
  // Initialize preferences
  Future<void> _initPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      
      // Load saved preferences
      _soundEnabled = _prefs.getBool(_soundEnabledKey) ?? true;
      _hapticsEnabled = _prefs.getBool(_hapticsEnabledKey) ?? true;
      _animationsEnabled = _prefs.getBool(_animationsEnabledKey) ?? true;
      _graphicsQuality = GraphicsQuality.values[_prefs.getInt(_graphicsQualityKey) ?? GraphicsQuality.high.index];
      _autoPlayAnimations = _prefs.getBool(_autoPlayAnimationsKey) ?? true;
      _showTutorial = _prefs.getBool(_showTutorialKey) ?? true;
      _userName = _prefs.getString(_userNameKey) ?? 'Space Explorer';
      _userAvatar = _prefs.getString(_userAvatarKey) ?? 'assets/images/avatars/default_avatar.png';
      _onboardingCompleted = _prefs.getBool(_onboardingCompletedKey) ?? false;
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing preferences: $e');
    }
  }
  
  // Toggle sound
  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool(_soundEnabledKey, value);
    notifyListeners();
  }
  
  // Toggle haptics
  Future<void> toggleHaptics(bool value) async {
    _hapticsEnabled = value;
    await _prefs.setBool(_hapticsEnabledKey, value);
    notifyListeners();
  }
  
  // Toggle animations
  Future<void> toggleAnimations(bool value) async {
    _animationsEnabled = value;
    await _prefs.setBool(_animationsEnabledKey, value);
    notifyListeners();
  }
  
  // Toggle high quality graphics
  Future<void> toggleHighQualityGraphics(bool value) async {
    _graphicsQuality = value ? GraphicsQuality.high : GraphicsQuality.low;
    await _prefs.setInt(_graphicsQualityKey, _graphicsQuality.index);
    notifyListeners();
  }
  
  // Set graphics quality
  Future<void> setGraphicsQuality(GraphicsQuality quality) async {
    _graphicsQuality = quality;
    await _prefs.setInt(_graphicsQualityKey, quality.index);
    notifyListeners();
  }
  
  // Toggle auto play animations
  Future<void> toggleAutoPlayAnimations(bool value) async {
    _autoPlayAnimations = value;
    await _prefs.setBool(_autoPlayAnimationsKey, value);
    notifyListeners();
  }
  
  // Toggle show tutorial
  Future<void> toggleShowTutorial(bool value) async {
    _showTutorial = value;
    await _prefs.setBool(_showTutorialKey, value);
    notifyListeners();
  }
  
  // Set user name
  Future<void> setUserName(String name) async {
    _userName = name;
    await _prefs.setString(_userNameKey, name);
    notifyListeners();
  }
  
  // Set user avatar
  Future<void> setUserAvatar(String avatarPath) async {
    _userAvatar = avatarPath;
    await _prefs.setString(_userAvatarKey, avatarPath);
    notifyListeners();
  }
  
  // Set onboarding completed
  Future<void> setOnboardingCompleted(bool completed) async {
    _onboardingCompleted = completed;
    await _prefs.setBool(_onboardingCompletedKey, completed);
    notifyListeners();
  }
  
  // Reset all preferences to defaults
  Future<void> resetToDefaults() async {
    _soundEnabled = true;
    _hapticsEnabled = true;
    _animationsEnabled = true;
    _graphicsQuality = GraphicsQuality.high;
    _autoPlayAnimations = true;
    _showTutorial = true;
    _userName = 'Space Explorer';
    _userAvatar = 'assets/images/avatars/default_avatar.png';
    _onboardingCompleted = false;
    
    await _prefs.setBool(_soundEnabledKey, true);
    await _prefs.setBool(_hapticsEnabledKey, true);
    await _prefs.setBool(_animationsEnabledKey, true);
    await _prefs.setInt(_graphicsQualityKey, GraphicsQuality.high.index);
    await _prefs.setBool(_autoPlayAnimationsKey, true);
    await _prefs.setBool(_showTutorialKey, true);
    await _prefs.setString(_userNameKey, 'Space Explorer');
    await _prefs.setString(_userAvatarKey, 'assets/images/avatars/default_avatar.png');
    await _prefs.setBool(_onboardingCompletedKey, false);
    
    notifyListeners();
  }
}