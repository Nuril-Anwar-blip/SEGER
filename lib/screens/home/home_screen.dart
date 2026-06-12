import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(context),
                    const SizedBox(height: 32),
                    _buildSessionSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
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
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDYhONgjrx4mlGGWOEyFo6nMKBKmCnc-2HYN1SB3QK9LB7-ZZx_vpF_ub3q29ntQ6WoP1ie5x4642ebK4qEU2bkLFysGTpTPq9T9dLtOjAuwIYXBvPJq16uVsJk2MM_gawp8q3iu2KAeeUu4J2D1ybZ3B3HBMZRgfngGWEOnRMNCcK8uCUmyXKbWlMgDjZYopyR7fvnXVds5geQITHU8pob-8A7SFwQ1P6ti37Bu__iBF7YU7xwceAL3kOGwE3mbiS_CC5bVm0oYao',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Color(0xFF00897B), size: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dimas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A))),
                Text('Selamat datang!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3D4946))),
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

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(minHeight: 280),
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
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDdl_fPg1hcjtoXM84Kerdx4-wu5m20wmvohZuMxvRUotGkmYFXYrfI07TJhC_eS1dCOc5jcTOi4q5tvFuLZBoifwH1LNI0fHGyUro_U4m83TiG4lBbmJfkNLPQO5KfOLzpvGrxdiZuqClQO-J0nRPh6QBhyl5h1VoU38cFDNHiq6v7stxwuhth0VX3650bQiWzkp1gBF1kfR9HRzVOYyCEPUAMfhS9H8IpSq1b2AWM3woNQYaGa7plwozYmcEZakuCosywUp5Rgfs',
            height: 180,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.child_care, size: 120, color: Color(0xFF00897B)),
          ),
          const SizedBox(height: 16),
          const Text('Halo, Dimas!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A))),
          const SizedBox(height: 8),
          const Text('Siap bergerak hari ini?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF00897B))),
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
            onPressed: () => Navigator.pushNamed(context, '/reward'),
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
