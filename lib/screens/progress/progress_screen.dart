import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedFilter = 0;
  final _filters = ['Minggu Ini', 'Bulan Ini', 'Semua'];

  // Bar chart data: [Sen, Sel, Rab, Kam, Jum, Sab, Min]
  final _barData = [0.20, 0.60, 1.0, 0.15, 0.80, 0.40, 0.10];
  final _barLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  // Line chart points (normalized 0–1, y inverted: 0=top)
  final _linePoints = [
    Offset(0, 0.75),
    Offset(0.2, 0.625),
    Offset(0.4, 0.25),
    Offset(0.6, 0.375),
    Offset(0.8, 0.125),
    Offset(1.0, 0.5),
  ];

  final _sessions = [
    _SessionRow(title: 'Meniup Peluit', time: 'Hari ini, 10:30', score: '85%', label: 'Baik', isGood: true),
    _SessionRow(title: 'Senam Lidah', time: 'Kemarin, 14:15', score: '72%', label: 'Cukup', isGood: false),
    _SessionRow(title: "Artikulasi 'R'", time: 'Senin, 09:00', score: '90%', label: 'Baik', isGood: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFilterRow(),
                    const SizedBox(height: 16),
                    _buildStatCards(),
                    const SizedBox(height: 16),
                    _buildBarChart(),
                    const SizedBox(height: 16),
                    _buildLineChart(),
                    const SizedBox(height: 16),
                    _buildSessionHistory(),
                    const SizedBox(height: 24),
                    _buildShareButton(),
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
      color: const Color(0xFFF0F3FF),
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF3D4946),
          ),
          const Expanded(
            child: Text(
              'Progres',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF00685D)),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            color: const Color(0xFF3D4946),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => setState(() => _selectedFilter = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _selectedFilter == i ? const Color(0xFF00685D) : const Color(0xFFDCE2F3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _filters[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _selectedFilter == i ? Colors.white : const Color(0xFF3D4946),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _StatCard(value: '12', label: 'Total Sesi'),
        const SizedBox(width: 8),
        _StatCard(value: '84', label: 'Menit Aktif'),
        const SizedBox(width: 8),
        _StatCardProgress(value: '78%', label: 'Ketepatan', progress: 0.78),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Frekuensi Latihan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
          const SizedBox(height: 4),
          const Text('Sesi per hari, minggu ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3D4946))),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_barData.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: _barData[i],
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 400 + i * 80),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00685D).withAlpha(
                                  ((_barData[i] * 0.6 + 0.2) * 255).toInt(),
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _barLabels[i],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF3D4946)),
                        ),
                      ],
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

  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tren Ketepatan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _LineChartPainter(points: _linePoints),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sesi Terakhir', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF151C27))),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00685D))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._sessions.map((s) => _SessionRowWidget(session: s)),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.share_outlined, size: 20),
        label: const Text('Bagikan Laporan ke Terapis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00685D),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 3,
        ),
      ),
    );
  }

  BoxDecoration _cardDecor() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: const Color(0xFF00685D).withAlpha(13), blurRadius: 12, offset: const Offset(0, 4))],
  );
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border(top: BorderSide(color: Color(0xFF00685D), width: 4)),
          boxShadow: [BoxShadow(color: const Color(0xFF00685D).withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF00685D))),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3D4946))),
        ]),
      ),
    );
  }
}

class _StatCardProgress extends StatelessWidget {
  final String value, label;
  final double progress;
  const _StatCardProgress({required this.value, required this.label, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border(top: BorderSide(color: Color(0xFF00685D), width: 4)),
          boxShadow: [BoxShadow(color: const Color(0xFF00685D).withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF00685D))),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3D4946))),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFDCE2F3),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00685D)),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SessionRowWidget extends StatelessWidget {
  final _SessionRow session;
  const _SessionRowWidget({required this.session});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFFF9F9FF), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF151C27))),
                  const SizedBox(height: 2),
                  Text(session.time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D4946))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: session.isGood ? const Color(0xFF00685D).withAlpha(30) : const Color(0xFFFEB300).withAlpha(50),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${session.score} ${session.label}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: session.isGood ? const Color(0xFF00685D) : const Color(0xFF6A4800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionRow {
  final String title, time, score, label;
  final bool isGood;
  const _SessionRow({required this.title, required this.time, required this.score, required this.label, required this.isGood});
}

class _LineChartPainter extends CustomPainter {
  final List<Offset> points;
  const _LineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00685D)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFFFEB300)
      ..style = PaintingStyle.fill;

    // Draw gradient fill under line
    final fillPath = Path();
    final scaledPoints = points.map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
    fillPath.moveTo(scaledPoints.first.dx, size.height);
    for (final p in scaledPoints) fillPath.lineTo(p.dx, p.dy);
    fillPath.lineTo(scaledPoints.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height),
        [const Color(0xFF00685D).withAlpha(60), const Color(0xFF00685D).withAlpha(0)],
      );
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    for (int i = 0; i < scaledPoints.length; i++) {
      if (i == 0) linePath.moveTo(scaledPoints[i].dx, scaledPoints[i].dy);
      else linePath.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Draw dots
    for (final p in scaledPoints) {
      canvas.drawCircle(p, 5, Paint()..color = Colors.white..style = PaintingStyle.fill);
      canvas.drawCircle(p, 5, Paint()..color = const Color(0xFF00685D)..style = PaintingStyle.stroke..strokeWidth = 2);
      canvas.drawCircle(p, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
