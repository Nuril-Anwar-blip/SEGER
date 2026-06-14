import 'package:flutter/material.dart';
import '../../models/profil_anak.dart';
import '../../services/hive_service.dart';
import '../../theme/app_colors.dart';
import 'onboarding_condition_screen.dart';

/// Step 1: basic profile info (name & age).
/// On submit, a [ProfilAnak] draft is created and passed forward to the
/// condition-selection step, which performs the final Hive save.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usiaController =
      TextEditingController(text: "8");

  @override
  void dispose() {
    _namaController.dispose();
    _usiaController.dispose();
    super.dispose();
  }

  void _next() {
    if (_namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama anak tidak boleh kosong')),
      );
      return;
    }

    final usia = int.tryParse(_usiaController.text) ?? 8;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OnboardingConditionScreen(
          nama: _namaController.text.trim(),
          usia: usia,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Selamat Datang di SEGER'),
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Anak',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.onBackground),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, kenalan dulu dengan si kecil.',
              style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Anak',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _usiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Umur (tahun)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Lanjut', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper used by [OnboardingConditionScreen] to build the [ProfilAnak]
/// once a condition has been chosen.
ProfilAnak buildProfil({
  required String nama,
  required int usia,
  required String kondisi,
}) {
  return ProfilAnak(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    nama: nama,
    kondisi: kondisi,
    usia: usia,
  );
}

Future<void> saveProfilAndContinue(
  BuildContext context, {
  required String nama,
  required int usia,
  required String kondisi,
}) async {
  final profil = buildProfil(nama: nama, usia: usia, kondisi: kondisi);
  await HiveService.saveProfil(profil);
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }
}
