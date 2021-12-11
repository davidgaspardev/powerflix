import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:video_player/video_player.dart';

class VideoController extends Controller {

  late final VideoPlayerController player;
  late final String link;

  VideoController({ required this.link }):
  player = VideoPlayerController.network(link);

  bool _videoEneded() {
    return player.value.position.inSeconds >= player.value.duration.inSeconds;
  }

  // void _onVideoProgress() {
  //   if(_videoEneded()) {
  //     player.removeListener(_onVideoProgress);
  //     _toBack();
  //   }
  // }

  void back() {
    Navigator.of(context).pop();
  }

  Future<void> loadVideo() async {
    try {
      await player.initialize();
      player.setLooping(true);
      player.play();

      // player.addListener(_onVideoProgress);
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