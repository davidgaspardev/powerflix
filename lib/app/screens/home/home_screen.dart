/// External package
import 'package:flutter/material.dart';
/// Internal packages
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/home/home_controller.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  /// Location of the page in the [MaterialApp] route engine
  static var routeName = "/home";
  /// Initialize [HomeController] along with instantiation 
  final controller = HomeController();

  /// Function to create the screen
  Widget screen() {
    return Container(
      child: Center(
        child: GestureDetector(
          onTap: controller.increment,
          child: ValueListenableBuilder(
            valueListenable: controller.countNotifier,
            builder: (BuildContext context, int count, Widget? _) {
              return Text("count: $count");
            },
          ),
        ),
      ),
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
