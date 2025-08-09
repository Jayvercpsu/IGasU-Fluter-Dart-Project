import 'package:flutter/material.dart';
import 'main_screen.dart';

class ProblemSolvingPage extends StatefulWidget {
  const ProblemSolvingPage({super.key});

  @override
  State<ProblemSolvingPage> createState() => _ProblemSolvingPageState();
}

class _ProblemSolvingPageState extends State<ProblemSolvingPage> {
  final TextEditingController _givenController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _showSolution = false;
  bool _showError = false;
  String _errorMessage = '';
  String _solutionText = '';
  
  // Sample Boyle's Law problem
  final Map<String, dynamic> _currentProblem = {
    'type': 'Boyle\'s Law',
    'question': 'A gas has an initial volume of 200 L and an initial pressure of 300 atm. If the pressure increases to 450 atm while the temperature remains constant, what is the new volume of the gas?',
    'given': 'P₁ = 300 atm, V₁ = 200 L, P₂ = 450 atm',
    'answer': '133.33',
    'solution': '''Using Boyle's Law: P₁V₁ = P₂V₂

Given:
P₁ = 300 atm, V₁ = 200 L
P₂ = 450 atm, V₂ = ?

Step 1: Apply Boyle's Law formula
P₁V₁ = P₂V₂

Step 2: Solve for V₂
V₂ = (P₁V₁)/P₂

Step 3: Substitute values
V₂ = (300 × 200)/450
V₂ = 60,000/450
V₂ = 133.33 L

Therefore, the new volume is 133.33 L''',
    'color': Color(0xFF4A90E2),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem Solving'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildProblemCard(),
            const SizedBox(height: 30),
            _buildGivenSection(),
            const SizedBox(height: 20),
            _buildAnswerSection(),
            const SizedBox(height: 20),
            _buildCheckAnswerButton(),
            if (_showError) ...[
              const SizedBox(height: 20),
              _buildErrorCard(),
            ],
            if (_showSolution) ...[
              const SizedBox(height: 20),
              _buildSolutionCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentProblem['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.quiz, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_currentProblem['type']} Problem',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _currentProblem['question'],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGivenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Write down the Given:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _givenController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Write the given values here (e.g., P₁ = 300 atm, V₁ = 200 L...)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Answer:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            hintText: 'Enter your final answer (numerical value only)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckAnswerButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _checkAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Check Answer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 6,
        color: const Color(0xFFFFEBEE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.error, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ERROR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSolutionCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 6,
        color: const Color(0xFFF0F8F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CB85C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lightbulb, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SOLUTION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5CB85C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _solutionText,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAnswer() {
    setState(() {
      _showError = false;
      _showSolution = false;
    });

    // Check if given is correct
    String givenInput = _givenController.text.toLowerCase().replaceAll(' ', '');
    String correctGiven = _currentProblem['given'].toLowerCase().replaceAll(' ', '');
    
    // Remove special characters for comparison
    givenInput = givenInput.replaceAll(RegExp(r'[₁₂=]'), '');
    correctGiven = correctGiven.replaceAll(RegExp(r'[₁₂=]'), '');

    if (!_isGivenCorrect(givenInput, correctGiven)) {
      setState(() {
        _showError = true;
        _errorMessage = 'Incorrect Given! Please write down the correct given values.\n\nCorrect Given: ${_currentProblem['given']}';
      });
      return;
    }

    // Check answer
    String userAnswer = _answerController.text.trim();
    String correctAnswer = _currentProblem['answer'];

    if (userAnswer.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter your answer!';
      });
      return;
    }

    double? userValue = double.tryParse(userAnswer);
    double? correctValue = double.tryParse(correctAnswer);

    if (userValue == null) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter a valid numerical answer!';
      });
      return;
    }

    // Check if answer is within acceptable range (±0.1)
    if (correctValue != null && (userValue - correctValue).abs() <= 0.1) {
      setState(() {
        _showSolution = true;
        _solutionText = 'Correct! 🎉\n\n${_currentProblem['solution']}';
      });
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'Incorrect answer! Please try again.\n\nHint: Check your calculations and make sure you\'re using the correct formula.';
      });
    }
  }

  bool _isGivenCorrect(String userGiven, String correctGiven) {
    // Check if user input contains key elements
    List<String> requiredElements = ['p1=300', 'v1=200', 'p2=450'];
    
    for (String element in requiredElements) {
      if (!userGiven.contains(element.replaceAll('=', ''))) {
        return false;
      }
    }
    return true;
  }

  void _navigateBack(BuildContext context) {
    final mainScreen = context.mainScreen;
    mainScreen?.pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _givenController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}