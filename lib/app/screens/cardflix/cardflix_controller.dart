import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';

class CardflixController extends Controller {

  final CardData data;
  final modulePositionNotifier = ValueNotifier<int>(0);

  CardflixController({ required this.data });

  void toVideoPage(String link) {
    Navigator.of(context).pushNamed(
      VideoScreen.routeName,
      // arguments: "https://firebasestorage.googleapis.com/v0/b/tfr-card-1f68c.appspot.com/o/VID_20211013_221039.mp4?alt=media&token=82383645-8fe4-4331-8507-bd8fda6662ce",
      arguments: link
    );
  }

  void onPageChanged(int position) {
    modulePositionNotifier.value = position;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    // TODO: implement init
  }
}