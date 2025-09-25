import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_provider.dart';

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
  int isManuallyPauseFirstVideo = -1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl.trim()),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      if (_controller.value.isInitialized && mounted) {
        setState(() {});
      }
    });
    _initializeVideoPlayerFuture = _controller.initialize();

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
    int videoPlayIndex = context.watch<VideoProvider>().videoIndexForAutoPlay;
    if (videoPlayIndex == widget.index &&
        isManuallyPauseFirstVideo != videoPlayIndex) {
      _controller.play();
    }
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomShimmer();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading video: ${snapshot.error}'));
        }

        return GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
              isManuallyPauseFirstVideo = videoPlayIndex;
            } else {
              isManuallyPauseFirstVideo = -1;
              _controller.play();
            }
          },
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                videoPlayIndex == widget.index
                    ? VideoPlayer(_controller)
                    : CachedNetworkImage(imageUrl: widget.imageUrl),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: _controller.value.isPlaying
                      ? const SizedBox.shrink()
                      : ColoredBox(
                          color: Colors.black26,
                          child: Center(
                            child: Icon(
                              Icons.play_circle_outline_sharp,
                              color: Colors.white30,
                              size: 90,
                            ),
                          ),
                        ),
                ),

                videoPlayIndex == widget.index
                    ? VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.white54,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}
