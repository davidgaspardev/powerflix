/// External package
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';

class VideoController extends Controller {

  late final VideoPlayerController player;
  late final String link;

  VideoController({ required this.link }):
  player = VideoPlayerController.network(link);

  void back() {
    Navigator.of(context).pop();
  }

  Future<void> loadVideo() async {
    try {
      await player.initialize();
      player.setLooping(true);
      player.play();
    } catch(e) {
      print(e);
      back();
    }
  }

  @override
  void init() {
    // Hide status bar and naviation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    player.dispose();

    // Show status bar and naviation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
}