import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/home/home_controller.dart';

/// Cardflix widget
/// 
/// This widget is using in the present home screen grid list.
class Cardflix extends StatelessWidget {

  /// Strutucture data present in widget to be 
  /// rendered on screen 
  final CardData data;

  /// Constructor
  const Cardflix({ 
    Key? key,
    required this.data
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieving controller above this widget
    final controller = Provider.of<HomeController>(context);

    // Return widget
    return GestureDetector(
      onTap: () {
        controller.navigateCardflix(data);
      },
      child: Hero(
        tag: "cardflix-cover",
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red,
            image: DecorationImage(
              image: NetworkImage(data.cover),
              fit: BoxFit.cover
            ),
          ),
        ),
      ),
    );
  }
}