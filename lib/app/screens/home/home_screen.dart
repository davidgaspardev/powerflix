/// External package
import 'package:flutter/material.dart';


/// Internal packages
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/screens/home/home_controller.dart';
import 'package:powerflix/app/screens/home/widgets/cardflix.dart';
import 'package:powerflix/app/screens/home/widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  /// Location of the page in the [MaterialApp] route engine
  static const routeName = "/home";

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Home Screen
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HomeController controller;
  late final AnimationController animationController;
  late final Animation<double> heightAnimation;

  _HomeScreenState()
      : controller = Provider.createController(() => HomeController());

  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  void _log(String widgetName, {String? message}) {
    print("[ HomeScreen | $widgetName ] $message");
  }

  Widget content() {
    return ValueListenableBuilder(
        valueListenable: controller.openMenu,
        builder: (BuildContext context, bool openMenu, Widget? child) {

          print("openMenu: $openMenu");
          if (openMenu) {
            animationController.forward();
          } else {
            animationController.reverse();
          }

          return AnimatedBuilder(
              animation: heightAnimation,
              builder: (context, _) => Container(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: (100 * animationController.value) + 50,
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        background: SafeArea(
                          top: true,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 100 * animationController.value,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                ),
                                child: Opacity(
                                  opacity: 1.0 * animationController.value,
                                  child: Text("Test"),
                                ),
                              ),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                ),
                                child: GestureDetector(
                                  onTap: controller.toggleMenu,
                                  child: Image.asset(
                                    "lib/app/assets/image/logo.png",
                                    height: 45,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1417 / 2008,
                          // mainAxisSpacing: 5,
                          crossAxisSpacing: 10),
                      delegate: SliverChildBuilderDelegate((_, int index) {
                        _log("SliverGrid", message: "widget $index builded");
                        return Padding(
                          padding: index.isEven
                              ? EdgeInsets.only(left: 10, top: 10)
                              : EdgeInsets.only(right: 10, top: 10),
                          child: Cardflix(data: controller.cards[index]),
                        );
                      }, childCount: controller.cards.length),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }

  /// Function to create the screen
  Widget screen() {
    return FutureBuilder(
      future: controller.loadCards(),
      builder: (BuildContext context, AsyncSnapshot<void> asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            return content();

          default:
            return Loading();
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
