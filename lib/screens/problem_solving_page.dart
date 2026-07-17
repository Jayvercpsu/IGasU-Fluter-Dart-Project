import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../data/gas_law_content.dart';
import '../data/learning_stats.dart';
import '../theme/app_colors.dart';
import 'main_screen.dart';

typedef RewatchVideoHandler = Future<bool> Function(GasLawType type);

class ProblemSolvingPage extends StatefulWidget {
  const ProblemSolvingPage({this.topicRequest, this.onRewatchVideo, super.key});

  final ValueNotifier<GasLawType?>? topicRequest;
  final RewatchVideoHandler? onRewatchVideo;

  @override
  State<ProblemSolvingPage> createState() => _ProblemSolvingPageState();
}

class _ProblemSolvingPageState extends State<ProblemSolvingPage> {
  static const int _maxAttemptsPerProblem = 3;

  GasLawType _selectedType = GasLawType.boyle;
  int _currentProblemIndex = 0;
  String? _selectedChoiceLabel;
  bool _showSolution = false;
  bool _showError = false;
  String _errorMessage = '';
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

  bool get _isCurrentProblemLocked =>
      !_isCurrentProblemSolved && _attemptsRemainingForCurrentProblem == 0;

  @override
  void initState() {
    super.initState();
    widget.topicRequest?.addListener(_handleTopicRequest);
    _handleTopicRequest();
  }

