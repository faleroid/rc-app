import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_colors.dart';

/// Native Video Player widget for Cloudflare R2 / Network videos
/// Standard 16:9 YouTube-style static aspect ratio with Fullscreen support.
class ModuleVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? fallbackImageUrl;

  const ModuleVideoPlayer({
    super.key,
    required this.videoUrl,
    this.fallbackImageUrl,
  });

  @override
  State<ModuleVideoPlayer> createState() => _ModuleVideoPlayerState();
}

class _ModuleVideoPlayerState extends State<ModuleVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  String _errorMessage = '';
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant ModuleVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initVideoPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    final oldController = _controller;
    _controller = null;
    await oldController?.dispose();

    if (mounted) {
      setState(() {
        _isInitialized = false;
        _hasError = false;
        _errorMessage = '';
      });
    }

    final url = widget.videoUrl?.trim() ?? '';
    if (url.isEmpty) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'URL video tidak valid atau belum tersedia';
        });
      }
      return;
    }

    debugPrint('[ModuleVideoPlayer] Initializing video from: $url');

    try {
      final uri = Uri.parse(url);
      final controller = VideoPlayerController.networkUrl(uri);

      _controller = controller;
      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      controller.addListener(_onVideoUpdate);

      setState(() {
        _isInitialized = true;
      });

      debugPrint('[ModuleVideoPlayer] Initialized successfully. '
          'Duration: ${controller.value.duration}');
    } catch (e) {
      debugPrint('[ModuleVideoPlayer] Initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          final errStr = e.toString();
          if (errStr.contains('ExoPlaybackException') || errStr.contains('exoplayer') || url.contains('.webm')) {
            _errorMessage = 'Format video (.webm VP9/Opus) tidak didukung oleh decoder HP/Emulator ini. Harap gunakan format MP4 (H.264/AAC).';
          } else {
            _errorMessage = 'Gagal memuat video: $e';
          }
        });
      }
    }
  }

  void _onVideoUpdate() {
    final ctrl = _controller;
    if (!mounted || ctrl == null) return;

    if (ctrl.value.hasError) {
      debugPrint('[ModuleVideoPlayer] Playback error: ${ctrl.value.errorDescription}');
      setState(() {
        _hasError = true;
        final desc = ctrl.value.errorDescription ?? '';
        if (desc.contains('ExoPlaybackException') || desc.contains('exoplayer') || (widget.videoUrl?.contains('.webm') ?? false)) {
          _errorMessage = 'Format video (.webm VP9/Opus) tidak didukung oleh decoder HP/Emulator ini. Harap gunakan format MP4 (H.264/AAC).';
        } else {
          _errorMessage = desc.isNotEmpty ? desc : 'Gagal memutar video';
        }
      });
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _togglePlayPause() {
    final ctrl = _controller;
    if (ctrl == null || !_isInitialized) return;

    if (ctrl.value.isPlaying) {
      ctrl.pause();
      setState(() {
        _showControls = true;
      });
    } else {
      ctrl.play();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller != null && _controller!.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _toggleFullscreen() {
    if (_isFullscreen) {
      Navigator.of(context).pop();
    } else {
      _openFullscreen(context);
    }
  }

  void _openFullscreen(BuildContext context) {
    setState(() {
      _isFullscreen = true;
    });

    // Hide system UI overlays for immersive fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: _buildPlayerContent(isFull: true),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((_) {
      // Restore system UI on exiting fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if (mounted) {
        setState(() {
          _isFullscreen = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || widget.videoUrl == null || widget.videoUrl!.trim().isEmpty) {
      return _buildErrorPlaceholder();
    }

    if (!_isInitialized || _controller == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    // Static 16:9 YouTube-style container for inline player
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _buildPlayerContent(isFull: false),
    );
  }

  Widget _buildPlayerContent({required bool isFull}) {
    final value = _controller!.value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video Display
            Positioned.fill(
              child: FittedBox(
                fit: isFull ? BoxFit.contain : BoxFit.contain,
                child: SizedBox(
                  width: value.size.width > 0 ? value.size.width : 1280,
                  height: value.size.height > 0 ? value.size.height : 720,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),

            // Controls Overlay
            if (_showControls || !value.isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: Stack(
                    children: [
                      // Play / Pause Button in Center
                      Center(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30, width: 1),
                            ),
                            child: Icon(
                              value.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Toolbar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.primary,
                                  bufferedColor: Colors.white30,
                                  backgroundColor: Colors.white12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _controller!.setVolume(
                                              value.volume == 0 ? 1.0 : 0.0);
                                        },
                                        child: Icon(
                                          value.volume == 0
                                              ? Icons.volume_off
                                              : Icons.volume_up,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: _toggleFullscreen,
                                        child: Icon(
                                          _isFullscreen
                                              ? Icons.fullscreen_exit_rounded
                                              : Icons.fullscreen_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        color: AppColors.cardDark,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.fallbackImageUrl != null &&
                widget.fallbackImageUrl!.isNotEmpty)
              Image.network(
                widget.fallbackImageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            Container(color: Colors.black54),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white54,
                  size: 56,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Video Modul Tidak Tersedia',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
