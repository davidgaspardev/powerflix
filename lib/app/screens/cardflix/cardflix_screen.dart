import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:powerflix/app/helpers/color.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';
import 'package:powerflix/app/screens/cardflix/widget/module.dart';
import 'package:powerflix/app/screens/cardflix/widget/module_v2.dart';



/// Cardflix Screen
class CardflixScreen extends StatelessWidget {

  static const routeName = "/cardflix";

  final CardflixController controller;
  CardflixScreen({ Key? key, required CardData data }):
  controller = Provider.createController(() => CardflixController(data: data)),
  super(key: key);

  Widget screen() {
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
                height: (MediaQuery.of(controller.context).size.width - 32) * 1.48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(controller.data.cover),
                    fit: BoxFit.cover,
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
                    padding: EdgeInsets.only(top: 25, bottom: 5),
                    color: Colors.black,
                  ),

                  // Description
                  Label(
                    controller.data.description,
                    padding: EdgeInsets.only(bottom: 25),
                  ),

                  // Modules
                // ] + controller.data.modules.map<Widget>((ModuleData module) {
                //   return ModuleV2(data: module);
                // }).toList(),
                  Container(
                    child: ValueListenableBuilder<int>(
                      valueListenable: controller.modulePositionNotifier,
                      builder: (context, currentPosition, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 0, 1, 2].map((position) => Container(
                          width: 16,
                          height: 8,
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: position == currentPosition ? appColors[position] : Colors.grey
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    child: PageView(
                      onPageChanged: controller.onPageChanged,
                      children: controller.data.modules.map<Widget>((ModuleData module) {
                        return ModuleV2(data: module);
                      }).toList(),
                    ),
                  ),
                ]
              ),
            ),
          ),
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