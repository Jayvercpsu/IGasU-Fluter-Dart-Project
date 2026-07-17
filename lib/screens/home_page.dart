import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'main_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          children: [
            _buildTopHeader(),
            const SizedBox(height: 14),
            _buildHero(),
            const SizedBox(height: 14),
            _buildMenuCard(
              context,
              title: 'Video Tutorials',
              subtitle:
                  'Watch clear and easy-to-understand tutorials about Boyle\'s Law and Charles\' Law.',
              buttonLabel: 'Watch Videos',
              buttonIcon: Icons.play_circle_outline_rounded,
              artworkAsset: 'assets/images/video_tutorials.svg',
              color: AppColors.boyleBlue,
              pageIndex: 1,
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              context,
              title: 'Problem Solver',
              subtitle:
                  'Practice solving problems step-by-step with corrections and instant feedback.',
              buttonLabel: 'Solve Problems',
              buttonIcon: Icons.assignment_rounded,
              artworkAsset: 'assets/images/problem_solver.svg',
              color: AppColors.charlesGreen,
              pageIndex: 2,
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              context,
              title: 'Dashboard',
              subtitle:
                  'Track your progress, view your performance, and stay on top of your learning.',
              buttonLabel: 'View Dashboard',
              buttonIcon: Icons.bar_chart_rounded,
              artworkAsset: 'assets/images/dashboard.svg',
              color: const Color(0xFF7E66D8),
              pageIndex: 3,
            ),
            const SizedBox(height: 16),
            _buildQuote(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/images/igasu_logo.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.science_outlined,
            size: 42,
            color: AppColors.boyleBlue,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_rounded,
                color: AppColors.darkNavy,
                size: 20,
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome!',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  Text(
                    'Student',
                    style: GoogleFonts.inter(
                      color: AppColors.darkNavy,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: GoogleFonts.inter(
            color: AppColors.darkNavy,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        const _IGasUWordmark(),
        const SizedBox(height: 4),
        Text(
          'Learn. Solve. Understand Gas Laws.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.boyleBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Grade 10 - Boyle\'s Law & Charles\' Law',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData buttonIcon,
    required String artworkAsset,
    required Color color,
    required int pageIndex,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateWithAnimation(context, pageIndex),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                artworkAsset,
                width: 88,
                height: 88,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkNavy,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        height: 1.35,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(buttonIcon, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            buttonLabel,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '"',
          style: GoogleFonts.inter(
            color: AppColors.boyleBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        Flexible(
          child: Text(
            'Understand the laws. Master the problems. Become a scientist.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.darkNavy,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Text(
          '"',
          style: GoogleFonts.inter(
            color: AppColors.boyleBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  void _navigateWithAnimation(BuildContext context, int pageIndex) {
    final mainScreen = context.mainScreen;
    mainScreen?.pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _IGasUWordmark extends StatelessWidget {
  const _IGasUWordmark();

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      height: 0.95,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'iGas',
            style: baseStyle.copyWith(color: AppColors.darkNavy),
          ),
          TextSpan(
            text: 'U',
            style: baseStyle.copyWith(color: AppColors.boyleBlue),
          ),
        ],
      ),
    );
  }
}
