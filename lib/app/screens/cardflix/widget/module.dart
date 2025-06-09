import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';

class Module extends StatelessWidget {

  final ModuleData data;

  const Module({
    Key? key,
    required this.data
  }): super(key: key);

  Color get color {
    switch(this.data.level) {
      case "LIGHT": return Color(0xFF37DF1C);
      case "SOFT": return Color(0xFFE8DE00);
      case "HARD": return Color(0xFFEF4040);
      default: throw Exception("Name invalid");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // Level
          Label(
            data.level, 
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),

          // Frequency
          Label(
            data.description,
            padding: const EdgeInsets.only(bottom: 15, top: 5),
          ),

          // Frequency
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Label(
                "${data.frequency.series}x${data.frequency.repetition > 0 ?
                data.frequency.repetition : "FALHAR"}",
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              Label(
                "${data.frequency.series} series de ${data.frequency.repetition > 0 ?
                "${data.frequency.repetition} repetições" : " até a falha"}",
                fontSize: 12,
              ),
            ],
          ),

          // Line
          Container(
            width: double.infinity,
            height: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: color,
            ),
          ),

        ] + data.exercises.map<Widget>((ExerciseData data) {
          // return GestureDetector(
          //   onTap: controller.toVideoPage,
          //   child: Label.rich(
          //     LabelSpan(
          //       "",
          //       children: [
          //         LabelSpan(
          //           "${exercise.order} ",
          //           fontWeight: FontWeight.bold,
          //           color: getTheme(data.level)
          //         ),
          //         LabelSpan(exercise.name)
          //       ]
          //     ),
          //     padding: EdgeInsets.only(top: 15, left: 5),
          //   ),
          // );
          return buidExercise(data);
        }).toList(),
      ),
    );
  }

  /// Exercise widget
  Widget buidExercise(ExerciseData data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            data.order.toString(),
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.only(right: 6),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                data.link == null
                /* Exercide name without video */
                ? Label(
                  data.name,
                  fontSize: 20,
                  padding: const EdgeInsets.only(top: 4),
                )
                /* Exercide name with video */
                : Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Label(
                          data.name,
                          fontSize: 20,
                          padding: const EdgeInsets.only(top: 4),
                        )
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 20,
                          color: color,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: data.features.map<Widget>((FeatureData feture) {
                    return Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Label(
                        feture.name,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}