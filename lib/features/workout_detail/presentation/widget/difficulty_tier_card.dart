import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/color.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

class DifficultyTierCard extends StatelessWidget {
  final DifficultyTier data;
  final void Function(String videoUrl)? onVideoTap;

  const DifficultyTierCard({
    Key? key,
    required this.data,
    this.onVideoTap,
  }) : super(key: key);

  Color get color {
    switch (data.difficulty) {
      case Difficulty.light:
        return appColors[0];
      case Difficulty.soft:
        return appColors[1];
      case Difficulty.hard:
        return appColors[2];
    }
  }

  String get _volumeLabel {
    final sets = data.volume.sets;
    final reps = data.volume.reps;
    return reps != null ? '${sets}x$reps' : '${sets}x falha';
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
        children: [_buildHeader(), _buildExercises()],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          data.difficulty.toValue(),
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
                _volumeLabel,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              Label.rich(
                LabelSpan(
                  '',
                  children: [
                    LabelSpan(
                      data.volume.sets.toString(),
                      fontWeight: FontWeight.bold,
                    ),
                    LabelSpan(
                      ' series de ',
                      color: Colors.white.withOpacity(0.8),
                    ),
                    LabelSpan(
                      data.volume.reps?.toString() ?? 'falha',
                      fontWeight: FontWeight.bold,
                    ),
                    LabelSpan(
                      data.volume.reps != null ? ' repetições' : '',
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
          margin: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildExercises() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: data.exercises
            .map<Widget>((e) => _buildExercise(e))
            .toList(),
      ),
    );
  }

  Widget _buildExercise(Exercise exercise) {
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
            padding: const EdgeInsets.only(right: 14),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(exercise.name, color: Colors.white),
                if (exercise.techniques.isNotEmpty)
                  _buildTechniques(exercise.techniques),
                if (exercise.videoUrl != null && onVideoTap != null)
                  _buildVideoButton(exercise.videoUrl!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoButton(String videoUrl) {
    return GestureDetector(
      onTap: () => onVideoTap!(videoUrl),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white.withOpacity(0.25),
        ),
        child: Label.rich(
          LabelSpan(
            'ASSISTIR',
            children: [
              LabelSpan(' EXEMPLO', fontWeight: FontWeight.bold),
            ],
            color: Colors.white,
            fontSize: 12,
          ),
          letterSpacing: -0.5,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      ),
    );
  }

  Widget _buildTechniques(List<Technique> techniques) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: techniques.map((t) {
          return Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Label(
              t.title,
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