  @override
  void didUpdateWidget(covariant ProblemSolvingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topicRequest == widget.topicRequest) return;
    oldWidget.topicRequest?.removeListener(_handleTopicRequest);
    widget.topicRequest?.addListener(_handleTopicRequest);
    _handleTopicRequest();
  }

  @override
  void dispose() {
    widget.topicRequest?.removeListener(_handleTopicRequest);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Problem Solver'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _buildTopicSelector(),
            const SizedBox(height: 16),
            _buildProgressHeader(),
            const SizedBox(height: 18),
            if (_isCurrentProblemLocked)
              _buildNoAttemptsCard()
            else if (_showSolution)
              _buildCorrectCard()
            else
              _buildQuestionCard(),
            if (_showError) ...[const SizedBox(height: 14), _buildErrorCard()],
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Row(
      children: GasLawType.values.map((type) {
        final isSelected = type == _selectedType;
        final color = AppColors.forGasLaw(type);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type == GasLawType.boyle ? 8 : 0,
              left: type == GasLawType.charles ? 8 : 0,
            ),
            child: InkWell(
              onTap: () => _selectProblemType(type),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  type.label,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressHeader() {
    final color = AppColors.forGasLaw(_selectedType);
    final total = _filteredProblems.length;
    final progress = total == 0 ? 0.0 : (_currentProblemIndex + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedType.label,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Question ${_currentProblemIndex + 1} of $total',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionIcon(Icons.lock_rounded),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _currentProblem.question,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._currentProblem.choices.map(_buildChoiceTile),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitAnswer,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.boyleBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Answer'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'You have $_attemptsRemainingForCurrentProblem attempts for this question.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceTile(AnswerChoice choice) {
    final isSelected = choice.label == _selectedChoiceLabel;
    final color = AppColors.forGasLaw(_selectedType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedChoiceLabel = choice.label;
            _showError = false;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.7 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? color : AppColors.textHint,
                size: 21,
              ),
              const SizedBox(width: 12),
              Text(
                '${choice.label}.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  choice.text,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: AppColors.charlesGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Correct!',
            style: GoogleFonts.inter(
              color: AppColors.charlesGreen,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Well done',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Explanation:',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _currentProblem.solutionText,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _currentProblemIndex < _filteredProblems.length - 1
                  ? () => _changeProblem(1)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.boyleBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Next Question'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAttemptsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB52E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No attempts left',
            style: GoogleFonts.inter(
              color: const Color(0xFFFF5A1F),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Text(
            'You have used all 3 attempts for this question.',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please rewatch the video to try again.',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 34),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _rewatchVideo,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.boyleBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('REWATCH VIDEO'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.errorRed),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionIcon(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.boyleBlue.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.boyleBlue, size: 22),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  void _selectProblemType(GasLawType type) {
    if (_selectedType == type) return;
    setState(() {
      _selectedType = type;
      _currentProblemIndex = 0;
      _resetProgressTracking();
      _resetFeedback();
    });
  }

  void _changeProblem(int step) {
    if (step <= 0) return;
    if (!_isCurrentProblemSolved) {
      setState(() {
        _showError = true;
        _errorMessage =
            'Choose the correct answer before going to the next question.';
      });
      return;
    }
    final nextIndex = (_currentProblemIndex + step).clamp(
      0,
      _filteredProblems.length - 1,
    );
    if (nextIndex == _currentProblemIndex) return;
    setState(() {
      _currentProblemIndex = nextIndex;
      _resetFeedback();
    });
  }

  void _submitAnswer() {
    if (_isCurrentProblemLocked || _isCurrentProblemSolved) return;

    final selectedChoiceLabel = _selectedChoiceLabel;
    if (selectedChoiceLabel == null) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please choose A, B, C, or D before submitting.';
      });
      return;
    }

    final isCorrect = selectedChoiceLabel == _currentProblem.correctChoiceLabel;
    final attemptNumber = _attemptsUsedForCurrentProblem + 1;
    _attemptsPerProblem[_currentProblemIndex] = attemptNumber;
    _stats.recordAttempt(type: _selectedType, isCorrect: isCorrect);

    if (isCorrect) {
      setState(() {
        _solvedProblems.add(_currentProblemIndex);
        _showError = false;
        _showSolution = true;
      });
      return;
    }

    setState(() {
      _selectedChoiceLabel = null;
      _showSolution = false;
      if (_attemptsRemainingForCurrentProblem == 0) {
        _showError = false;
      } else {
        _showError = true;
        _errorMessage =
            'Incorrect answer. Attempts left: $_attemptsRemainingForCurrentProblem';
      }
    });
  }

  Future<void> _rewatchVideo() async {
    final handler = widget.onRewatchVideo;
    final completed = handler == null
        ? await _showRewatchVideoSheet()
        : await handler(_selectedType);
    if (!mounted || completed != true) return;

    setState(() {
      _attemptsPerProblem[_currentProblemIndex] = 0;
      _resetFeedback();
    });
  }

  Future<bool?> _showRewatchVideoSheet() {
    final video = videoTutorialReferences.firstWhere(
      (reference) => reference.type == _selectedType,
    );
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RewatchVideoSheet(video: video),
    );
  }

  void _resetFeedback() {
    _selectedChoiceLabel = null;
    _showError = false;
    _showSolution = false;
    _errorMessage = '';
  }

  void _resetProgressTracking() {
    _attemptsPerProblem.clear();
    _solvedProblems.clear();
  }

  void _handleTopicRequest() {
    final requestedType = widget.topicRequest?.value;
    if (requestedType == null) return;
    setState(() {
      _selectedType = requestedType;
      _currentProblemIndex = 0;
      _resetProgressTracking();
      _resetFeedback();
    });
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
}

class _RewatchVideoSheet extends StatefulWidget {
  const _RewatchVideoSheet({required this.video});

  final VideoTutorialReference video;

  @override
  State<_RewatchVideoSheet> createState() => _RewatchVideoSheetState();
}

class _RewatchVideoSheetState extends State<_RewatchVideoSheet> {
  late final VideoPlayerController _controller;
  bool _hasError = false;
  bool _isCompleted = false;
  bool _isScrubbing = false;
  Duration _scrubPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video.videoAssetPath)
      ..addListener(_handleVideoTick);
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {});
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _hasError = true);
        });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleVideoTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rewatch ${widget.video.title}',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildVideo(),
              const SizedBox(height: 16),
              Text(
                _isCompleted
                    ? 'Video completed. Your attempts can be restored.'
                    : 'Finish watching the video to restore your attempts.',
                style: GoogleFonts.inter(
                  color: _isCompleted
                      ? AppColors.charlesGreen
                      : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isCompleted
                      ? () => Navigator.pop(context, true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.boyleBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Return to Question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_hasError) {
      return _buildFallback('Unable to load local video file.');
    }

    final value = _controller.value;
    if (!value.isInitialized) {
      return _buildFallback('Loading video...');
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          _buildControls(value),
        ],
      ),
    );
  }

  Widget _buildControls(VideoPlayerValue value) {
    final duration = value.duration;
    final position = _isScrubbing ? _scrubPosition : value.position;
    final max = duration.inMilliseconds <= 0
        ? 1.0
        : duration.inMilliseconds.toDouble();
    final sliderValue = position.inMilliseconds.clamp(0, max.toInt());

    return Container(
      color: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    activeTrackColor: widget.video.color,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: widget.video.color,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: sliderValue.toDouble(),
                    min: 0,
                    max: max,
                    onChangeStart: (rawValue) {
                      setState(() {
                        _isScrubbing = true;
                        _scrubPosition = Duration(
                          milliseconds: rawValue.round(),
                        );
                      });
                    },
                    onChanged: (rawValue) {
                      setState(() {
                        _scrubPosition = Duration(
                          milliseconds: rawValue.round(),
                        );
                      });
                    },
                    onChangeEnd: (rawValue) async {
                      setState(() => _isScrubbing = false);
                      await _controller.seekTo(
                        Duration(milliseconds: rawValue.round()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
              ),
              Text(
                _formatDuration(duration),
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallback(String message) {
    return Container(
      height: 210,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleVideoTick() {
    final value = _controller.value;
    if (!value.isInitialized || _isCompleted) return;
    final duration = value.duration;
    if (duration == Duration.zero) return;
    if (value.position >= duration - const Duration(milliseconds: 700)) {
      setState(() => _isCompleted = true);
    }
  }

  void _togglePlayPause() {
    final value = _controller.value;
    if (value.isPlaying) {
      _controller.pause();
      return;
    }
    if (_isCompleted && value.position >= value.duration) {
      _controller.seekTo(Duration.zero);
    }
    _controller.play();
  }

  String _formatDuration(Duration value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(value.inMinutes.remainder(60));
    final seconds = twoDigits(value.inSeconds.remainder(60));
    if (value.inHours > 0) return '${value.inHours}:$minutes:$seconds';
    return '$minutes:$seconds';
  }
}
