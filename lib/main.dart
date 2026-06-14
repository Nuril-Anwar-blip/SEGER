import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/exercise/exercise_screen.dart';
import 'screens/reward/reward_screen.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: SegerApp()));
}

class SegerApp extends StatelessWidget {
  const SegerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If a profile already exists, skip onboarding and go straight to the
    // main shell. Otherwise start with onboarding.
    final hasProfil = HiveService.getCurrentProfil() != null;

    return MaterialApp(
      title: 'SEGER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: hasProfil ? '/main' : '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/main': (context) => const MainShell(),
        '/exercise': (context) => const ExerciseScreen(),
        '/reward': (context) => const RewardScreen(),
      },
    );
  }
}
