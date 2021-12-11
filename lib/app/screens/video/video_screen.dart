import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/video/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  /// Location of the page in the [MaterialApp] route engine
  static const routeName = "/video";

  /// Receive link to video by constructor parameter
  final VideoController controller;
  VideoScreen({ Key? key, required String link }):
  controller = Provider.createController(() => VideoController(link: link)),
  super(key: key);

  Widget screen() {
    return Container(
      child: FutureBuilder(
        future: controller.loadVideo(),
        builder: (BuildContext context, AsyncSnapshot<void> asyncSnapshot) {
          switch(asyncSnapshot.connectionState) {
            // case ConnectionState.done: return AspectRatio(
            //   aspectRatio: controller.player.value.aspectRatio,
            //   child: VideoPlayer(controller.player),
            // );
            case ConnectionState.done: return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.player.value.size.width,
                height: controller.player.value.size.height,
                child: VideoPlayer(controller.player),
              ),
            );

            default: return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      controller: controller,
      screen: screen
    );
  }
}