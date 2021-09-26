import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/app/models/card_data.dart';

class Module extends StatelessWidget {

  final ModuleData data;

  const Module({
    Key? key,
    required this.data
  }): super(key: key);

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
                color: Colors.black,
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
                      color: Colors.black,
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
                          "${data.frequency.series}x${data.frequency.repetition}",
                          padding: EdgeInsets.only(left: 5),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        Label(
                          "${data.frequency.series} series de ${data.frequency.repetition} repetições",
                          fontSize: 12,
                        ),
                      ],
                    ),

                    // Line
                    Container(
                      width: double.infinity,
                      height: 2,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.grey,
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
                            color: Colors.black
                          ),
                          LabelSpan(exercise.name)
                        ]
                      ),
                      padding: EdgeInsets.only(top: 10, left: 5),
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