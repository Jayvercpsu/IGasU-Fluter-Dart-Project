import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/gas_law_content.dart';
import 'main_screen.dart';

class VideoTutorialsPage extends StatelessWidget {
  const VideoTutorialsPage({super.key});

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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeaderCard(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: videoTutorialReferences.length,
                itemBuilder: (context, index) {
                  final video = videoTutorialReferences[index];
                  return _buildVideoCard(context, video);
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
            const Icon(Icons.ondemand_video, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Gas Laws Video Tutorials',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${videoTutorialReferences.length} tutorials ready to play',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoTutorialReference video) {
    final lesson = _lessonFor(video.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (lesson == null) {
            _showVideoOnlyDetails(context, video);
            return;
          }
          _showLessonDetails(context, lesson, video);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: video.color,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: video.color.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.subtitle ?? lesson?.header ?? 'Video tutorial',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(
                          label: 'Tutorial',
                          textColor: video.color,
                          backgroundColor: video.color.withValues(alpha: 0.12),
                        ),
                        _buildChip(
                          label: video.duration,
                          textColor: video.color,
                          backgroundColor: video.color.withValues(alpha: 0.12),
                        ),
                        if (lesson != null)
                          _buildChip(
                            label: lesson.type.formula,
                            textColor: video.color,
                            backgroundColor: video.color.withValues(
                              alpha: 0.12,
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
    );
  }

  TutorialLesson? _lessonFor(GasLawType? type) {
    if (type == null) {
      return null;
    }

    for (final lesson in tutorialLessons) {
      if (lesson.type == type) {
        return lesson;
      }
    }
    return null;
  }

  Widget _buildChip({
    required String label,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
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
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lesson.type.color,
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
                      const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 40,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lesson.type.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                    const SizedBox(height: 8),
                    _AssetVideoPlayer(
                      videoAssetPath: video.videoAssetPath,
                      accentColor: lesson.type.color,
                      fallbackDurationLabel: video.duration,
                    ),
                    const SizedBox(height: 20),
                    _buildFormulaCard(lesson),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Overview'),
                    const SizedBox(height: 8),
                    Text(
                      '${lesson.welcomeLine}\n\n${lesson.lessonSummary}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Key points'),
                    const SizedBox(height: 8),
                    ...lesson.keyPoints.map(_buildBulletPoint),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Why it happens'),
                    const SizedBox(height: 8),
                    ...lesson.whyItHappens.map(_buildBulletPoint),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Reminders'),
                    const SizedBox(height: 8),
                    ...lesson.reminders.map(_buildBulletPoint),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Worked example'),
                    const SizedBox(height: 8),
                    Text(
                      lesson.exampleQuestion,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      title: 'Enter in iGasU',
                      color: lesson.type.color,
                      lines: lesson.exampleInputs,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      title: 'Step-by-step solution',
                      color: lesson.type.color,
                      lines: lesson.exampleSteps,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      title: 'Final answer',
                      color: lesson.type.color,
                      lines: [lesson.finalAnswer],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToProblems(
                          pageContext,
                          selectedType: lesson.type,
                        );
                      },
                      icon: const Icon(Icons.quiz_outlined),
                      label: const Text('Practice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lesson.type.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                video.subtitle ?? 'Supplementary tutorial content',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Tutorial Video'),
              const SizedBox(height: 8),
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
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
    return Card(
      elevation: 4,
      color: lesson.type.color.withValues(alpha: 0.1),
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
              lesson.type.formula,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: lesson.type.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        .then((_) {
          _controller.setLooping(false);
        })
        .catchError((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _hasInitError = true;
          });
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

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: value.aspectRatio == 0
                      ? 16 / 9
                      : value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                _buildControlBar(
                  context: context,
                  value: value,
                  showFullscreenAction: true,
                ),
              ],
            ),
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
    final sliderValue = currentPosition.inMilliseconds.clamp(
      0,
      sliderMax.toInt(),
    );

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => _seekBy(-_skipDuration),
                icon: const Icon(Icons.replay_10, color: Colors.white),
              ),
              IconButton(
                onPressed: () => _seekBy(_skipDuration),
                icon: const Icon(Icons.forward_10, color: Colors.white),
              ),
              if (showFullscreenAction)
                IconButton(
                  onPressed: () => _openFullscreenPlayer(context),
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                )
              else
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                ),
            ],
          ),
          Row(
            children: [
              Text(
                _formatDuration(currentPosition),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: sliderValue.toDouble(),
                    min: 0,
                    max: sliderMax,
                    activeColor: widget.accentColor,
                    inactiveColor: Colors.white24,
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
                      setState(() {
                        _isScrubbing = false;
                      });
                      await _seekTo(target);
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: const TextStyle(color: Colors.white, fontSize: 11),
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

  Future<void> _seekBy(Duration offset) async {
    final value = _controller.value;
    if (!value.isInitialized) {
      return;
    }

    final target = value.position + offset;
    await _seekTo(target);
  }

  Future<void> _seekTo(Duration target) async {
    final value = _controller.value;
    if (!value.isInitialized) {
      return;
    }

    final totalDuration = _effectiveDuration(value);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (totalDuration > Duration.zero && target > totalDuration
              ? totalDuration
              : target);
    final wasPlaying = value.isPlaying;
    await _controller.pause();
    await _controller.seekTo(clamped);
    if (wasPlaying) {
      await _controller.play();
    }
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
      height: 220,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
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

  Duration? _parseDurationLabel(String? input) {
    if (input == null) {
      return null;
    }
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]);
      final seconds = int.tryParse(parts[1]);
      if (minutes == null || seconds == null) {
        return null;
      }
      return Duration(minutes: minutes, seconds: seconds);
    }

    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]);
      final minutes = int.tryParse(parts[1]);
      final seconds = int.tryParse(parts[2]);
      if (hours == null || minutes == null || seconds == null) {
        return null;
      }
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }

    return null;
  }

  String _formatDuration(Duration value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(value.inMinutes.remainder(60));
    final seconds = twoDigits(value.inSeconds.remainder(60));
    if (value.inHours > 0) {
      return '${value.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
