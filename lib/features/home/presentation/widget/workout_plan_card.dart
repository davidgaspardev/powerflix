import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:powerflix/shared/widgets/loading.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlan data;
  final VoidCallback? onTap;

  const WorkoutPlanCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: data.id,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              data.coverUrl,
              fit: BoxFit.fill,
              loadingBuilder: loadingImage,
              errorBuilder: loadingError,
            ),
          )
        ),
      ),
    );
  }

  Widget loadingImage(
      BuildContext context,
      Widget child,
      ImageChunkEvent? chunk
      ) {
    if (chunk == null) return child;
    return Loading();
  }

  Widget loadingError(
      BuildContext context,
      Object error,
      StackTrace? stackTrace
      ) {
    return LoadingError(message: error.toString());
  }
}

const _previewData = {
  'id': '4y73y475y3884y3',
  'name': 'Bumbum na lua',
  'description': 'Para voçê que busca massa muscular no bumbum.',
  'coverUrl': 'https://firebasestorage.googleapis.com/v0/b/myself-dg.appspot.com/o/powerflix%2Fbumbum_na_lua.jpg?alt=media&token=49eb1a02-4554-450a-9c9e-24357a6135ff',
  'levels': <dynamic>[],
};

@Preview(name: "Workout Plan Card Widget")
Widget workoutPlanCardPreview() {
  final workoutPlan = WorkoutPlan.fromMap(_previewData);
  return WorkoutPlanCard(data: workoutPlan);
}