import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final int index;
  final String imageUrl;
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.index,
    required this.imageUrl,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl.trim()), // Use trim() for safety
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    // 2. Add Listener to trigger UI rebuild on state changes
    _controller.addListener(() {
      // We only call setState if the controller is initialized and the widget is mounted
      if (_controller.value.isInitialized && mounted) {
        setState(() {});
      }
    });

    // 3. Initialize the controller
    _initializeVideoPlayerFuture = _controller.initialize();

    // Optional: Auto-play the video after initialization
    _initializeVideoPlayerFuture.then((_) {
      if (widget.index == 0) {
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        // Show loading spinner while initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error (e.g., bad URL, network issue)
        if (snapshot.hasError) {
          return Center(child: Text('Error loading video: ${snapshot.error}'));
        }

        // Video is initialized, show the player and controls
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1. Video Display (maintains aspect ratio)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  /*isNeedToAutoPlay
                      ?*/ VideoPlayer(_controller),
                    //  : CachedNetworkImage(imageUrl: widget.imageUrl),

                  // 2. Play/Pause Control Overlay
                  _PlayPauseControl(controller: _controller),

                  // 3. Seekable Progress Bar
               /*   isNeedToAutoPlay
                      ? VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.red,
                            bufferedColor: Colors.white54,
                          ),
                        )
                      : const SizedBox.shrink(),*/
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayPauseControl extends StatelessWidget {
  const _PlayPauseControl({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Background overlay and center icon when paused
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),

        // Tap detector to toggle play/pause
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
