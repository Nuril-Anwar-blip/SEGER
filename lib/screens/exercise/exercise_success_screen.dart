import 'package:flutter/material.dart';

/// Layar selamat yang ditampilkan setelah gerakan latihan dianggap valid/sukses.
class ExerciseSuccessScreen extends StatelessWidget {
  const ExerciseSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1565C0), // Blue 800
              Color(0xFF0D47A1), // Blue 900
              Color(0xFF0A3D91),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Trophy icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Selamat text
              const Text(
                '🎉 Selamat! 🎉',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Kamu sudah berhasil\nmenyelesaikan latihan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // Bintang animasi sederhana
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.star_rounded,
                      size: 48,
                      color: Colors.amber.shade300,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Tombol Ulangi Latihan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Langsung replace layar sukses dengan exercise baru
                      Navigator.pushReplacementNamed(context, '/exercise');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade400,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.replay_rounded, size: 24),
                    label: const Text(
                      'Ulangi Latihan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Kembali ke Home
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Pop semua sampai home
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.home_rounded, size: 24),
                    label: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
