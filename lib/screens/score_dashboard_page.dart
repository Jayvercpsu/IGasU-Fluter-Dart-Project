import 'package:flutter/material.dart';

import '../data/gas_law_content.dart';
import '../data/learning_stats.dart';
import 'main_screen.dart';

class ScoreDashboardPage extends StatefulWidget {
  const ScoreDashboardPage({super.key});

  @override
  State<ScoreDashboardPage> createState() => _ScoreDashboardPageState();
}

class _ScoreDashboardPageState extends State<ScoreDashboardPage> {
  final LearningStats _stats = LearningStats.instance;

  @override
  void initState() {
    super.initState();
    _stats.addListener(_handleStatsUpdate);
  }

  @override
  void dispose() {
    _stats.removeListener(_handleStatsUpdate);
    super.dispose();
  }

  void _handleStatsUpdate() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatsCard(),
            const SizedBox(height: 18),
            _buildProgressCard(),
            const SizedBox(height: 18),
            _buildTopicAccuracyCard(),
            const SizedBox(height: 18),
            _buildRankCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Total Attempts:', '${_stats.totalAttempts}'),
            const SizedBox(height: 12),
            _buildStatRow('Correct Answers:', '${_stats.correctAnswers}'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Average Score:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F486E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_stats.averageScore}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Over Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: CustomPaint(
                painter: _ProgressLinePainter(values: _stats.averageHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicAccuracyCard() {
    final boyleAttempts = _stats.attemptsFor(GasLawType.boyle);
    final charlesAttempts = _stats.attemptsFor(GasLawType.charles);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Topic Accuracy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTopicRow(
              label: 'Boyle\'s Law',
              attempts: boyleAttempts,
              accuracy: _stats.accuracyFor(GasLawType.boyle),
              color: GasLawType.boyle.color,
            ),
            const SizedBox(height: 10),
            _buildTopicRow(
              label: 'Charles\' Law',
              attempts: charlesAttempts,
              accuracy: _stats.accuracyFor(GasLawType.charles),
              color: GasLawType.charles.color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicRow({
    required String label,
    required int attempts,
    required int accuracy,
    required Color color,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label ($attempts)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$accuracy%',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildRankCards() {
    final isPro = _stats.isPro;

    return Row(
      children: [
        Expanded(
          child: _buildRankCard(
            icon: Icons.table_chart_outlined,
            label: 'Beginner',
            active: !isPro,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildRankCard(
            icon: Icons.stars_rounded,
            label: 'Pro',
            active: isPro,
          ),
        ),
      ],
    );
  }

  Widget _buildRankCard({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    return Card(
      elevation: 3,
      color: active ? const Color(0xFFEAF1FF) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: active
                  ? const Color(0xFF2F486E)
                  : const Color(0xFF2F486E).withValues(alpha: 0.5),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: active ? const Color(0xFF1F2E46) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    final mainScreen = context.mainScreen;
    mainScreen?.pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _ProgressLinePainter extends CustomPainter {
  const _ProgressLinePainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFDCE2EE)
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = const Color(0xFF2F486E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 1; i <= 3; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final padded = values.isEmpty ? const <double>[0] : values;
    final display = padded.length > 10
        ? padded.sublist(padded.length - 10)
        : padded;

    if (display.length == 1) {
      final y = size.height * (1 - (display.first / 100).clamp(0, 1));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      return;
    }

    final stepX = size.width / (display.length - 1);
    final points = <Offset>[];
    for (int i = 0; i < display.length; i++) {
      final score = display[i].clamp(0, 100) / 100;
      points.add(Offset(stepX * i, size.height * (1 - score)));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.quadraticBezierTo(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
        points[i].dx,
        points[i].dy,
      );
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressLinePainter oldDelegate) {
    if (values.length != oldDelegate.values.length) {
      return true;
    }

    for (int i = 0; i < values.length; i++) {
      if (values[i] != oldDelegate.values[i]) {
        return true;
      }
    }
    return false;
  }
}
