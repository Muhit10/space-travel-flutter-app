import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';
import 'package:random_01_space_travel/shared/providers/animations_provider.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';
import 'package:random_01_space_travel/shared/widgets/star_field_background.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationComplete = false;
  bool _assetsLoaded = false;
  bool _showText = false;
  bool _showAppName = false;
  bool _showTagline = false;
  bool _showStartButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationComplete = true;
          _showText = true;
        });
        _startTextAnimationSequence();
      }
    });

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Preload animations and assets
    final animationsProvider = Provider.of<AnimationsProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userPrefs = Provider.of<UserPreferencesProvider>(context, listen: false);

    // Initialize user preferences
    await userPrefs.initialize();

    // Preload animations based on user's graphics quality setting
    await animationsProvider.preloadAnimations();

    // Preload audio assets
    await audioProvider.initialize();

    // Play background music if enabled in user preferences
    if (userPrefs.soundEnabled) {
      audioProvider.playBackgroundMusic();
    }

    setState(() {
      _assetsLoaded = true;
    });

    // Start the animation
    _controller.forward();
  }

  void _startTextAnimationSequence() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showAppName = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _showTagline = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _showStartButton = true;
        });
      }
    });
  }

  void _navigateToNextScreen() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSoundEffect(SoundEffect.buttonClick);

    // Navigate to onboarding or home screen
    context.go(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final animationsProvider = Provider.of<AnimationsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: StarFieldBackground(
        starCount: 200,
        starColor: Colors.white,
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            // Animated planet
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Tween<double>(begin: 0.5, end: 1.0)
                        .animate(CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
                        ))
                        .value,
                    child: Transform.rotate(
                      angle: Tween<double>(begin: 0, end: 2 * 3.14159)
                          .animate(_controller)
                          .value,
                      child: Opacity(
                        opacity: Tween<double>(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                              parent: _controller,
                              curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
                            ))
                            .value,
                        child: _assetsLoaded
                            ? Lottie.asset(
                                'assets/animations/planet_rotation.json',
                                width: size.width * 0.7,
                                height: size.width * 0.7,
                                fit: BoxFit.contain,
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Rocket animation
            if (_animationComplete)
              Positioned(
                bottom: size.height * 0.15,
                right: 0,
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.3,
                  child: _assetsLoaded
                      ? Lottie.asset(
                          'assets/animations/rocket_fly.json',
                          fit: BoxFit.contain,
                        )
                      : const SizedBox.shrink(),
                ),
              ),

            // Text animations
            if (_showText)
              Positioned(
                top: size.height * 0.15,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // App name with shimmer effect
                    if (_showAppName)
                      Shimmer.fromColors(
                        baseColor: theme.colorScheme.primary,
                        highlightColor: Colors.white,
                        period: const Duration(seconds: 3),
                        child: Text(
                          AppConstants.appName,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fade(duration: 800.ms, curve: Curves.easeOut),

                    const SizedBox(height: 16),

                    // Tagline
                    if (_showTagline)
                      Text(
                        AppConstants.splashText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(
                            begin: 0.2,
                            end: 0,
                            curve: Curves.easeOutQuad,
                            duration: 800.ms,
                          ),
                  ],
                ),
              ),

            // Start button
            if (_showStartButton)
              Positioned(
                bottom: size.height * 0.1,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _navigateToNextScreen,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        'START JOURNEY',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 200.ms, duration: 600.ms)
                      .shimmer(
                        delay: 800.ms,
                        duration: 1800.ms,
                        curve: Curves.easeInOut,
                      ),
                ),
              ),

            // Loading indicator
            if (!_assetsLoaded)
              const Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading space assets...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}