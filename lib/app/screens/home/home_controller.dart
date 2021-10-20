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
    _cards.add(CardData.fromMap({
      "id": Random().nextInt(1000).toString(),
      "name": "Bumbum na lua",
      "description": "Para voçê que busca massa muscular no bumbum.",
      "cover": "https://firebasestorage.googleapis.com/v0/b/tfr-system.appspot.com/o/powerflix%2Fbumbum_na_lua.jpg?alt=media&token=6cb1af2f-af4c-450c-95ca-fdb4412b6e8f",
      "modules": [
        {
          "level": "LIGHT",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 11,
            "series": 3
          },
          "exercises": [
            {
              "order": 1,
              "name": "Agachamento com peso corporal",
              "link": "https://firebasestorage.googleapis.com/v0/b/tfr-card-1f68c.appspot.com/o/VID_20211013_221039.mp4?alt=media&token=82383645-8fe4-4331-8507-bd8fda6662ce"
            },
            {
              "order": 2,
              "name": "Cadeia abdutora"
            },
            {
              "order": 3,
              "name": "Eleveção pélvica em colchonete",
              "link": "https://firebasestorage.googleapis.com/v0/b/tfr-card-1f68c.appspot.com/o/VID_20211013_221039.mp4?alt=media&token=82383645-8fe4-4331-8507-bd8fda6662ce"
            },
            {
              "order": 4,
              "name": "Glúteo máquina"
            }
          ]
        },
        {
          "level": "SOFT",
          "description": "Carga moderada e movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 9,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Agachamento no smith + agachamento unilateral no simith",
              "features": [
                {
                  "name": "BI-SET 4x9 + 9",
                  "description": "Significa realizar dois movimentos seguidos sem intervalos á cada repetição"
                }
              ]
            },
            {
              "order": 2,
              "name": "Glúteo em 4 apoios com caneleira"
            },
            {
              "order": 3,
              "name": "Agachamento em polia"
            },
            {
              "order": 4,
              "name": "Elevação pélvica na máquina 4x até a falha"
            }
          ]
        },
        {
          "level": "HARD",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimentos e seus resultados",
          "frequency": {
            "repetition": 11,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Agachamento no smith + agachamento sumô com halteres",
              "features": [
                {
                  "name": "BI-SET 4x9 + falha",
                  "description": "Significa realizar dois movimentos seguidos sem intervalos á cada repetição"
                }
              ]
            },
            {
              "order": 2,
              "name": "Glúteo em apoios com caneleira"
            },
            {
              "order": 3,
              "name": "Abdução de quadril em pé com caneleira na polia + glúteo na polia",
              "features": [
                {
                  "name": "BI-SET 4x9 + 9",
                  "description": "Significa realizar dois movimentos seguidos sem intervalos á cada repetição"
                }
              ]
            },
            {
              "order": 4,
              "name": "Agachamento búlgaro 4x até a falha"
            }
          ]
        }
      ]
    }));

    _cards.add(CardData.fromMap({
      "id": Random().nextInt(1000).toString(),
      "name": "Bíceps de pedra",
      "description": "Para voçê que busca bíceps tão duro quanto uma pedra.",
      "cover": "https://firebasestorage.googleapis.com/v0/b/tfr-system.appspot.com/o/powerflix%2Fbiceps_de_pedra.jpg?alt=media&token=b454789c-2adf-4238-bd03-c4ae37584de4",
      "modules": [
        {
          "level": "LIGHT",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 11,
            "series": 3
          },
          "exercises": [
            {
              "order": 1,
              "name": "Bíceps com barra na polia"
            },
            {
              "order": 2,
              "name": "Bíceps direto com halteres sentado"
            },
            {
              "order": 3,
              "name": "Bíceps martelo com halteres"
            },
            {
              "order": 4,
              "name": "Bíceps scott"
            }
          ]
        },
        {
          "level": "SOFT",
          "description": "Carga moderada e movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 9,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Bíceps com barra na polia + bíceps martelo com halters",
              "features": [
                {
                  "name": "BI-SET 4x9 + 9",
                  "description": "Significa realizar dois movimentos seguidos sem intervalos á cada repetição"
                }
              ]
            },
            {
              "order": 2,
              "name": "Bíceps alternado com halteres sentado"
            },
            {
              "order": 3,
              "name": "Bíceps concentrado com halteres"
            },
          ]
        },
        {
          "level": "HARD",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimentos e seus resultados",
          "frequency": {
            "repetition": 6,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Bíceps martelo com corda na polia"
            },
            {
              "order": 2,
              "name": "Bíceps alternado com isometria"
            },
            {
              "order": 3,
              "name": "Bíceps com barra reta rest pause",
              "features": [
                {
                  "name": "BI-SET 4x6 + falha",
                  "description": "Significa realizar dois movimentos seguidos sem intervalos á cada repetição"
                }
              ]
            },
            {
              "order": 4,
              "name": "Bíceps 21 com barra w"
            }
          ]
        }
      ]
    }));

    _cards.add(CardData.fromMap({
      "id": Random().nextInt(1000).toString(),
      "name": "Abdômen Chapado",
      "description": "Para voçê que busca abdômen top.",
      "cover": "https://firebasestorage.googleapis.com/v0/b/tfr-system.appspot.com/o/powerflix%2Fabd_chapado.jpg?alt=media&token=aa2def56-1e83-4909-8761-fed11249bf59",
      "modules": [
        {
          "level": "LIGHT",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 11,
            "series": 3
          },
          "exercises": [
            {
              "order": 1,
              "name": "Abd supra"
            },
            {
              "order": 2,
              "name": "Abd infra no chão"
            },
            {
              "order": 3,
              "name": "Abd supra com pé alto"
            },
            {
              "order": 4,
              "name": "Abd tesoura em colchonete"
            }
          ]
        },
        {
          "level": "SOFT",
          "description": "Carga moderada e movimentos lentos e concentrados para otimizar o padrão de movimento e seus resultados",
          "frequency": {
            "repetition": 9,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Abd bicicleta em colchonete"
            },
            {
              "order": 2,
              "name": "Abd escalador em colchonete",
              "features": [
                {
                  "name": "3x15",
                  "description": "Para esse exercício especifico fazer 3 series de 15 repetições."
                }
              ]
            },
            {
              "order": 3,
              "name": "Abd canivete"
            },
            {
              "order": 4,
              "name": "Abd canoa isométrica",
              "features": [
                {
                  "name": "3x15",
                  "description": "Para esse exercício especifico fazer 3 series de 15 repetições."
                }
              ]
            },
            {
              "order": 5,
              "name": "Abd infra + quadril em colchonete"
            },
          ]
        },
        {
          "level": "HARD",
          "description": "Movimentos lentos e concentrados para otimizar o padrão de movimentos e seus resultados",
          "frequency": {
            "repetition": 0,
            "series": 4
          },
          "exercises": [
            {
              "order": 1,
              "name": "Abd prancha lateral em colchonete"
            },
            {
              "order": 2,
              "name": "Abd prancha ventral isométrica"
            },
            {
              "order": 3,
              "name": "Abd tapa calcanhar"
            },
            {
              "order": 4,
              "name": "Abd remador em colchonete"
            }
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
