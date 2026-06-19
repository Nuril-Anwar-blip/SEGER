import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
<<<<<<< HEAD
import 'screens/exercise/exercise_screen.dart';
import 'screens/reward/reward_screen.dart';
=======
import 'screens/home/home_screen.dart';
import 'screens/exercise/exercise_screen.dart';
import 'screens/exercise/exercise_success_screen.dart';
>>>>>>> origin/fitur-rive-iqbal
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // Tentukan halaman awal berdasarkan apakah profil sudah disimpan
  final hasProfil = HiveService.getCurrentProfil() != null;

  runApp(ProviderScope(child: SegerApp(hasProfil: hasProfil)));
}

class SegerApp extends StatelessWidget {
  final bool hasProfil;

  const SegerApp({super.key, required this.hasProfil});

  @override
  Widget build(BuildContext context) {
    // If a profile already exists, skip onboarding and go straight to the
    // main shell. Otherwise start with onboarding.
    final hasProfil = HiveService.getCurrentProfil() != null;

    return MaterialApp(
      title: 'SEGER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
<<<<<<< HEAD
      initialRoute: hasProfil ? '/main' : '/',
=======
      // Jika sudah ada profil anak, langsung ke home. Kalau belum, onboarding.
      initialRoute: hasProfil ? '/home' : '/',
>>>>>>> origin/fitur-rive-iqbal
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/main': (context) => const MainShell(),
        '/exercise': (context) => const ExerciseScreen(),
<<<<<<< HEAD
        '/reward': (context) => const RewardScreen(),
=======
        '/exercise/success': (context) => const ExerciseSuccessScreen(),
>>>>>>> origin/fitur-rive-iqbal
      },
    );
  }
}
