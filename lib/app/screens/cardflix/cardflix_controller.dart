import 'package:flutter/src/widgets/framework.dart';
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/models/card_data.dart';

class CardflixController extends Controller {

  late final BuildContext _context;
  final CardData data;

  CardflixController({ required this.data });


  @override
  void init(BuildContext context) {
    _context = context;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}