import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/models/card_data.dart';

class Module extends StatelessWidget {

  final ModuleData data;

  const Module({
    Key? key,
    required this.data
  }): super(key: key);

  Color getTheme(String name) {
    switch(name) {
      case "LIGHT": return Color(0xFF37DF1C);
      case "SOFT": return Color(0xFFE8DE00);
      case "HARD": return Color(0xFFEF4040);
      default: throw Exception("Name invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          children: [

            Container(
              width: 5,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: getTheme(data.level),
                borderRadius: BorderRadius.circular(2.5)
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    // Level
                    Label(
                      data.level, 
                      color: getTheme(data.level),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      padding: EdgeInsets.only(left: 5),
                    ),

                    // Frequency
                    Label(
                      data.description,
                      padding: EdgeInsets.only(bottom: 15, top: 5, left: 5),
                    ),

                    // Frequency
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          "${data.frequency.series}x${data.frequency.repetition > 0 ?
                          data.frequency.repetition : "FALHAR"}",
                          padding: EdgeInsets.only(left: 5),
                          color: getTheme(data.level),
                          fontWeight: FontWeight.bold,
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
                      height: 1.5,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.grey.withOpacity(.5),
                      ),
                    ),

                  ] + data.exercises.map<Widget>((ExerciseData exercise) {
                    return Label.rich(
                      LabelSpan(
                        "",
                        children: [
                          LabelSpan(
                            "${exercise.order} ",
                            fontWeight: FontWeight.bold,
                            color: getTheme(data.level)
                          ),
                          LabelSpan(exercise.name)
                        ]
                      ),
                      padding: EdgeInsets.only(top: 15, left: 5),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}