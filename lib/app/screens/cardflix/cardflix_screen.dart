import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';

/// Cardflix Screen
class CardflixScreen extends StatelessWidget {

  final CardflixController controller;
  static const routeName = "/cardflix";

  CardflixScreen({ Key? key, required CardData data }): 
  controller = CardflixController(data: data), 
  super(key: key);

  Widget screen() {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Center(
                  // alignment: Alignment.center,
                  child: Hero(
                    tag: "cardflix-cover", 
                    child: Container(
                      width: 335,
                      height: 496,
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(controller.data.cover),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                );
              },
              childCount: 1
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      controller: controller, 
      screen: screen,
    );
  }
}