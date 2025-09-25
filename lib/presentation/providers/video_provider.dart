// lib/presentation/providers/video_provider.dart
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoProvider with ChangeNotifier {
  VideoPlayerController? _currentController;
  int? _currentIndex;
  bool _isInitializing = false;

  VideoPlayerController? get currentController => _currentController;
  int? get currentIndex => _currentIndex;
  bool get isInitializing => _isInitializing;

  Future<void> playVideo(String videoUrl, int index) async {
    // Stop any currently playing video
    stopVideo();

    _isInitializing = true;
    notifyListeners();

    _currentController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _currentIndex = index;

    // Listen for changes in the video controller's state
    _currentController!.addListener(() {
      notifyListeners();
    });

    try {
      await _currentController!.initialize();
      await _currentController!.play();
    } catch (e) {
      debugPrint('Error initializing video: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  void pauseVideo() {
    if (_currentController != null && _currentController!.value.isPlaying) {
      _currentController!.pause();
      notifyListeners();
    }
  }

  void stopVideo() {
    if (_currentController != null) {
      _currentController!.pause();
      _currentController!.dispose();
      _currentController = null;
      _currentIndex = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopVideo();
    super.dispose();
  }
}
