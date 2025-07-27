import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Local imports
import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';
import 'package:random_01_space_travel/core/navigation/app_router.dart';
import 'package:random_01_space_travel/shared/providers/theme_provider.dart';
import 'package:random_01_space_travel/shared/providers/user_preferences_provider.dart';
import 'package:random_01_space_travel/features/planets/providers/planets_provider.dart';
import 'package:random_01_space_travel/features/missions/providers/missions_provider.dart';
import 'package:random_01_space_travel/shared/providers/animations_provider.dart';
import 'package:random_01_space_travel/shared/providers/audio_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.deepSpace,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add user preferences provider first (required by other providers)
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        // Add theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Add planets provider
        ChangeNotifierProvider(create: (_) => PlanetsProvider()),
        // Add missions provider
        ChangeNotifierProvider(create: (_) => MissionsProvider()),
        // Add animations provider
        ChangeNotifierProvider(
          create: (context) => AnimationsProvider(
            Provider.of<UserPreferencesProvider>(context, listen: false),
          ),
        ),
        // Add audio provider
        ChangeNotifierProvider(
          create: (context) => AudioProvider(
            Provider.of<UserPreferencesProvider>(context, listen: false),
          ),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
