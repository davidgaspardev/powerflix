import 'package:flutter/material.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/shared/widgets/loading.dart';

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutCover data;
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
            child: Stack(
              children: [
                Image.network(
                  data.coverUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: loadingImage,
                  errorBuilder: loadingError,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    data.isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingImage(BuildContext context, Widget child, ImageChunkEvent? chunk) {
    if (chunk == null) return child;
    return Loading();
  }

  Widget loadingError(BuildContext context, Object error, StackTrace? stackTrace) {
    return LoadingError(message: error.toString());
  }
}
