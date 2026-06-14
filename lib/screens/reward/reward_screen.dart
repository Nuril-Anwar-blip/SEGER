import 'package:flutter/material.dart';
import 'dart:math' as math;

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});
  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl, _pulseCtrl, _popCtrl, _progressCtrl;
  late Animation<double> _badgeScale, _titleScale, _subtitleScale, _cardScale, _buttonsScale, _progressVal, _pulseAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _popCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _badgeScale = _popAnim(0.0, 0.4);
    _titleScale = _popAnim(0.15, 0.55);
    _subtitleScale = _popAnim(0.3, 0.7);
    _cardScale = _popAnim(0.45, 0.85);
    _buttonsScale = _popAnim(0.6, 1.0);
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _progressVal = Tween<double>(begin: 0.0, end: 0.75).animate(CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut));
    _popCtrl.forward();
    Future.delayed(const Duration(milliseconds: 900), () { if (mounted) _progressCtrl.forward(); });
  }

  Animation<double> _popAnim(double start, double end) {
    return TweenSequence([
      if (start > 0) TweenSequenceItem(tween: ConstantTween(0.0), weight: start * 100),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.1).chain(CurveTween(curve: Curves.easeOut)), weight: (end - start) * 80),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: (end - start) * 20),
      if (end < 1.0) TweenSequenceItem(tween: ConstantTween(1.0), weight: (1.0 - end) * 100),
    ]).animate(_popCtrl);
  }

  @override
  void dispose() { _floatCtrl.dispose(); _pulseCtrl.dispose(); _popCtrl.dispose(); _progressCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFEB300),
        child: Stack(
          children: [
            _buildDecorations(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(),
                      const SizedBox(height: 32),
                      _buildTitle(),
                      const SizedBox(height: 8),
                      _buildSubtitle(),
                      const SizedBox(height: 32),
                      _buildCard(),
                      const SizedBox(height: 32),
                      _buildButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorations() {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, __) {
        final dy = math.sin(_floatCtrl.value * math.pi) * 18;
        final rot = math.sin(_floatCtrl.value * math.pi) * 0.09;
        return Stack(children: [
          Positioned(top: 48 + dy * 0.8, left: 32, child: Transform.rotate(angle: rot, child: const Icon(Icons.star, color: Colors.white, size: 40))),
          Positioned(top: 96 + dy * 0.5, left: 80, child: Icon(Icons.circle_outlined, color: const Color(0xFF70D8C8).withAlpha(180), size: 24)),
          Positioned(top: 64 + dy * 0.6, right: 48, child: Transform.rotate(angle: -rot * 0.5, child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48))),
          Positioned(top: 128 + dy * 0.4, right: 32, child: Icon(Icons.star_border, color: const Color(0xFF00685D), size: 30)),
          Positioned(bottom: 160 - dy * 0.5, left: 40, child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30)),
          Positioned(bottom: 128 - dy * 0.7, right: 48, child: Transform.rotate(angle: rot * 1.2, child: const Icon(Icons.star, color: Colors.white, size: 40))),
        ]);
      },
    );
  }

  Widget _buildBadge() {
    return ScaleTransition(
      scale: _badgeScale,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 192, height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDEAC),
                border: Border.all(color: Colors.white.withAlpha(77), width: 8),
                boxShadow: [BoxShadow(color: Colors.white.withAlpha(100), blurRadius: 24, spreadRadius: 4)],
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 110),
            ),
            Positioned(top: -16, right: -16, child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, __) => Transform.translate(offset: Offset(0, -math.sin(_floatCtrl.value * math.pi) * 8), child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30)),
            )),
            Positioned(bottom: -8, left: -8, child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, __) => Transform.translate(offset: Offset(0, math.sin(_floatCtrl.value * math.pi) * 6), child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() => ScaleTransition(
    scale: _titleScale,
    child: const Text('Hebat Sekali!', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2,
        shadows: [Shadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2))])),
  );

  Widget _buildSubtitle() => ScaleTransition(
    scale: _subtitleScale,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withAlpha(77), borderRadius: BorderRadius.circular(999)),
      child: const Text('Hebat, kamu berhasil menyelesaikan latihan!', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF281900), height: 1.5)),
    ),
  );

  Widget _buildCard() {
    return ScaleTransition(
      scale: _cardScale,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE7EEFE)),
          boxShadow: [BoxShadow(color: const Color(0xFF006B5F).withAlpha(38), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF008376)),
                    child: const Icon(Icons.star, color: Color(0xFFF4FFFB), size: 32),
                  ),
                  const SizedBox(width: 16),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Poin Bintang', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
                    SizedBox(height: 4),
                    Text('Kamu mendapat +50 Poin!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF00685D))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Menuju Bintang Emas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3D4946))),
                Text('150/200', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00685D))),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 16,
                child: AnimatedBuilder(
                  animation: _progressVal,
                  builder: (_, __) => LinearProgressIndicator(
                    value: _progressVal.value,
                    backgroundColor: const Color(0xFFE2E8F8),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF00685D)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ScaleTransition(
      scale: _buttonsScale,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity, height: 64,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.play_arrow, size: 24),
              label: const Text('Latihan Lagi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00685D), foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 64,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false),
              icon: const Icon(Icons.home_outlined, size: 22),
              label: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
