import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';

enum AnimationType {
  splash,
  rocketLaunch,
  planetRotation,
  starfield,
  loading,
  success,
  error,
  spaceshipFlight,
  warpDrive,
  astronaut,
  satellite,
  meteor,
  alienWave,
}

class AnimationsProvider extends ChangeNotifier {
  // User preferences
  final UserPreferencesProvider _preferences;
  
  // Animation controllers
  final Map<AnimationType, LottieComposition?> _animations = {};
  
  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  // Animation paths
  final Map<AnimationType, String> _animationPaths = {
    AnimationType.splash: 'assets/animations/splash.json',
    AnimationType.rocketLaunch: 'assets/animations/rocket_launch.json',
    AnimationType.planetRotation: 'assets/animations/planet_rotation.json',
    AnimationType.starfield: 'assets/animations/starfield.json',
    AnimationType.loading: 'assets/animations/loading.json',
    AnimationType.success: 'assets/animations/success.json',
    AnimationType.error: 'assets/animations/error.json',
    AnimationType.spaceshipFlight: 'assets/animations/spaceship_flight.json',
    AnimationType.warpDrive: 'assets/animations/warp_drive.json',
    AnimationType.astronaut: 'assets/animations/astronaut.json',
    AnimationType.satellite: 'assets/animations/satellite.json',
    AnimationType.meteor: 'assets/animations/meteor.json',
    AnimationType.alienWave: 'assets/animations/alien_wave.json',
  };
  
  // Animation durations
  final Map<AnimationType, Duration> _animationDurations = {
    AnimationType.splash: const Duration(seconds: 3),
    AnimationType.rocketLaunch: const Duration(seconds: 4),
    AnimationType.planetRotation: const Duration(seconds: 10),
    AnimationType.starfield: const Duration(seconds: 20),
    AnimationType.loading: const Duration(seconds: 2),
    AnimationType.success: const Duration(milliseconds: 1500),
    AnimationType.error: const Duration(milliseconds: 1500),
    AnimationType.spaceshipFlight: const Duration(seconds: 5),
    AnimationType.warpDrive: const Duration(seconds: 3),
    AnimationType.astronaut: const Duration(seconds: 6),
    AnimationType.satellite: const Duration(seconds: 8),
    AnimationType.meteor: const Duration(seconds: 2),
    AnimationType.alienWave: const Duration(seconds: 3),
  };
  
  // Constructor
  AnimationsProvider(this._preferences) {
    _preloadAnimations();
  }
  
  // Public method to preload animations
  Future<void> preloadAnimations() async {
    return await _preloadAnimations();
  }
  
  // Preload animations
  Future<void> _preloadAnimations() async {
    try {
      if (_preferences.highQualityGraphics) {
        // Load all animations
        for (final type in AnimationType.values) {
          final path = _animationPaths[type];
          if (path != null) {
            // Using AssetLottie instead of LottieComposition.fromAsset
            _animations[type] = null; // We'll load directly in getAnimationWidget
          }
        }
      } else {
        // Load only essential animations
        final essentialAnimations = [
          AnimationType.splash,
          AnimationType.loading,
          AnimationType.success,
          AnimationType.error,
        ];
        
        for (final type in essentialAnimations) {
          final path = _animationPaths[type];
          if (path != null) {
            // Using AssetLottie instead of LottieComposition.fromAsset
            _animations[type] = null; // We'll load directly in getAnimationWidget
          }
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error preloading animations: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get animation
  LottieComposition? getAnimation(AnimationType type) {
    return _animations[type];
  }
  
  // Get animation duration
  Duration getAnimationDuration(AnimationType type) {
    return _animationDurations[type] ?? const Duration(seconds: 2);
  }
  
  // Get animation widget
  Widget getAnimationWidget(AnimationType type, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool autoPlay = true,
    AnimationController? controller,
  }) {
    if (!_preferences.animationsEnabled) {
      // Return placeholder if animations are disabled
      return SizedBox(
        width: width,
        height: height,
      );
    }
    
    final path = _animationPaths[type];
    if (path == null) return const SizedBox();
    
    // Use asset path directly instead of preloaded composition
    return Lottie.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      animate: autoPlay && _preferences.autoPlayAnimations,
      controller: controller,
      errorBuilder: (context, error, stackTrace) {
        // Return a fallback widget if animation fails to load
        return Container(
          width: width,
          height: height,
          color: Colors.transparent,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white54,
          ),
        );
      },
    );
  }
  
  // Handle animation preference change
  void onAnimationPreferenceChanged(bool enabled) {
    notifyListeners();
  }
  
  // Handle high quality graphics preference change
  void onHighQualityGraphicsChanged(bool enabled) {
    _preloadAnimations();
  }
}