/// External package
import 'package:flutter_test/flutter_test.dart';
/// Internal package
import 'package:powerflix/app/models/cardflix_data.dart';

void main() {
  group("Testing Card Data Model", () {

    Map<String, dynamic> data = {
      "name": "Bumbum na lua",
      "description": "Para voçê que busca massa muscular no bumbum.",
      "cover": "https://powerflix.tfr.health/bumbum.png",
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
    };

    List<Map<String, dynamic>> testData = [
      /// data 1
      {
        "name": "Bumbum na lua",
        "description": "Para voçê que busca massa muscular no bumbum.",
        "cover": "https://powerflix.tfr.health/bumbum.png",
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
      },

      /// data 2
      {
        "name": "Biceps de pedra",
        "description": "Para voçê que busca massa muscular no biceps.",
        "cover": "https://powerflix.tfr.health/rock_bi.png",
        "modules": [
          {
            "level": "LIGHT",
            "description": "Carga leve contraindo o máximo possível a musculatura.",
            "frequency": {
              "repetition": 8,
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
                "name": "Supino inclinado."
              },
            ]
          }
        ]
      },

      /// data 3
      {
        "name": "Deivid Jordão",
        "description": "Aula com o Jordão",
        "cover": "https://powerflix.tfr.health/deivid.png",
        "modules": [
          {
            "level": "MEDIUM",
            "description": "Carga leve contraindo o máximo possível a musculatura.",
            "frequency": {
              "repetition": 18,
              "series": 10
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
          },
          {
            "level": "HARD",
            "description": "Carga pesada contraindo o máximo possível a musculatura.",
            "frequency": {
              "repetition": 50,
              "series": 7
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
      }
    ];

    test("Initializing a card", () {
      CardflixData card = CardflixData.fromMap(data);

      expect(card.toMap(), data);
    });

    test("Initializing cards", () {
      List<CardflixData> cards = [];

      for(int i = 0; i < testData.length; i++) {
        cards.add(CardflixData.fromMap(testData[i]));

        print("\nCard $i: ${cards[i].toJson()}");
      }

      print("");

      expect(cards.length, testData.length);
      
      for(int i = 0; i < testData.length; i++) {
        expect(cards[i].toMap(), testData[i]);
      }

    });

  });
}