import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Explore the Cosmos',
      description: 'Discover breathtaking planets, moons, and celestial phenomena across our universe.',
      imagePath: 'assets/images/onboarding_explore.svg',
      backgroundColor: AppTheme.deepSpace,
    ),
    OnboardingPage(
      title: 'Plan Your Journey',
      description: 'Book interplanetary missions with our advanced spacecraft fleet and experienced crew.',
      imagePath: 'assets/images/onboarding_journey.svg',
      backgroundColor: AppTheme.spaceBlue,
    ),
    OnboardingPage(
      title: 'Live the Adventure',
      description: 'Experience the thrill of space travel with immersive simulations and real-time updates.',
      imagePath: 'assets/images/onboarding_adventure.svg',
      backgroundColor: AppTheme.spacePurple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToHome() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          
          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: _currentPage < _pages.length - 1
              ? TextButton(
                  onPressed: _navigateToHome,
                  child: Text(
                    'Skip',
                    style: AppTheme.buttonText.copyWith(
                      color: AppTheme.meteorGrey,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    expansionFactor: 4,
                    activeDotColor: AppTheme.neonBlue,
                    dotColor: AppTheme.meteorGrey.withOpacity(0.5),
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingL),
                
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      _currentPage > 0
                        ? IconButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: AppConstants.shortAnimationDuration,
                                curve: AppConstants.defaultCurve,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppTheme.neonBlue,
                            ),
                          )
                        : const SizedBox(width: 48),
                      
                      // Next/Get Started button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: AppConstants.shortAnimationDuration,
                              curve: AppConstants.defaultCurve,
                            );
                          } else {
                            _navigateToHome();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingL,
                            vertical: AppConstants.spacingM,
                          ),
                          backgroundColor: AppTheme.neonBlue,
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                          style: AppTheme.buttonText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        color: page.backgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              SvgPicture.asset(
                page.imagePath,
                height: 300,
                fit: BoxFit.contain,
              ).animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 400.ms),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Title
              Text(
                page.title,
                style: AppTheme.headingMedium,
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: AppConstants.spacingM),
              
              // Description
              Text(
                page.description,
                style: AppTheme.bodyLarge,
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}