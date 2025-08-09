import 'package:flutter/material.dart';
import 'main_screen.dart';

class ScoreDashboardPage extends StatelessWidget {
  const ScoreDashboardPage({super.key});

  final List<Map<String, dynamic>> _scores = const [
    {
      'topic': 'Boyle\'s Law',
      'score': 76,
      'color': Color(0xFF4A90E2),
      'problems_solved': 8,
      'total_problems': 10,
      'last_activity': '2 hours ago',
    },
    {
      'topic': 'Charles\' Law',
      'score': 60,
      'color': Color(0xFFFF6B6B),
      'problems_solved': 6,
      'total_problems': 10,
      'last_activity': '1 day ago',
    },
    {
      'topic': 'Gay-Lussac\'s Law',
      'score': 80,
      'color': Color(0xFF5CB85C),
      'problems_solved': 8,
      'total_problems': 10,
      'last_activity': '3 hours ago',
    },
    {
      'topic': 'Ideal Gas Law',
      'score': 90,
      'color': Color(0xFFFFB74D),
      'problems_solved': 9,
      'total_problems': 10,
      'last_activity': '30 minutes ago',
    },
    {
      'topic': 'Combined Gas Law',
      'score': 45,
      'color': Color(0xFF9C27B0),
      'problems_solved': 4,
      'total_problems': 10,
      'last_activity': '1 week ago',
    },
  ];

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildOverallStatsCard(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _scores.length,
                itemBuilder: (context, index) {
                  return _buildScoreCard(_scores[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatsCard() {
    double averageScore =
        _scores.fold(0.0, (sum, item) => sum + item['score']) / _scores.length;
    int totalSolved = _scores.fold(
      0,
      (sum, item) => sum + (item['problems_solved'] as int),
    );
    int totalProblems = _scores.fold(
      0,
      (sum, item) => sum + (item['total_problems'] as int),
    );

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
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
            const Text(
              'Overall Performance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Average Score',
                  '${averageScore.toStringAsFixed(1)}%',
                ),
                _buildStatItem(
                  'Problems Solved',
                  '$totalSolved/$totalProblems',
                ),
                _buildStatItem('Topics', '${_scores.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildScoreCard(Map<String, dynamic> scoreData, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _showDetailedStats(scoreData),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: scoreData['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        scoreData['topic'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${scoreData['score']}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: scoreData['color'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: scoreData['score'] / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(scoreData['color']),
                  minHeight: 8,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Problems: ${scoreData['problems_solved']}/${scoreData['total_problems']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      scoreData['last_activity'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailedStats(Map<String, dynamic> scoreData) {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(scoreData['topic']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Current Score:', '${scoreData['score']}%'),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Problems Solved:',
              '${scoreData['problems_solved']}/${scoreData['total_problems']}',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Success Rate:',
              '${((scoreData['problems_solved'] / scoreData['total_problems']) * 100).toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Last Activity:', scoreData['last_activity']),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: scoreData['score'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(scoreData['color']),
              minHeight: 8,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would navigate to practice problems for this topic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scoreData['color'],
            ),
            child: const Text('Practice More'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value),
      ],
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
