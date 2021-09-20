/// External package
import 'package:flutter/material.dart';
/// Internal packages
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/home/home_controller.dart';
import 'package:powerflix/app/screens/home/widgets/cardflix.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  /// Location of the page in the [MaterialApp] route engine
  static const routeName = "/home";
  /// Initialize [HomeController] along with instantiation 
  final controller = HomeController();

  void _log(String widgetName, { String? message }) {
    print("[ HomeScreen | $widgetName ] $message");
  }

  /// Function to create the screen
  Widget screen() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [

        SliverAppBar(
          title: Center(
            child: Text("Powerflix", style: TextStyle(color: Colors.black,)),
          ),
          backgroundColor: Colors.white,
          // floating: true,
        ),

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 472.5/700,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              _log("SliverGrid", message: "widget $index builded");
              return Padding(
                padding: index.isEven ? EdgeInsets.only(left: 10, top: 10) : EdgeInsets.only(right: 10, top: 10),
                child: Cardflix(data: controller.cards[0]),
              );
            },
            childCount: 50
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      controller: controller,
      screen: screen,
      useMaterial: true,
    );
  }
}
