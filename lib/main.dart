import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/hive_service.dart';
import 'screens/exercise/exercise_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: SegerApp()));
}

class SegerApp extends StatelessWidget {
  const SegerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEGER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/exercise': (context) => const ExerciseScreen(),
      },
    );
  }
}