import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  static const _exercises = [
    _ExItem(icon: Icons.directions_run, color: Color(0xFF00897B), bg: Color(0x1A00897B), title: 'Lari Ceria', desc: 'Kardio ringan & koordinasi', duration: '10 mnt', stars: 2),
    _ExItem(icon: Icons.self_improvement, color: Color(0xFFFFB300), bg: Color(0x1AFFB300), title: 'Peregangan', desc: 'Fleksibilitas & relaksasi', duration: '8 mnt', stars: 1),
    _ExItem(icon: Icons.sports_gymnastics, color: Color(0xFFB05E41), bg: Color(0x1AB05E41), title: 'Lompat Aktif', desc: 'Keseimbangan & kekuatan', duration: '12 mnt', stars: 3),
    _ExItem(icon: Icons.psychology, color: Color(0xFF1565C0), bg: Color(0x1A1565C0), title: 'Latihan Fokus', desc: 'Koordinasi mata-tangan', duration: '15 mnt', stars: 0),
    _ExItem(icon: Icons.accessibility_new, color: Color(0xFF6A1B9A), bg: Color(0x1A6A1B9A), title: 'Pose Keseimbangan', desc: 'Postur & kontrol tubuh', duration: '10 mnt', stars: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFFF0F3FF),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Latihan',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00685D).withAlpha(20),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Color(0xFF00685D), size: 18),
                        SizedBox(width: 4),
                        Text('3 hari beruntun', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00685D))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Filter chips
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['Semua', 'Motorik', 'Keseimbangan', 'Koordinasi', 'Relaksasi']
                          .asMap()
                          .entries
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _FilterChip(label: e.value, isActive: e.key == 0),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Semua Latihan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A)),
                  ),
                  const SizedBox(height: 16),
                  ..._exercises.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ExerciseCard(item: e, context: context),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _FilterChip({required this.label, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00685D) : const Color(0xFFDCE2F3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : const Color(0xFF3D4946),
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final _ExItem item;
  final BuildContext context;
  const _ExerciseCard({required this.item, required this.context});
  @override
  Widget build(BuildContext _) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF00897B).withAlpha(15), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(14)),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2B4A))),
                const SizedBox(height: 3),
                Text(item.desc, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D4946))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF6D7A77)),
                    const SizedBox(width: 4),
                    Text(item.duration, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6D7A77))),
                    const SizedBox(width: 12),
                    ...List.generate(3, (i) => Icon(
                      i < item.stars ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFB300), size: 14,
                    )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/reward'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00685D), foregroundColor: Colors.white,
              minimumSize: const Size(64, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text('Mulai', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ExItem {
  final IconData icon;
  final Color color, bg;
  final String title, desc, duration;
  final int stars;
  const _ExItem({required this.icon, required this.color, required this.bg, required this.title, required this.desc, required this.duration, required this.stars});
}
