import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';

class CardflixController extends Controller {

  late final BuildContext _context;
  final CardData data;

  CardflixController({ required this.data });

  void toVideoPage() {
    Navigator.of(_context).pushNamed(
      VideoScreen.routeName,
      arguments: "https://firebasestorage.googleapis.com/v0/b/tfr-card-1f68c.appspot.com/o/VID_20211013_221039.mp4?alt=media&token=82383645-8fe4-4331-8507-bd8fda6662ce",
    );
  }


  @override
  void init(BuildContext context) {
    _context = context;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}