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
import 'package:random_01_space_travel/shared/services/haptic_service.dart';
import 'package:random_01_space_travel/shared/widgets/glass_card.dart';
import 'package:random_01_space_travel/shared/widgets/space_button.dart';
import 'package:random_01_space_travel/shared/widgets/star_field_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Explore the Universe',
      description: 'Discover breathtaking planets, moons, and galaxies with our interactive space map.',
      animationPath: 'assets/animations/space_exploration.json',
      backgroundColor: Colors.indigo.shade900,
    ),
    OnboardingPage(
      title: 'Book Space Missions',
      description: 'Reserve your seat on the next mission to Mars, Jupiter, or beyond the solar system.',
      animationPath: 'assets/animations/rocket_launch.json',
      backgroundColor: Colors.purple.shade900,
    ),
    OnboardingPage(
      title: 'Track Your Journey',
      description: 'Monitor your space mission in real-time with detailed progress tracking and updates.',
      animationPath: 'assets/animations/mission_control.json',
      backgroundColor: Colors.blue.shade900,
    ),
    OnboardingPage(
      title: 'Join the Future',
      description: 'Become part of humanity\'s greatest adventure as we reach for the stars.',
      animationPath: 'assets/animations/astronaut_floating.json',
      backgroundColor: Colors.teal.shade900,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
        _isLastPage = _currentPage == _pages.length - 1;
      });
      
      // Play sound effect on page change
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playSoundEffect(SoundEffect.swipe);
      
      // Trigger haptic feedback
      HapticService().feedback(HapticFeedbackType.selection);
    }
  }

  void _nextPage() {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Play sound effect
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSoundEffect(SoundEffect.success);
    
    // Trigger haptic feedback
    HapticService().feedback(HapticFeedbackType.success);
    
    // Mark onboarding as completed in user preferences
    final userPrefs = Provider.of<UserPreferencesProvider>(context, listen: false);
    userPrefs.setOnboardingCompleted(true);
    
    // Navigate to home screen
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background
          ParallaxStarField(
            starCount: 200,
            starColor: Colors.white,
            backgroundColor: Colors.black,
            parallaxFactor: 0.1,
          ),
          
          // Content
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(context, _pages[index], index);
            },
          ),
          
          // Navigation controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Skip button
                    if (!_isLastPage)
                      SpaceButton(
                        text: 'SKIP',
                        onPressed: _completeOnboarding,
                        type: SpaceButtonType.text,
                        soundEffect: SoundEffect.buttonClick,
                        hapticFeedback: HapticFeedbackType.light,
                      ),
                    
                    SizedBox(width: _isLastPage ? 0 : 32),
                    
                    // Next/Get Started button
                    SpaceButton(
                      text: _isLastPage ? 'GET STARTED' : 'NEXT',
                      onPressed: _nextPage,
                      width: _isLastPage ? 200 : 120,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      glowOnPressed: true,
                      soundEffect: SoundEffect.buttonClick,
                      hapticFeedback: HapticFeedbackType.medium,
                      icon: _isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, OnboardingPage page, int index) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final animationsProvider = Provider.of<AnimationsProvider>(context);
    
    // Calculate animation delay based on page index and current page
    final isCurrentPage = index == _currentPage;
    final animationDelay = isCurrentPage ? 0.ms : 300.ms;
    
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation
          SizedBox(
            height: size.height * 0.4,
            child: Lottie.asset(
              page.animationPath,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ).animate()
            .fadeIn(delay: animationDelay, duration: 800.ms)
            .scale(delay: animationDelay, duration: 800.ms, begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          
          const SizedBox(height: 40),
          
          // Content card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AnimatedGlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 24,
              blur: 10,
              opacity: 0.15,
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  page.backgroundColor.withOpacity(0.5),
                  page.backgroundColor.withOpacity(0.3),
                ],
              ),
              shadow: BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 1,
              ),
              child: Column(
                children: [
                  // Title
                  Text(
                    page.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ).animate(target: isCurrentPage ? 1 : 0)
                    .fadeIn(delay: animationDelay + 200.ms, duration: 800.ms)
                    .slideY(begin: 0.2, end: 0, delay: animationDelay + 200.ms, duration: 800.ms),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    page.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ).animate(target: isCurrentPage ? 1 : 0)
                    .fadeIn(delay: animationDelay + 400.ms, duration: 800.ms)
                    .slideY(begin: 0.2, end: 0, delay: animationDelay + 400.ms, duration: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 12 : 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String animationPath;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.animationPath,
    required this.backgroundColor,
  });
}