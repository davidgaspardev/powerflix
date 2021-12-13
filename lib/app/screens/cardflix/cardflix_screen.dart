/// External package
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Internal package
import 'package:powerflix/app/helpers/color.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';
import 'package:powerflix/app/screens/cardflix/widget/module_v2.dart';
import 'package:powerflix/app/screens/home/widgets/loading.dart';

/// Cardflix Screen
class CardflixScreen extends StatelessWidget {
  static const routeName = "/cardflix";

  final CardflixController controller;
  CardflixScreen({Key? key, required CardData data})
      : controller =
            Provider.createController(() => CardflixController(data: data)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      controller: controller,
      screen: buildScreen,
    );
  }

  Widget buildScreen() {
    final height = (MediaQuery.of(controller.context).size.width - 32) * 1.48;
    return Container(
      color: Colors.white,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            alignment: Alignment.center,
            child: Hero(
              tag: controller.data.id,
              child: Container(
                margin: const EdgeInsets.all(16),
                height: height,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5),
                //   image: DecorationImage(
                //     image: NetworkImage(controller.data.cover),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              controller.data.cover,
              fit: BoxFit.fill,
              loadingBuilder: loadingImage,
              errorBuilder: loadingError,
            ),
          ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      // Name
                      Label(
                        controller.data.name,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        padding: EdgeInsets.only(top: 25, bottom: 5, left: 16),
                        color: Colors.black,
                      ),

                      // Description
                      Label(
                        controller.data.description,
                        padding: EdgeInsets.only(bottom: 25, left: 16),
                      ),
                    ] +
                    buildModules(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingImage(
    BuildContext context,
    Widget child,
    ImageChunkEvent? chunk,
  ) {
    if (chunk == null) return child;
    return Loading();
  }

  Widget loadingError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return LoadingError(
      message: error.toString(),
    );
  }

  List<Widget> buildModules() {
    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label("Modulos de exercícios"),
            ValueListenableBuilder<int>(
          valueListenable: controller.modulePositionNotifier,
          builder: (context, currentPosition, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1, 2]
                .map((position) => Container(
                      width: 16,
                      height: 8,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: position == currentPosition
                            ? appColors[position]
                            : Colors.grey,
                      ),
                    ))
                .toList(),
          ),
        ),
          ],
        ),
      ),
      Container(
        height: 500,
        child: PageView(
          physics: BouncingScrollPhysics(),
          onPageChanged: controller.onPageChanged,
          children: controller.data.modules.map<Widget>((ModuleData module) {
            return ModuleV2(data: module);
          }).toList(),
        ),
      ),
    ];
  }
}
