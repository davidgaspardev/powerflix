import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:powerflix/features/video/domain/repositories/video_repository.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  final String link;
  final VideoRepository _repository;

  VideoPlayerController? _player;
  VideoPlayerController get player => _player!;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  bool get hasError => _error != null;
  String? get error => _error;

  VideoViewModel({required this.link, required VideoRepository repository})
      : _repository = repository;

  Future<void> init() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    try {
      final uri = await _repository.resolveUri(link);
      _player = VideoPlayerController.networkUrl(uri);
      await _player!.initialize();
      _player!.setLooping(true);
      _player!.play();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }
}
