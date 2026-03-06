import 'package:flutter/material.dart';

import '../data/gas_law_content.dart';
import '../components/bottom_navbar.dart';
import 'home_page.dart';
import 'problem_solving_page.dart';
import 'score_dashboard_page.dart';
import 'video_tutorials_page.dart';

abstract class MainScreenController {
  PageController get pageController;

  void openProblemSolvingForTopic(GasLawType type);
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin
    implements MainScreenController {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ValueNotifier<GasLawType?> _problemTopicRequest;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _problemTopicRequest = ValueNotifier<GasLawType?>(null);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _pages = <Widget>[
      const HomePage(),
      const VideoTutorialsPage(),
      ProblemSolvingPage(topicRequest: _problemTopicRequest),
      const ScoreDashboardPage(),
    ];
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _problemTopicRequest.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  // Getter to access PageController from child widgets
  @override
  PageController get pageController => _pageController;

  @override
  void openProblemSolvingForTopic(GasLawType type) {
    _problemTopicRequest.value = type;
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

// Extension to access MainScreen from child widgets
extension MainScreenExtension on BuildContext {
  MainScreenController? get mainScreen =>
      findAncestorStateOfType<_MainScreenState>();
}
