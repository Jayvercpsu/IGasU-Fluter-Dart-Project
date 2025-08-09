import 'package:flutter/material.dart';
import 'main_screen.dart';

class VideoTutorialsPage extends StatelessWidget {
  const VideoTutorialsPage({super.key});

  // Gas Law video tutorials with detailed explanations
  final List<Map<String, dynamic>> _videos = const [
    {
      'title': 'Boyle\'s Law Explained',
      'duration': '12:45',
      'description': 'Relationship between pressure and volume at constant temperature',
      'formula': 'P₁V₁ = P₂V₂',
      'color': Color(0xFF4A90E2),
      'explanation': '''
Boyle's Law states that the pressure and volume of a gas are inversely proportional when temperature remains constant.

Key Points:
• As pressure increases, volume decreases
• As pressure decreases, volume increases
• Temperature must remain constant
• Formula: P₁V₁ = P₂V₂

Real-world examples:
- Syringe compression
- Scuba diving pressure changes
- Balloon compression
      ''',
    },
    {
      'title': 'Charles\' Law Overview',
      'duration': '10:30',
      'description': 'How volume changes with temperature at constant pressure',
      'formula': 'V₁/T₁ = V₂/T₂',
      'color': Color(0xFF5CB85C),
      'explanation': '''
Charles' Law describes the direct relationship between volume and temperature of a gas at constant pressure.

Key Points:
• Volume increases as temperature increases
• Volume decreases as temperature decreases
• Pressure must remain constant
• Temperature must be in Kelvin (K)
• Formula: V₁/T₁ = V₂/T₂

Real-world examples:
- Hot air balloons
- Car tire pressure in different seasons
- Thermal expansion of gases
      ''',
    },
    {
      'title': 'Gay-Lussac\'s Law Introduction',
      'duration': '9:20',
      'description': 'Pressure-temperature relationship at constant volume',
      'formula': 'P₁/T₁ = P₂/T₂',
      'color': Color(0xFFFF6B6B),
      'explanation': '''
Gay-Lussac's Law shows the direct relationship between pressure and temperature when volume is constant.

Key Points:
• Pressure increases as temperature increases
• Pressure decreases as temperature decreases
• Volume must remain constant
• Temperature must be in Kelvin (K)
• Formula: P₁/T₁ = P₂/T₂

Real-world examples:
- Pressure cooker operation
- Aerosol can warnings
- Gas tank pressure changes
      ''',
    },
    {
      'title': 'Ideal Gas Law Complete Guide',
      'duration': '15:10',
      'description': 'Comprehensive overview of PV=nRT equation',
      'formula': 'PV = nRT',
      'color': Color(0xFFFFB74D),
      'explanation': '''
The Ideal Gas Law combines all gas law relationships into one comprehensive equation.

Key Points:
• P = Pressure (atm, Pa, or mmHg)
• V = Volume (L or m³)
• n = Number of moles
• R = Gas constant (0.0821 L·atm/mol·K)
• T = Temperature in Kelvin (K)
• Formula: PV = nRT

Applications:
- Calculate any variable if others are known
- Determine molar mass of gases
- Solve complex gas problems
      ''',
    },
    {
      'title': 'Combined Gas Law',
      'duration': '11:25',
      'description': 'Using multiple gas laws together',
      'formula': '(P₁V₁)/T₁ = (P₂V₂)/T₂',
      'color': Color(0xFF9C27B0),
      'explanation': '''
The Combined Gas Law merges Boyle's, Charles', and Gay-Lussac's laws for situations where pressure, volume, and temperature all change.

Key Points:
• Combines three individual gas laws
• Used when P, V, and T all change
• Amount of gas (moles) remains constant
• Temperature must be in Kelvin (K)
• Formula: (P₁V₁)/T₁ = (P₂V₂)/T₂

When to use:
- Weather balloon calculations
- Gas compression/expansion problems
- Industrial gas processing
      ''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tutorials'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeaderCard(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  return _buildVideoCard(_videos[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF5CB85C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Gas Laws Video Library',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_videos.length} educational videos available',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 100)),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showVideoDetails(video, index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: video['color'],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: video['color'].withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            video['duration'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: video['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              video['formula'],
                              style: TextStyle(
                                color: video['color'],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVideoDetails(Map<String, dynamic> video, int index) {
    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: video['color'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    video['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video['duration'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Formula Card
                    Card(
                      elevation: 4,
                      color: video['color'].withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Formula: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              video['formula'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: video['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Detailed Explanation
                    const Text(
                      'What you\'ll learn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          video['explanation'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showComingSoon(context);
                      },
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save for Later'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _playVideo(video);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: video['color'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playVideo(Map<String, dynamic> video) {
    // In a real app, this would open a video player
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.play_circle, color: video['color']),
            const SizedBox(width: 8),
            const Text('Playing Video'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline, size: 50, color: video['color']),
                  const SizedBox(height: 8),
                  Text(
                    video['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    video['duration'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Video player would open here in a real implementation.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bookmark, color: Colors.white),
            SizedBox(width: 8),
            Text('Video saved to your learning list!'),
          ],
        ),
        backgroundColor: const Color(0xFF5CB85C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

// Navigation service for accessing context globally
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}