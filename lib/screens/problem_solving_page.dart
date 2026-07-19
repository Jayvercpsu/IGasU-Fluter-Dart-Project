import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../components/fraction_widget.dart';
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
          _buildSolutionLines(),
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

  Widget _buildSolutionLines() {
    final lines = _currentProblem.solutionLines;
    final textStyle = GoogleFonts.inter(
      color: AppColors.textPrimary,
      fontSize: 13,
      height: 1.55,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          if (line.contains(' | ')) {
            final parts = line.split(' | ');
            if (parts.length == 2) {
              final numeratorLine = parts[0];
              final denominator = parts[1].trim();
              String leftPart;
              String numerator;

              if (numeratorLine.contains(' @@ ')) {
                final np = numeratorLine.split(' @@ ');
                leftPart = '${np[0].trim()} ';
                numerator = np[1].trim();
              } else {
                final words = numeratorLine.split(' ');
                if (words.length >= 2) {
                  numerator = words.last;
                  leftPart =
                      '${words.sublist(0, words.length - 1).join(' ')} ';
                } else {
                  leftPart = '';
                  numerator = numeratorLine;
                }
              }

              return FractionWidget(
                leftPart: leftPart,
                numerator: numerator,
                denominator: denominator,
                color: AppColors.textPrimary,
                textStyle: textStyle,
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(line, style: textStyle),
          );
        }).toList(),
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
  static const Duration _skipDuration = Duration(seconds: 10);
  VideoPlayerController? _localController;
  YoutubePlayerController? _youtubeController;
  Duration? _fallbackDuration;
  bool _hasError = false;
  bool _isCompleted = false;
  bool _isScrubbing = false;
  Duration _scrubPosition = Duration.zero;
  bool _resumeAfterScrub = false;

  @override
  void initState() {
    super.initState();
    if (widget.video.videoUrl != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.video.videoUrl!)!,
        flags: const YoutubePlayerFlags(autoPlay: false),
      )..addListener(_onYouTubeStateChange);
    } else {
      _fallbackDuration = _parseDurationLabel(widget.video.duration);
      _localController = VideoPlayerController.asset(widget.video.videoAssetPath)
        ..addListener(_handleVideoTick);
      _localController!
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
  }

  @override
  void dispose() {
    if (_youtubeController != null) {
      _youtubeController!.removeListener(_onYouTubeStateChange);
    }
    _localController?.removeListener(_handleVideoTick);
    _localController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _onYouTubeStateChange() {
    if (!mounted) return;
    final value = _youtubeController!.value;
    if (!_isCompleted && value.isReady && !value.isFullScreen) {
      if (value.position >= value.metaData.duration - const Duration(milliseconds: 700)) {
        setState(() => _isCompleted = true);
      }
    }
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
    if (widget.video.videoUrl != null) {
      return _buildYouTubePlayer();
    }

    if (_hasError) {
      return _buildFallback('Unable to load local video file.');
    }

    final value = _localController!.value;
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
        children: [_buildVideoSurface(value), _buildControls(value)],
      ),
    );
  }

  Widget _buildYouTubePlayer() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController!,
        progressIndicatorColor: widget.video.color,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: widget.video.color,
              handleColor: widget.video.color,
            ),
          ),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: player,
        );
      },
    );
  }

  Widget _buildVideoSurface(VideoPlayerValue value) {
    final showCenterControl = !value.isPlaying || value.isBuffering;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlayPause,
      child: AspectRatio(
        aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            VideoPlayer(_localController!),
            AnimatedOpacity(
              opacity: showCenterControl ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: value.isBuffering
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(VideoPlayerValue value) {
    final duration = _effectiveDuration(value);
    final hasKnownDuration = duration.inMilliseconds > 0;
    final position = _isScrubbing ? _scrubPosition : value.position;
    final max = hasKnownDuration ? duration.inMilliseconds.toDouble() : 1.0;
    final sliderValue = position.inMilliseconds.toDouble().clamp(0.0, max);

    return Container(
      color: AppColors.textPrimary,
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                activeTrackColor: widget.video.color,
                inactiveTrackColor: Colors.white24,
                thumbColor: widget.video.color,
                overlayColor: widget.video.color.withValues(alpha: 0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: sliderValue,
                min: 0,
                max: max,
                onChangeStart: hasKnownDuration ? _startScrub : null,
                onChanged: hasKnownDuration ? _updateScrub : null,
                onChangeEnd: hasKnownDuration
                    ? (rawValue) => unawaited(_endScrub(rawValue))
                    : null,
              ),
            ),
          ),
          Row(
            children: [
              _controlButton(
                onPressed: _togglePlayPause,
                icon: SvgPicture.asset(
                  value.isPlaying
                      ? 'assets/images/pause.svg'
                      : 'assets/images/play.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              _controlButton(
                onPressed: () => _seekBy(-_skipDuration),
                icon: const Icon(
                  Icons.replay_10_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              _controlButton(
                onPressed: () => _seekBy(_skipDuration),
                icon: const Icon(
                  Icons.forward_10_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${_formatDuration(position)} / '
                "${hasKnownDuration ? _formatDuration(duration) : '--:--'}",
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: const EdgeInsets.all(4),
      splashRadius: 18,
    );
  }

  void _startScrub(double rawValue) {
    final value = _localController!.value;
    if (!value.isInitialized) return;

    _resumeAfterScrub = value.isPlaying;
    final target = _clampToDuration(
      Duration(milliseconds: rawValue.round()),
      value,
    );
    setState(() {
      _isScrubbing = true;
      _scrubPosition = target;
    });
    if (value.isPlaying) {
      unawaited(_localController!.pause());
    }
    unawaited(_localController!.seekTo(target));
  }

  void _updateScrub(double rawValue) {
    final value = _localController!.value;
    if (!value.isInitialized) return;

    final target = _clampToDuration(
      Duration(milliseconds: rawValue.round()),
      value,
    );
    setState(() => _scrubPosition = target);
    unawaited(_localController!.seekTo(target));
  }

  Future<void> _endScrub(double rawValue) async {
    final value = _localController!.value;
    if (!value.isInitialized) return;

    final target = _clampToDuration(
      Duration(milliseconds: rawValue.round()),
      value,
    );
    await _localController!.seekTo(target);
    if (!mounted) return;

    setState(() {
      _isScrubbing = false;
      _scrubPosition = target;
    });
    if (_resumeAfterScrub) {
      await _localController!.play();
    }
    _resumeAfterScrub = false;
  }

  Future<void> _seekBy(Duration offset) async {
    final value = _localController!.value;
    if (!value.isInitialized) return;
    await _seekTo(value.position + offset);
  }

  Future<void> _seekTo(Duration target) async {
    final value = _localController!.value;
    if (!value.isInitialized) return;
    final clamped = _clampToDuration(target, value);
    final wasPlaying = value.isPlaying;
    await _localController!.pause();
    await _localController!.seekTo(clamped);
    if (wasPlaying) await _localController!.play();
  }

  Duration _effectiveDuration(VideoPlayerValue value) {
    if (value.duration > Duration.zero) {
      return value.duration;
    }
    if (_fallbackDuration != null) {
      return _fallbackDuration!;
    }
    return Duration.zero;
  }

  Duration _clampToDuration(Duration target, VideoPlayerValue value) {
    final duration = _effectiveDuration(value);
    if (target < Duration.zero) return Duration.zero;
    if (duration > Duration.zero && target > duration) return duration;
    return target;
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
    final value = _localController!.value;
    if (!mounted || !value.isInitialized) return;
    final duration = value.duration;
    final completed =
        !_isCompleted &&
        duration > Duration.zero &&
        value.position >= duration - const Duration(milliseconds: 700);
    if (completed) {
      setState(() => _isCompleted = true);
      return;
    }
    setState(() {});
  }

  void _togglePlayPause() {
    final value = _localController!.value;
    if (value.isPlaying) {
      _localController!.pause();
      return;
    }
    final duration = _effectiveDuration(value);
    if (_isCompleted &&
        duration > Duration.zero &&
        value.position >= duration) {
      _localController!.seekTo(Duration.zero);
    }
    _localController!.play();
  }

  Duration? _parseDurationLabel(String? input) {
    if (input == null) return null;
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) return null;

    final colonParts = trimmed.split(':').map((p) => p.trim()).toList();
    if (colonParts.length == 2 || colonParts.length == 3) {
      final allNumeric = colonParts.every((p) => int.tryParse(p) != null);
      if (allNumeric) {
        if (colonParts.length == 2) {
          return Duration(
            minutes: int.parse(colonParts[0]),
            seconds: int.parse(colonParts[1]),
          );
        }
        return Duration(
          hours: int.parse(colonParts[0]),
          minutes: int.parse(colonParts[1]),
          seconds: int.parse(colonParts[2]),
        );
      }
    }

    final minuteMatch = RegExp(
      r'^(\d+(?:\.\d+)?)\s*(m|min|mins|minute|minutes)$',
    ).firstMatch(trimmed);
    if (minuteMatch != null) {
      final minutes = double.parse(minuteMatch.group(1)!);
      return Duration(milliseconds: (minutes * 60000).round());
    }

    final secondMatch = RegExp(
      r'^(\d+(?:\.\d+)?)\s*(s|sec|secs|second|seconds)?$',
    ).firstMatch(trimmed);
    if (secondMatch != null) {
      final seconds = double.parse(secondMatch.group(1)!);
      return Duration(milliseconds: (seconds * 1000).round());
    }

    return null;
  }

  String _formatDuration(Duration value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(value.inMinutes.remainder(60));
    final seconds = twoDigits(value.inSeconds.remainder(60));
    if (value.inHours > 0) return '${value.inHours}:$minutes:$seconds';
    return '$minutes:$seconds';
  }
}
