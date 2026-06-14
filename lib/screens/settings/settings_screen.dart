import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _voiceNarration = true;
  bool _hapticFeedback = false;
  bool _highContrast = false;
  bool _largeText = false;
  bool _autoReport = true;
  int _animationSpeed = 1; // 0=Lambat, 1=Sedang, 2=Cepat
  int _selectedCondition = 0; // 0=ASD, 1=CP, 2=Down

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 32),
                    _buildSection(
                      title: 'SESI LATIHAN',
                      children: [
                        _buildToggleRow(
                          icon: Icons.volume_up_outlined,
                          label: 'Narasi Suara',
                          value: _voiceNarration,
                          onChanged: (v) => setState(() => _voiceNarration = v),
                        ),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildSpeedRow(),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildToggleRow(
                          icon: Icons.vibration_outlined,
                          label: 'Umpan Balik Getar',
                          value: _hapticFeedback,
                          onChanged: (v) { setState(() => _hapticFeedback = v); if (v) HapticFeedback.mediumImpact(); },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'KONDISI ANAK',
                      children: [
                        _buildRadioRow(icon: Icons.psychology, label: 'Autism Spectrum Disorder', index: 0),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildRadioRow(icon: Icons.accessibility_new, label: 'Cerebral Palsy', index: 1),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildRadioRow(icon: Icons.emoji_people, label: 'Down Syndrome', index: 2),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'TAMPILAN',
                      children: [
                        _buildToggleRow(
                          icon: Icons.contrast,
                          label: 'Mode Kontras Tinggi',
                          value: _highContrast,
                          onChanged: (v) => setState(() => _highContrast = v),
                        ),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildToggleRow(
                          icon: Icons.format_size,
                          label: 'Ukuran Teks Besar',
                          value: _largeText,
                          onChanged: (v) => setState(() => _largeText = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'ORANG TUA',
                      children: [
                        _buildChevronRow(icon: Icons.lock, iconBg: const Color(0xFFFEB300), iconColor: const Color(0xFF6A4800), label: 'PIN Orang Tua', onTap: () {}),
                        const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFDCE2F3)),
                        _buildToggleRow(
                          icon: Icons.summarize_outlined,
                          label: 'Laporan Otomatis',
                          value: _autoReport,
                          onChanged: (v) => setState(() => _autoReport = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context),
                        icon: const Icon(Icons.delete_forever_outlined, size: 20, color: Color(0xFFBA1A1A)),
                        label: const Text('Hapus Semua Data Sesi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFBA1A1A))),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          side: const BorderSide(color: Color(0xFFFFDAD6), width: 1.5),
                          backgroundColor: const Color(0xFFFFDAD6),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('SEGER v1.0.0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6D7A77))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      color: const Color(0xFFF9F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00685D)),
          ),
          const Expanded(
            child: Text('Pengaturan', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF00685D)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCE2F3).withAlpha(77)),
        boxShadow: [BoxShadow(color: const Color(0xFF00685D).withAlpha(10), blurRadius: 24, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00685D), width: 3),
            ),
            child: const Icon(Icons.person, size: 44, color: Color(0xFF00685D)),
          ),
          const SizedBox(height: 12),
          const Text('Profil Anak', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFE7EEFE), borderRadius: BorderRadius.circular(999)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 16, color: Color(0xFF00685D)),
                SizedBox(width: 6),
                Text('Profil aktif', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00685D))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text('Edit Profil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF00685D))),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6D7A77), letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFDCE2F3).withAlpha(77)),
            boxShadow: [BoxShadow(color: const Color(0xFF00685D).withAlpha(7), blurRadius: 16, offset: const Offset(0, 2))],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildToggleRow({required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFE7EEFE), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF00685D), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF151C27)))),
            _SegerToggle(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedRow() {
    const speeds = ['Lambat', 'Sedang', 'Cepat'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(color: Color(0xFFE7EEFE), shape: BoxShape.circle),
                child: const Icon(Icons.speed_outlined, color: Color(0xFF00685D), size: 20),
              ),
              const SizedBox(width: 16),
              const Text('Kecepatan Animasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF151C27))),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 56),
            decoration: BoxDecoration(color: const Color(0xFFE2E8F8), borderRadius: BorderRadius.circular(999)),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(speeds.length, (i) {
                final isActive = _animationSpeed == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _animationSpeed = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF00685D) : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: isActive ? [BoxShadow(color: const Color(0xFF00685D).withAlpha(50), blurRadius: 6)] : null,
                      ),
                      child: Text(
                        speeds[i],
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : const Color(0xFF3D4946),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioRow({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedCondition == index;
    return InkWell(
      onTap: () => setState(() => _selectedCondition = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEFE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isSelected ? const Color(0xFF00685D) : const Color(0xFF6D7A77), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF151C27) : const Color(0xFF3D4946),
                  ),
                ),
              ),
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? const Color(0xFF00685D) : const Color(0xFF6D7A77), width: 2),
                ),
                child: isSelected
                    ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF00685D), shape: BoxShape.circle)))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChevronRow({required IconData icon, required Color iconBg, required Color iconColor, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF151C27)))),
              const Icon(Icons.chevron_right, color: Color(0xFF6D7A77)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Hapus Data Sesi?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Semua riwayat sesi latihan akan dihapus permanen dan tidak bisa dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA1A1A), foregroundColor: Colors.white, shape: const StadiumBorder()),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

/// Custom animated toggle switch
class _SegerToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SegerToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF00685D) : const Color(0xFFBCC9C5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24, height: 24,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
