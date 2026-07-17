import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../data/gas_law_content.dart';
import '../theme/app_colors.dart';
import 'main_screen.dart';

class VideoTutorialsPage extends StatelessWidget {
  const VideoTutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tutorials'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: videoTutorialReferences.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gas Laws Video Tutorials',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${videoTutorialReferences.length} tutorials ready to play',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          final video = videoTutorialReferences[index - 1];
          return _buildVideoCard(context, video);
        },
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoTutorialReference video) {
    final lesson = _lessonFor(video.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (lesson == null) {
              _showVideoOnlyDetails(context, video);
              return;
            }
            _showLessonDetails(context, lesson, video);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: video.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.play_circle_rounded,
                    color: video.color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.subtitle ?? lesson?.header ?? 'Video tutorial',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _buildChip(
                            label: 'Tutorial',
                            color: video.color,
                          ),
                          _buildChip(
                            label: video.duration,
                            color: video.color,
                          ),
                          if (lesson != null)
                            _buildChip(
                              label: lesson.type.formula,
                              color: video.color,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showLessonDetails(
    BuildContext pageContext,
    TutorialLesson lesson,
    VideoTutorialReference video,
  ) {
    showModalBottomSheet<void>(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 24),
              decoration: BoxDecoration(
                color: lesson.type.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lesson.type.label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lesson.description,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Tutorial Video'),
                    const SizedBox(height: 10),
                    _AssetVideoPlayer(
                      videoAssetPath: video.videoAssetPath,
                      accentColor: lesson.type.color,
                      fallbackDurationLabel: video.duration,
                    ),
                    const SizedBox(height: 24),
                    _buildFormulaCard(lesson),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Overview'),
                    const SizedBox(height: 10),
                    Text(
                      '${lesson.welcomeLine}\n\n${lesson.lessonSummary}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Key Points'),
                    const SizedBox(height: 10),
                    ...lesson.keyPoints.map(_buildBulletPoint),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Why It Happens'),
                    const SizedBox(height: 10),
                    ...lesson.whyItHappens.map(_buildBulletPoint),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Reminders'),
                    const SizedBox(height: 10),
                    ...lesson.reminders.map(_buildBulletPoint),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Worked Example'),
                    const SizedBox(height: 10),
                    Text(
                      lesson.exampleQuestion,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      title: 'Enter in iGasU',
                      color: lesson.type.color,
                      lines: lesson.exampleInputs,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      title: 'Step-by-Step Solution',
                      color: lesson.type.color,
                      lines: lesson.exampleSteps,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      title: 'Final Answer',
                      color: lesson.type.color,
                      lines: [lesson.finalAnswer],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToProblems(
                          pageContext,
                          selectedType: lesson.type,
                        );
                      },
                      icon: const Icon(Icons.quiz_outlined, size: 18),
                      label: const Text('Practice'),
                      style: FilledButton.styleFrom(
                        backgroundColor: lesson.type.color,
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

  void _showVideoOnlyDetails(
    BuildContext pageContext,
    VideoTutorialReference video,
  ) {
    showModalBottomSheet<void>(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      video.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                video.subtitle ?? 'Supplementary tutorial content',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Tutorial Video'),
              const SizedBox(height: 10),
              _AssetVideoPlayer(
                videoAssetPath: video.videoAssetPath,
                accentColor: video.color,
                fallbackDurationLabel: video.duration,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormulaCard(TutorialLesson lesson) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lesson.type.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lesson.type.color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Formula: ',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            lesson.type.formula,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: lesson.type.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.boyleBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required Color color,
    required List<String> lines,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TutorialLesson? _lessonFor(GasLawType? type) {
    if (type == null) return null;
    for (final lesson in tutorialLessons) {
      if (lesson.type == type) return lesson;
    }
    return null;
  }

  void _navigateToProblems(BuildContext context, {GasLawType? selectedType}) {
    final mainScreen = context.mainScreen;
    if (selectedType != null) {
      mainScreen?.openProblemSolvingForTopic(selectedType);
      return;
    }
    mainScreen?.pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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

class _AssetVideoPlayer extends StatefulWidget {
  const _AssetVideoPlayer({
    required this.videoAssetPath,
    required this.accentColor,
    this.fallbackDurationLabel,
  });

  final String videoAssetPath;
  final Color accentColor;
  final String? fallbackDurationLabel;

  @override
  State<_AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<_AssetVideoPlayer> {
  static const Duration _skipDuration = Duration(seconds: 10);
  late final VideoPlayerController _controller;
  Duration? _fallbackDuration;
  bool _isScrubbing = false;
  Duration _scrubPosition = Duration.zero;
  bool _hasInitError = false;

  @override
  void initState() {
    super.initState();
    _fallbackDuration = _parseDurationLabel(widget.fallbackDurationLabel);
    _controller = VideoPlayerController.asset(widget.videoAssetPath);
    _controller
        .initialize()
        .then((_) => _controller.setLooping(false))
        .catchError((_) {
      if (!mounted) return;
      setState(() => _hasInitError = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasInitError) {
      return _buildFallback('Unable to load local video file.');
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
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
                aspectRatio:
                    value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              _buildControlBar(
                context: context,
                value: value,
                showFullscreenAction: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlBar({
    required BuildContext context,
    required VideoPlayerValue value,
    required bool showFullscreenAction,
  }) {
    final totalDuration = _effectiveDuration(value);
    final currentPosition = _isScrubbing ? _scrubPosition : value.position;
    final totalMillis = totalDuration.inMilliseconds;
    final sliderMax = totalMillis <= 0 ? 1.0 : totalMillis.toDouble();
    final sliderValue = currentPosition.inMilliseconds.clamp(0, sliderMax.toInt());

    return Container(
      color: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _controlButton(
                icon: value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                onPressed: _togglePlayPause,
              ),
              _controlButton(
                icon: Icons.replay_10_rounded,
                onPressed: () => _seekBy(-_skipDuration),
              ),
              _controlButton(
                icon: Icons.forward_10_rounded,
                onPressed: () => _seekBy(_skipDuration),
              ),
              if (showFullscreenAction)
                _controlButton(
                  icon: Icons.fullscreen_rounded,
                  onPressed: () => _openFullscreenPlayer(context),
                )
              else
                _controlButton(
                  icon: Icons.fullscreen_exit_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
          Row(
            children: [
              Text(
                _formatDuration(currentPosition),
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    activeTrackColor: widget.accentColor,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: widget.accentColor,
                  ),
                  child: Slider(
                    value: sliderValue.toDouble(),
                    min: 0,
                    max: sliderMax,
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
                      final target = Duration(milliseconds: rawValue.round());
                      setState(() => _isScrubbing = false);
                      await _seekTo(target);
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (value.isBuffering)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: Colors.white54,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 22),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: const EdgeInsets.all(4),
      splashRadius: 18,
    );
  }

  Future<void> _seekBy(Duration offset) async {
    final value = _controller.value;
    if (!value.isInitialized) return;
    final target = value.position + offset;
    await _seekTo(target);
  }

  Future<void> _seekTo(Duration target) async {
    final value = _controller.value;
    if (!value.isInitialized) return;
    final totalDuration = _effectiveDuration(value);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (totalDuration > Duration.zero && target > totalDuration
            ? totalDuration
            : target);
    final wasPlaying = value.isPlaying;
    await _controller.pause();
    await _controller.seekTo(clamped);
    if (wasPlaying) await _controller.play();
  }

  void _togglePlayPause() {
    final value = _controller.value;
    if (value.isPlaying) {
      _controller.pause();
      return;
    }
    final duration = _effectiveDuration(value);
    if (duration > Duration.zero && value.position >= duration) {
      _controller.seekTo(Duration.zero);
    }
    _controller.play();
  }

  Future<void> _openFullscreenPlayer(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                if (!value.isInitialized) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: AspectRatio(
                            aspectRatio: value.aspectRatio == 0
                                ? 16 / 9
                                : value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                    _buildControlBar(
                      context: context,
                      value: value,
                      showFullscreenAction: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(String message) {
    return Container(
      width: double.infinity,
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Duration _effectiveDuration(VideoPlayerValue value) {
    if (value.duration > Duration.zero) return value.duration;
    if (_fallbackDuration != null) return _fallbackDuration!;
    return Duration.zero;
  }

  Duration? _parseDurationLabel(String? input) {
    if (input == null) return null;
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]);
      final seconds = int.tryParse(parts[1]);
      if (minutes == null || seconds == null) return null;
      return Duration(minutes: minutes, seconds: seconds);
    }
    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]);
      final minutes = int.tryParse(parts[1]);
      final seconds = int.tryParse(parts[2]);
      if (hours == null || minutes == null || seconds == null) return null;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
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
