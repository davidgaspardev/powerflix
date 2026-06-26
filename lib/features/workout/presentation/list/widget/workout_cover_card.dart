import 'package:flutter/material.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/shared/widgets/loading.dart';

class WorkoutCoverCard extends StatelessWidget {
  final WorkoutCover data;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const WorkoutCoverCard({
    super.key,
    required this.data,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: data.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            data.coverUrl,
            fit: BoxFit.fill,
            frameBuilder: _frameBuilder,
            loadingBuilder: _loadingBuilder,
            errorBuilder: _errorBuilder,
          ),
        ),
      ),
    );
  }

  // Called when an image frame is ready. frame==null means no frame rendered yet.
  Widget _frameBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (frame == null) return child;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey.withAlpha(64),
              width: 2,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onFavorite,
            child: Icon(
              data.isFavorite ? Icons.star : Icons.star_border,
              color: data.isFavorite ? Colors.yellow : Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadingBuilder(BuildContext context, Widget child, ImageChunkEvent? chunk) {
    if (chunk != null) return const _SkeletonCard();
    return child;
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return LoadingError(message: error.toString());
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final sweep = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.5 + sweep * 3, 0),
              end: Alignment(0.5 + sweep * 3, 0),
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
