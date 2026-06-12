import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/profil_anak.dart';
import '../../services/hive_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profil = HiveService.getCurrentProfil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SEGER'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo! 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Siap bergerak hari ini?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),

            // Profil Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profil Anak', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Text(
                    profil?.nama ?? 'Belum ada data',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (profil != null) ...[
                    const SizedBox(height: 8),
                    Text('Kondisi: ${profil.kondisi}'),
                    Text('Usia: ${profil.usia} tahun'),
                  ],
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/exercise');
                },
                child: const Text('Mulai Latihan Sekarang', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Ganti Profil', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}