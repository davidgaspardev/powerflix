/// External package
import 'package:flutter/material.dart';

/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/helpers/data/cardflix.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_screen.dart';

/// Home controller
class HomeController extends Controller {
  /// Reference to the location in the tree structure
  List<CardData> _cards = [];
  List<CardData> get cards => _cards;

  void navigateCardflix(CardData data) {
    Navigator.of(context).pushNamed(CardflixScreen.routeName, arguments: data);
  }

  /// Load the cards from the local device and the server.
  /// If the cards from the server are already more up to date, then
  /// the cards from the server are downloaded and updated on the local device.
  Future<void> loadCards() async {
    _cards.add(CardData.fromMap(CardflixExamples.bumbumNaLua));

    _cards.add(CardData.fromMap(CardflixExamples.bicepsDePedra));

    _cards.add(CardData.fromMap(CardflixExamples.abdomenChapado));
  }
}
