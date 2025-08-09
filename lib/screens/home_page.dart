import 'package:flutter/material.dart';
import 'main_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iGasU'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildMenuCard(
              context,
              'Video Tutorials',
              Icons.play_circle_outline,
              const Color(0xFF4A90E2),
              () => _navigateWithAnimation(context, 1),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              'Problem Solving',
              Icons.quiz_outlined,
              const Color(0xFF5CB85C),
              () => _navigateWithAnimation(context, 2),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              'Score Dashboard',
              Icons.dashboard_outlined,
              const Color(0xFFFF6B6B),
              () => _navigateWithAnimation(context, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 8,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
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