import 'package:flutter/material.dart';

import '../data/gas_law_content.dart';
import '../data/learning_stats.dart';
import 'main_screen.dart';

class ProblemSolvingPage extends StatefulWidget {
  const ProblemSolvingPage({this.topicRequest, super.key});

  final ValueNotifier<GasLawType?>? topicRequest;

  @override
  State<ProblemSolvingPage> createState() => _ProblemSolvingPageState();
}

class _ProblemSolvingPageState extends State<ProblemSolvingPage> {
  final TextEditingController _givenController = TextEditingController();
  static const int _maxAttemptsPerProblem = 3;

  GasLawType _selectedType = GasLawType.boyle;
  int _currentProblemIndex = 0;
  bool _showSolution = false;
  bool _showError = false;
  String _errorMessage = '';
  String _solutionText = '';
  final Map<int, int> _attemptsPerProblem = <int, int>{};
  final Set<int> _solvedProblems = <int>{};
  final LearningStats _stats = LearningStats.instance;

  List<PracticeProblem> get _filteredProblems =>
      practiceProblemsFor(_selectedType);

  PracticeProblem get _currentProblem =>
      _filteredProblems[_currentProblemIndex];

  int get _attemptsUsedForCurrentProblem =>
      _attemptsPerProblem[_currentProblemIndex] ?? 0;

  int get _attemptsRemainingForCurrentProblem {
    final remaining = _maxAttemptsPerProblem - _attemptsUsedForCurrentProblem;
    return remaining < 0 ? 0 : remaining;
  }

  bool get _isCurrentProblemSolved =>
      _solvedProblems.contains(_currentProblemIndex);

  @override
  void initState() {
    super.initState();
    widget.topicRequest?.addListener(_handleTopicRequest);
    _handleTopicRequest();
  }

  @override
  void didUpdateWidget(covariant ProblemSolvingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topicRequest == widget.topicRequest) {
      return;
    }

