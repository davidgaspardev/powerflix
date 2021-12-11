import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/color.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/helpers/widgets/provider.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_controller.dart';

class ModuleV2 extends StatelessWidget {
  final ModuleData data;
  final CardflixController controller =
      Provider.getControllerByType<CardflixController>();

  ModuleV2({Key? key, required this.data}) : super(key: key);

  Color get color {
    switch (this.data.level) {
      case "LIGHT":
        return appColors[0];
      case "SOFT":
        return appColors[1];
      case "HARD":
        return appColors[2];
      default:
        throw Exception("Level invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [header(), body()],
      ),
    );
  }

  Widget header() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            data.level,
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            padding: const EdgeInsets.all(8),
          ),
          Label(
            data.description,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  "${data.frequency.series}x${data.frequency.repetition}",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                Label.rich(
                  LabelSpan(
                    "",
                    children: [
                      LabelSpan(
                        data.frequency.series.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                      LabelSpan(
                        " series de ",
                        color: Colors.white.withOpacity(0.8),
                      ),
                      LabelSpan(
                        data.frequency.repetition.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                      LabelSpan(
                        " repetições",
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                  color: Colors.white,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Container(
            height: 4,
            margin: const EdgeInsets.only(
              right: 8,
              bottom: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        children: data.exercises.map<Widget>((exercise) {
          return buildExercise(exercise);
        }).toList(),
      ),
    );
  }

  Widget buildExercise(ExerciseData exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            exercise.order.toString(),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            padding: EdgeInsets.only(right: 14),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Label(
                      exercise.name,
                      color: Colors.white,
                    )
                  ] +
                  () {
                    List<Widget> widgets = [];
                    if (exercise.features != null &&
                        exercise.features.length > 0) {
                      widgets.add(buildFeatures(exercise.features));
                    }
                    if (exercise.link != null) {
                      widgets.add(buildButton(() {
                        controller.toVideoPage(exercise.link!);
                      }));
                    }
                    return widgets;
                  }(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeatures(List<FeatureData> features) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: features.map((feature) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Label(
              feature.name,
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildButton(Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.25)),
        child: Label.rich(
          LabelSpan(
            "ASSISTIR",
            children: [
              LabelSpan(
                " EXEMPLO",
                fontWeight: FontWeight.bold,
              ),
            ],
            color: Colors.white,
            fontSize: 12,
          ),
          letterSpacing: -0.5,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      ),
    );
  }
}
