import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/widgets.dart';
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:video_player/video_player.dart';

class VideoController extends Controller {

  late final VideoPlayerController player;
  late final String link;
  late final BuildContext _context;

  VideoController({ required this.link }):
  player = VideoPlayerController.network(link);

  bool _videoEneded() {
    return player.value.position.inSeconds >= player.value.duration.inSeconds;
  }

  void _onVideoProgress() {
    if(_videoEneded()) {
      player.removeListener(_onVideoProgress);
      _toBack();
    }
  }

  void _toBack() {
    Navigator.of(_context).pop();
  }

  Future<void> loadVideo() async {
    try {
      await player.initialize();
      player.play();

      player.addListener(_onVideoProgress);
    } catch(e) {
      print(e);
      _toBack();
    }
  }

  @override
  void init(BuildContext context) {
    _context = context;
  }

  @override
  void dispose() {
    player.dispose();
  }
}