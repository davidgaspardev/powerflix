/// Standard package
import 'dart:math' show Random;
/// External package
import 'package:flutter/material.dart';
/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_screen.dart';

/// Home controller
class HomeController extends Controller {
  /// Reference to the location in the tree structure
  late final BuildContext context;
  List<CardData> _cards = [];
  List<CardData> get cards => _cards;

  void navigateCardflix(CardData data) {
    Navigator.of(context).pushNamed(CardflixScreen.routeName, arguments: data);
  }

  /// Load the cards from the local device and the server.
  /// If the cards from the server are already more up to date, then
  /// the cards from the server are downloaded and updated on the local device.
  Future<void> loadCards() async {
    for(int i = 0; i < 20; i++) _cards.add(CardData.fromMap({
      "id": Random().nextInt(1000).toString(),
      "name": "Bumbum na lua",
      "description": "Para voçê que busca massa muscular no bumbum.",
      "cover": "https://m.media-amazon.com/images/M/MV5BZjBkOTAxZDItYzQ1My00OWM1LWFjMmYtZTg4ODliMzE0OTBkXkEyXkFqcGdeQXVyMTIzNTI5NTM1._V1_.jpg",
      "modules": [
        {
          "level": "SOFT",
          "description": "Carga leve contraindo o máximo possível a musculatura.",
          "frequency": {
            "repetition": 11,
            "series": 3
          },
          "exercises": [
            {
              "order": 1,
              "name": "Glúteo em 4 apoios com caneleira perna  estendida."
            },
            {
              "order": 2,
              "name": "Elevação pélvica no chão."
            },
            {
              "order": 3,
              "name": "Abdução deitada com caneleira."
            },
            {
              "order": 4,
              "name": "Agachamento isométrico."
            }
          ]
        },
        {
          "level": "HARD",
          "description": "Carga pesada contraindo o máximo possível a musculatura.",
          "frequency": {
            "repetition": 15,
            "series": 5
          },
          "exercises": [
            {
              "order": 1,
              "name": "Glúteo em 4 apoios com caneleira perna  estendida."
            },
            {
              "order": 2,
              "name": "Elevação pélvica no chão."
            },
            {
              "order": 3,
              "name": "Abdução deitada com caneleira."
            },
            {
              "order": 4,
              "name": "Agachamento isométrico."
            },
            {
              "order": 5,
              "name": "Supino inclinado."
            },
          ]
        }
      ]
    }));
  }

  // ========================== OVERRIDE ========================== //

  @override
  void init(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
  }
}
