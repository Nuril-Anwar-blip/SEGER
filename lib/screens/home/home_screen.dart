import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../models/profil_anak.dart';
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
>>>>>>> origin/fitur-rive-iqbal
import '../../services/hive_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfilAnak? profil = HiveService.getCurrentProfil();
    final namaAnak = profil?.nama ?? 'Adik';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context, namaAnak),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(context, namaAnak),
                    const SizedBox(height: 24),
                    if (profil != null) _buildProfilCard(profil),
                    if (profil != null) const SizedBox(height: 32),
                    _buildSessionSection(context),
                  ],
<<<<<<< HEAD
                ),
=======
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
                onPressed: () async {
                  await HiveService.clearProfil();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Ganti Profil', style: TextStyle(fontSize: 18)),
>>>>>>> origin/fitur-rive-iqbal
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context, String nama) {
    return Container(
      color: const Color(0xFFF0F3FF),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00897B), width: 4),
            ),
            child: const Icon(Icons.person, color: Color(0xFF00897B), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A))),
                const Text('Selamat datang!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3D4946))),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            iconSize: 28,
            color: const Color(0xFF3D4946),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, String nama) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(minHeight: 240),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x1A00897B), Color(0xFFF9F9FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF00897B).withAlpha(20), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const Icon(Icons.child_care, size: 100, color: Color(0xFF00897B)),
          const SizedBox(height: 16),
          Text('Halo, $nama!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A))),
          const SizedBox(height: 8),
          const Text('Siap bergerak hari ini?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF00897B))),
        ],
      ),
    );
  }

  Widget _buildProfilCard(ProfilAnak profil) {
    return Container(
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
            profil.nama,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Kondisi: ${profil.kondisi}'),
          Text('Usia: ${profil.usia} tahun'),
        ],
      ),
    );
  }

  Widget _buildSessionSection(BuildContext context) {
    final sessions = [
      _SessionItem(icon: Icons.directions_run, iconColor: const Color(0xFF00897B), iconBgColor: const Color(0x1A00897B), title: 'Lari Ceria', stars: 2),
      _SessionItem(icon: Icons.self_improvement, iconColor: const Color(0xFFFFB300), iconBgColor: const Color(0x1AFFB300), title: 'Peregangan', stars: 1),
      _SessionItem(icon: Icons.sports_gymnastics, iconColor: const Color(0xFFB05E41), iconBgColor: const Color(0x1AB05E41), title: 'Lompat Aktif', stars: 3),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 16),
          child: Text('Sesi Hari Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF00897B))),
        ),
        ...sessions.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SessionCard(item: s),
        )),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/exercise'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00685D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Mulai Latihan Sekarang', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final _SessionItem item;
  const _SessionCard({required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(left: BorderSide(color: Color(0xFF00897B), width: 4)),
        boxShadow: [BoxShadow(color: const Color(0xFF00897B).withAlpha(20), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: item.iconBgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(item.icon, color: item.iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A)), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: List.generate(3, (i) => Icon(i < item.stars ? Icons.star : Icons.star_border, color: const Color(0xFFFFB300), size: 16))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/exercise'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white,
              minimumSize: const Size(0, 56), padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
            ),
            child: const Text('Mulai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SessionItem {
  final IconData icon;
  final Color iconColor, iconBgColor;
  final String title;
  final int stars;
  const _SessionItem({required this.icon, required this.iconColor, required this.iconBgColor, required this.title, required this.stars});
}
