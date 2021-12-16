/// External package
import 'package:flutter/material.dart';

/// Internal package
import 'package:powerflix/app/helpers/color.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';
import 'package:powerflix/app/screens/cardflix/widget/module_v2.dart';
import 'package:powerflix/app/screens/cardflix/widget/backdrop.dart';
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
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          buildCover(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildCover() {
    final height = (MediaQuery.of(controller.context).size.width - 32) * 1.48;
    final paddingTop = MediaQuery.of(controller.context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: paddingTop),
      child: Stack(
        children: [
          Hero(
            tag: controller.data.id,
            child: Container(
              margin: const EdgeInsets.all(16),
              height: height,
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
          Positioned(
            top: 32,
            right: 32,
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.favoriteNotifier,
              builder: (_, bool isFavorite, __) {
                return GestureDetector(
                  onTap: controller.switchFavorite,
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : Colors.white,
                    size: 32,
                  ),
                );
              },
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

  Widget buildContent() {
    return Backdrop(
      topDistance: MediaQuery.of(controller.context).size.width * 1.48,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: 4,
                    width: 48,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
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
                    .map(
                      (position) => Container(
                        width: 16,
                        height: 8,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: position == currentPosition
                              ? appColors[position]
                              : Colors.grey,
                        ),
                      ),
                    )
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
