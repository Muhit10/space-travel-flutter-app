
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/features/missions/models/mission_model.dart';
import 'package:random_01_space_travel/features/missions/providers/missions_provider.dart';
import 'package:random_01_space_travel/features/planets/providers/planets_provider.dart';
import 'package:random_01_space_travel/shared/providers/animations_provider.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';

// Import screens
import 'package:random_01_space_travel/features/splash/splash_screen.dart';
import 'package:random_01_space_travel/features/home/screens/home_screen.dart';
import 'package:random_01_space_travel/features/planets/screens/planet_detail_screen.dart';
import 'package:random_01_space_travel/features/missions/screens/book_mission_screen.dart';
import 'package:random_01_space_travel/features/missions/screens/mission_progress_screen.dart';
import 'package:random_01_space_travel/features/onboarding/onboarding_screen.dart';

// Commented out missing imports - will need to create these files
// import 'package:random_01_space_travel/features/settings/settings_screen.dart';

// Define TransitionType enum at the top level
enum TransitionType {
  fade,
  scale,
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
  rotate,
}

// Define AppRoutes class to fix the missing reference
class AppRoutes {
  static const String splash = AppConstants.splashRoute;
  static const String onboarding = '/onboarding';
  static const String home = AppConstants.homeRoute;
  static const String settings = AppConstants.settingsRoute;
  static const String planetDetail = 'planet';
  static const String bookMission = 'book';
  static const String missionDetail = 'mission';
  static const String missionList = 'missions';
  static const String news = 'news';
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Onboarding screen
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Main app shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          // Galaxy view (default tab in home)
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
            routes: [
              // Planet detail
              GoRoute(
                path: 'planet/:planetId',
                name: 'planet-detail',
                pageBuilder: (context, state) {
                  final planetId = state.pathParameters['planetId'] ?? '';
                  
                  // Play planet discovered sound
                  if (planetId.isNotEmpty) {
                    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
                    audioProvider.playSoundEffect(SoundEffect.planetDiscovered);
                    
                    // Select planet in provider
                    final planetsProvider = Provider.of<PlanetsProvider>(context, listen: false);
                    planetsProvider.selectPlanet(planetId);
                  }
                  
                  return CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: PlanetDetailScreen(planetId: planetId),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return _buildPageTransition(animation, secondaryAnimation, child, TransitionType.rightToLeft);
                    },
                  );
                },
                routes: [
                  // Book mission
                  GoRoute(
                    path: 'book',
                    name: 'book-mission',
                    pageBuilder: (context, state) {
                      final planetId = state.pathParameters['planetId'] ?? '';
                      
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: BookMissionScreen(planetId: planetId),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return _buildPageTransition(animation, secondaryAnimation, child, TransitionType.bottomToTop);
                        },
                      );
                    },
                  ),
                ],
              ),
              
              // Mission progress
              GoRoute(
                path: 'mission/:missionId',
                name: 'mission-progress',
                pageBuilder: (context, state) {
                  final missionId = state.pathParameters['missionId'] ?? '';
                  
                  // Select mission in provider
                  if (missionId.isNotEmpty) {
                    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
                    missionsProvider.selectMission(missionId);
                  }
                  
                  return CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: MissionProgressScreen(missionId: missionId),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return _buildPageTransition(animation, secondaryAnimation, child, TransitionType.rightToLeft);
                    },
                  );
                },
              ),
            ],
          ),
          
          // News
          GoRoute(
            path: '/${AppRoutes.news}',
            name: 'news',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const Scaffold(body: Center(child: Text('Space News'))), // Temporary placeholder
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return _buildPageTransition(animation, secondaryAnimation, child, TransitionType.rightToLeft);
              },
            ),
          ),
          
          // Settings
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const Scaffold(body: Center(child: Text('Settings Screen'))), // Temporary placeholder
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return _buildPageTransition(animation, secondaryAnimation, child, TransitionType.rightToLeft);
              },
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Provider.of<AnimationsProvider>(context).getAnimationWidget(
              AnimationType.error,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Navigation Error: ${state.error}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Return to Galaxy'),
            ),
          ],
        ),
      ),
    ),
  );
  
  // Build page transition based on type
  static Widget _buildPageTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    TransitionType type,
  ) {
    switch (type) {
      case TransitionType.fade:
        return FadeTransition(opacity: animation, child: child);
      
      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          )),
          child: child,
        );
      
      case TransitionType.rightToLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case TransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case TransitionType.topToBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case TransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      
      case TransitionType.rotate:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}