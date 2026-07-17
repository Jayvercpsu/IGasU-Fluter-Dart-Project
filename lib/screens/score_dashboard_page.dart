import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/gas_law_content.dart';
import '../data/learning_stats.dart';
import '../theme/app_colors.dart';
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
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 16),
            _buildTopicAccuracyCard(),
            const SizedBox(height: 16),
            _buildRankCards(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'Total Attempts',
                  value: '${_stats.totalAttempts}',
                  color: AppColors.boyleBlue,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildStatItem(
                  label: 'Correct',
                  value: '${_stats.correctAnswers}',
                  color: AppColors.charlesGreen,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.divider,
              ),
              Expanded(
                child: _buildStatItem(
                  label: 'Average',
                  value: '${_stats.averageScore}%',
                  color: AppColors.darkNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Over Time',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: _ProgressLinePainter(values: _stats.averageHistory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicAccuracyCard() {
    final boyleAttempts = _stats.attemptsFor(GasLawType.boyle);
    final charlesAttempts = _stats.attemptsFor(GasLawType.charles);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topic Accuracy',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTopicRow(
            label: "Boyle's Law",
            attempts: boyleAttempts,
            accuracy: _stats.accuracyFor(GasLawType.boyle),
            color: GasLawType.boyle.color,
          ),
          const SizedBox(height: 16),
          _buildTopicRow(
            label: "Charles' Law",
            attempts: charlesAttempts,
            accuracy: _stats.accuracyFor(GasLawType.charles),
            color: GasLawType.charles.color,
          ),
        ],
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
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label ($attempts)',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$accuracy%',
            style: GoogleFonts.inter(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankCards() {
    final isPro = _stats.isPro;
    return Row(
      children: [
        Expanded(child: _buildRankCard(
          icon: Icons.table_chart_outlined,
          label: 'Beginner',
          active: !isPro,
          color: AppColors.textSecondary,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildRankCard(
          icon: Icons.stars_rounded,
          label: 'Pro',
          active: isPro,
          color: AppColors.darkNavy,
        )),
      ],
    );
  }

  Widget _buildRankCard({
    required IconData icon,
    required String label,
    required bool active,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? color.withValues(alpha: 0.3) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: active ? color : AppColors.textHint.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : AppColors.textHint,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: active ? color : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            active ? 'Achieved!' : 'Locked',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: active
                  ? AppColors.charlesGreen
                  : AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      ..color = AppColors.border
      ..strokeWidth = 1;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.darkNavy.withValues(alpha: 0.2),
          AppColors.darkNavy.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = AppColors.darkNavy
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 1; i <= 3; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final padded = values.isEmpty ? const <double>[0] : values;
    final display =
        padded.length > 10 ? padded.sublist(padded.length - 10) : padded;

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

    if (points.length > 1) {
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();
      canvas.drawPath(fillPath, fillPaint);
    }

    for (final point in points) {
      canvas.drawCircle(point, 4, Paint()..color = AppColors.darkNavy);
      canvas.drawCircle(
        point,
        2.5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressLinePainter oldDelegate) {
    if (values.length != oldDelegate.values.length) return true;
    for (int i = 0; i < values.length; i++) {
      if (values[i] != oldDelegate.values[i]) return true;
    }
    return false;
  }
}
