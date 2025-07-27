import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.splashDuration,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.5, curve: AppConstants.defaultCurve),
    ));
    
    _animationController.forward();
    
    // Navigate to onboarding screen after splash duration
    Future.delayed(AppConstants.splashDuration, () {
      context.go(AppRoutes.onboarding);
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Helper method to check if an asset exists
  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Space logo animation
                // Fallback to a Container with an icon if animation is missing
                FutureBuilder<bool>(
                  future: _checkAssetExists('assets/animations/space_rocket.json'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return Lottie.asset(
                        'assets/animations/space_rocket.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      );
                    } else {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.deepSpace.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.rocket_launch,
                          size: 80,
                          color: AppTheme.neonBlue,
                        ),
                      );
                    }
                  },
                ),
                
                const SizedBox(height: AppConstants.spacingXL),
                
                // App title
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    );
                  },
                  child: Text(
                    AppConstants.appName,
                    style: AppTheme.headingLarge,
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingM),
                
                // Tagline
                Text(
                  AppConstants.splashText,
                  style: AppTheme.bodyLarge,
                ).animate()
                  .fadeIn(delay: 500.ms, duration: 800.ms)
                  .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: AppConstants.spacingXXL),
                
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonBlue),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}