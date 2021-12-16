/// External package
import 'package:flutter/material.dart';

/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/models/cardflix_data.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';

class CardflixController extends Controller {

  final CardflixData data;
  final modulePositionNotifier = ValueNotifier<int>(0);
  final favoriteNotifier = ValueNotifier<bool>(false);

  CardflixController({ required this.data });

  void toVideoPage(String link) {
    Navigator.of(context).pushNamed(
      VideoScreen.routeName,
      arguments: link
    );
  }

  void switchFavorite() {
    favoriteNotifier.value = !favoriteNotifier.value;
  }

  void onPageChanged(int position) {
    modulePositionNotifier.value = position;
  }
  
  @override
  void dispose() {
    modulePositionNotifier.dispose();
    favoriteNotifier.dispose();
  }
}