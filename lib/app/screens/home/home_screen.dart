/// External package
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
/// Internal packages
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/home/home_controller.dart';
import 'package:powerflix/app/screens/home/widgets/cardflix.dart';
import 'package:powerflix/app/screens/home/widgets/loading.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  /// Location of the page in the [MaterialApp] route engine
  static const routeName = "/home";
  /// Initialize [HomeController] along with instantiation 
  final controller = HomeController();

  void _log(String widgetName, { String? message }) {
    print("[ HomeScreen | $widgetName ] $message");
  }

  Widget content() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [

        SliverAppBar(
          title: Center(
            child: Image.asset(
              "lib/app/assets/image/logo.png",
              height: 45,
            )
          ),
          backgroundColor: Colors.white,
          // floating: true,
        ),

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1417/2008,
            // mainAxisSpacing: 5,
            crossAxisSpacing: 10
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              _log("SliverGrid", message: "widget $index builded");
              return Padding(
                padding: index.isEven ? EdgeInsets.only(left: 10, top: 10) : EdgeInsets.only(right: 10, top: 10),
                child: Cardflix(data: controller.cards[index]),
              );
            },
            childCount: controller.cards.length
          ),
        ),

      ],
    );
  }

  /// Function to create the screen
  Widget screen() {
    return FutureBuilder(
      future: controller.loadCards(),
      builder: (BuildContext context, AsyncSnapshot<void> asyncSnapshot) {
        switch(asyncSnapshot.connectionState) {
          case ConnectionState.done: return content();
          
          default: return Loading();
        }
      },
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
