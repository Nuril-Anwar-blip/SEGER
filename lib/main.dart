import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/exercise/exercise_screen.dart';
import 'screens/exercise/exercise_success_screen.dart';
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
    return MaterialApp(
      title: 'SEGER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Jika sudah ada profil anak, langsung ke home. Kalau belum, onboarding.
      initialRoute: hasProfil ? '/home' : '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/exercise': (context) => const ExerciseScreen(),
        '/exercise/success': (context) => const ExerciseSuccessScreen(),
      },
    );
  }
}