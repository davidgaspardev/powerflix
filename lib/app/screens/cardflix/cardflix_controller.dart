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
      arguments: link
    );
  }

  void onPageChanged(int position) {
    modulePositionNotifier.value = position;
  }
  
  @override
  void dispose() {
    modulePositionNotifier.dispose();
  }
}