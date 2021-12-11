import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/video/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  /// Location of the page in the [MaterialApp] route engine
  static const routeName = "/video";

  /// Receive link to video by constructor parameter
  final VideoController controller;
  VideoScreen({Key? key, required String link})
      : controller =
            Provider.createController(() => VideoController(link: link)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(controller: controller, screen: buildScreen);
  }

  Widget buildScreen() {
    return Stack(
      children: [buildVideo(), buildAppBar()],
    );
  }

  Widget buildVideo() {
    final width = MediaQuery.of(controller.context).size.width;
    final height = MediaQuery.of(controller.context).size.height;

    return Container(
      child: FutureBuilder(
        future: controller.loadVideo(),
        builder: (BuildContext context, AsyncSnapshot<void> asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            // case ConnectionState.done: return AspectRatio(
            //   aspectRatio: controller.player.value.aspectRatio,
            //   child: VideoPlayer(controller.player),
            // );
            case ConnectionState.done:
              return FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: VideoPlayer(controller.player),
                ),
              );

            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget buildAppBar() {
    final statusBarHeight = MediaQuery.of(controller.context).padding.top;

    return Container(
      height: statusBarHeight + 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black45,
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: controller.back,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Label(
                  "POWERFLIX",
                  color: Colors.white,
                  padding: const EdgeInsets.only(right: 56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
