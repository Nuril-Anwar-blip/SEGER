import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'onboarding_screen.dart' show saveProfilAndContinue;

class OnboardingConditionScreen extends StatefulWidget {
  final String nama;
  final int usia;

  const OnboardingConditionScreen({
    super.key,
    required this.nama,
    required this.usia,
  });

  @override
  State<OnboardingConditionScreen> createState() => _OnboardingConditionScreenState();
}

class _OnboardingConditionScreenState extends State<OnboardingConditionScreen> {
  int? _selectedIndex;

  static const _conditions = [
    _ConditionItem(
      icon: Icons.psychology,
      iconColor: Color(0xFF1565C0),
      iconBgColor: Color(0x1A1565C0),
      title: 'Autism Spectrum Disorder',
      subtitle: 'Panduan visual konsisten dan ritme teratur',
      value: 'autisme',
    ),
    _ConditionItem(
      icon: Icons.directions_walk,
      iconColor: Color(0xFF6A1B9A),
      iconBgColor: Color(0x1A6A1B9A),
      title: 'Cerebral Palsy',
      subtitle: 'Gerakan adaptif dengan toleransi gerak luas',
      value: 'cerebral_palsy',
    ),
    _ConditionItem(
      icon: Icons.handshake,
      iconColor: Color(0xFF2E7D32),
      iconBgColor: Color(0x1A2E7D32),
      title: 'Down Syndrome',
      subtitle: 'Latihan bertahap dengan penguatan positif',
      value: 'down_syndrome',
    ),
  ];

  Future<void> _finish() async {
    if (_selectedIndex == null) return;
    await saveProfilAndContinue(
      context,
      nama: widget.nama,
      usia: widget.usia,
      kondisi: _conditions[_selectedIndex!].value,
    );
  }

  Future<void> _skip() async {
    await saveProfilAndContinue(
      context,
      nama: widget.nama,
      usia: widget.usia,
      kondisi: _conditions[0].value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.maybePop(context),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.arrow_back, color: Color(0xFF151C27)),
                    ),
                  ),
                  Row(
                    children: [
                      _StepDot(isActive: false),
                      const SizedBox(width: 6),
                      _StepDot(isActive: true, isLarge: true),
                      const SizedBox(width: 6),
                      _StepDot(isActive: false),
                      const SizedBox(width: 12),
                      const Text(
                        'Langkah 2 dari 2',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3D4946),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
                child: Column(
                  children: [
                    const Text(
                      'Pilih Kondisi Anak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2B4A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ini membantu kami menyesuaikan latihan khusus untuk si kecil.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D4946),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    ...List.generate(_conditions.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ConditionCard(
                          item: _conditions[index],
                          isSelected: _selectedIndex == index,
                          onTap: () => setState(() => _selectedIndex = index),
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                    const Text(
                      'Kamu bisa mengubah ini kapan saja di Pengaturan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D4946),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Sticky bottom actions
      bottomSheet: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cream.withAlpha(0),
              AppColors.cream,
              AppColors.cream,
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _finish : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withAlpha(100),
                  shape: const StadiumBorder(),
                  elevation: 2,
                ),
                child: const Text(
                  'Mulai Latihan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _skip,
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text(
                'Lewati untuk sekarang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D4946),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  final _ConditionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minHeight: 88),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(13) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFDCE2F3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF151C27),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3D4946),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFBCC9C5),
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;
  final bool isLarge;

  const _StepDot({required this.isActive, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 12.0 : 8.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : Colors.transparent,
        border: isActive
            ? null
            : Border.all(color: const Color(0xFFBCC9C5), width: 2),
      ),
    );
  }
}

class _ConditionItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String value;

  const _ConditionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.value,
  });
}