    oldWidget.topicRequest?.removeListener(_handleTopicRequest);
    widget.topicRequest?.addListener(_handleTopicRequest);
    _handleTopicRequest();
  }

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTopicSelector(),
            const SizedBox(height: 20),
            _buildProblemCard(),
            const SizedBox(height: 20),
            _buildProblemNavigator(),
            const SizedBox(height: 30),
            _buildGivenSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            if (_showError) ...[const SizedBox(height: 20), _buildErrorCard()],
            if (_showSolution) ...[
              const SizedBox(height: 20),
              _buildSolutionCard(),
              const SizedBox(height: 16),
              _buildNextProblemButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a topic',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: GasLawType.values.map((type) {
                final isSelected = type == _selectedType;
                return ChoiceChip(
                  label: Text(
                    '${type.label} (${practiceProblemCountFor(type)})',
                  ),
                  selected: isSelected,
                  selectedColor: type.color.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                    color: isSelected ? type.color : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? type.color : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (_) => _selectProblemType(type),
                );
              }).toList(),
            ),
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
                    color: _selectedType.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.quiz, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedType.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildBadge(_selectedType.formula, _selectedType.color),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Problem ${_currentProblemIndex + 1} of ${_filteredProblems.length}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _currentProblem.question,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildBadge(
                  'Attempts left: $_attemptsRemainingForCurrentProblem',
                  _attemptsRemainingForCurrentProblem == 0
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF5CB85C),
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  _isCurrentProblemSolved ? 'Answered' : 'Not Answered',
                  _isCurrentProblemSolved
                      ? const Color(0xFF5CB85C)
                      : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemNavigator() {
    final canGoPrevious = _currentProblemIndex > 0;
    final canGoNext =
        _currentProblemIndex < _filteredProblems.length - 1 &&
        _isCurrentProblemSolved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canGoPrevious ? () => _changeProblem(-1) : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
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
              child: OutlinedButton.icon(
                onPressed: canGoNext ? () => _changeProblem(1) : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (!_isCurrentProblemSolved &&
            _currentProblemIndex < _filteredProblems.length - 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Finish this question first to unlock the next one.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
      ],
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
        const SizedBox(height: 8),
        Text(
          'Expected data: ${_currentProblem.givenText}',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _givenController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Write the given values here (for example, P1 = 2 atm, V1 = 4 L...)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _selectedType.color, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _showWorkedSolution,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Show Solution'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedType.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Check Given',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    return Card(
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
                  'Need to fix something',
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
    );
  }

  Widget _buildSolutionCard() {
    return Card(
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
                  child: const Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Worked Solution',
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
    );
  }

  Widget _buildNextProblemButton() {
    final canGoNext =
        _isCurrentProblemSolved &&
        _currentProblemIndex < _filteredProblems.length - 1;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canGoNext ? () => _changeProblem(1) : null,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Go to Next Problem'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedType.color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _selectProblemType(GasLawType type) {
    if (_selectedType == type) {
      return;
    }

    setState(() {
      _selectedType = type;
      _currentProblemIndex = 0;
      _resetProgressTracking();
      _resetInputsAndFeedback();
    });
  }

  void _changeProblem(int step) {
    if (step == 0) {
      return;
    }

    if (step > 0 && !_isCurrentProblemSolved) {
      setState(() {
        _showSolution = false;
        _showError = true;
        _errorMessage =
            'Answer the current question first before moving to the next one.';
      });
      return;
    }

    final total = _filteredProblems.length;
    final nextIndex = (_currentProblemIndex + step).clamp(0, total - 1);
    if (nextIndex == _currentProblemIndex) {
      return;
    }

    setState(() {
      _currentProblemIndex = nextIndex;
      _resetInputsAndFeedback();
    });
  }

  void _checkAnswer() {
    setState(() {
      _showError = false;
      _showSolution = false;
    });

    final previousAttempts = _attemptsUsedForCurrentProblem;
    if (previousAttempts >= _maxAttemptsPerProblem) {
      setState(() {
        _attemptsPerProblem[_currentProblemIndex] = 0;
        _showError = true;
        _errorMessage =
            'You reached the 3-attempt limit. Attempts are reset to 0, then you can try again.';
      });
      return;
    }

    final givenInput = _normalize(_givenController.text);
    final isGivenCorrect = _isGivenCorrect(givenInput, _currentProblem);
    final attemptNumber = previousAttempts + 1;
    _attemptsPerProblem[_currentProblemIndex] = attemptNumber;
    _stats.recordAttempt(type: _selectedType, isCorrect: isGivenCorrect);

    if (!isGivenCorrect) {
      final attemptsLeft = _maxAttemptsPerProblem - attemptNumber;
      setState(() {
        _showError = true;
        if (attemptsLeft == 0) {
          _attemptsPerProblem[_currentProblemIndex] = 0;
          _errorMessage =
              'The given values are incomplete or not matched correctly.\n\nCorrect given: ${_currentProblem.givenText}\n\nYou used all 3 attempts. Attempts are now reset to 0.';
        } else {
          _errorMessage =
              'The given values are incomplete or not matched correctly.\n\nCorrect given: ${_currentProblem.givenText}\n\nAttempts left: $attemptsLeft';
        }
      });
      return;
    }

    setState(() {
      _solvedProblems.add(_currentProblemIndex);
      _attemptsPerProblem[_currentProblemIndex] = 0;
      _showSolution = true;
      _solutionText = 'Given is correct.\n\n${_currentProblem.solutionText}';
    });
  }

  void _showWorkedSolution() {
    setState(() {
      _showError = false;
      _showSolution = true;
      _solutionText = _currentProblem.solutionText;
    });
  }

  bool _isGivenCorrect(String input, PracticeProblem problem) {
    return problem.givenFields.every((field) {
      final pairWithoutUnit = _normalize('${field.label}${field.value}');
      final pairWithUnit = _normalize(
        '${field.label}${field.value}${field.unit}',
      );
      return input.contains(pairWithoutUnit) || input.contains(pairWithUnit);
    });
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9.]'), '');
  }

  void _resetInputsAndFeedback() {
    _givenController.clear();
    _showError = false;
    _showSolution = false;
    _errorMessage = '';
    _solutionText = '';
  }

  void _resetProgressTracking() {
    _attemptsPerProblem.clear();
    _solvedProblems.clear();
  }

  void _handleTopicRequest() {
    final requestedType = widget.topicRequest?.value;
    if (requestedType == null) {
      return;
    }

    if (_selectedType != requestedType) {
      setState(() {
        _selectedType = requestedType;
        _currentProblemIndex = 0;
        _resetProgressTracking();
        _resetInputsAndFeedback();
      });
    } else {
      setState(() {
        _currentProblemIndex = 0;
        _resetProgressTracking();
        _resetInputsAndFeedback();
      });
    }

    widget.topicRequest?.value = null;
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
    widget.topicRequest?.removeListener(_handleTopicRequest);
    _givenController.dispose();
    super.dispose();
  }
}
