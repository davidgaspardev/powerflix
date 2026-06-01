import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  final String link;

  late final VideoPlayerController player;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  bool get hasError => _error != null;
  String? get error => _error;

  VideoViewModel({required this.link}) {
    player = VideoPlayerController.networkUrl(Uri.parse(link));
  }

  Future<void> init() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    try {
      await player.initialize();
      player.setLooping(true);
      player.play();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    player.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }
}
