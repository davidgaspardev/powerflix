import 'package:flutter/material.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/shared/widgets/loading.dart';

class WorkoutCoverCard extends StatefulWidget {
  final WorkoutCover data;
  final VoidCallback? onTap;

  const WorkoutCoverCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  State<WorkoutCoverCard> createState() => _WorkoutCoverCardState();
}

class _WorkoutCoverCardState extends State<WorkoutCoverCard> {
  bool _loaded = false;

  @override
  void didUpdateWidget(WorkoutCoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.coverUrl != widget.data.coverUrl) {
      _loaded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: widget.data.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.data.coverUrl,
                fit: BoxFit.fill,
                loadingBuilder: _loadingBuilder,
                errorBuilder: _errorBuilder,
              ),
              if (_loaded) ...[
                Container(
                  width: double.infinity,
                  height: double.infinity,
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
                  child: Icon(
                    widget.data.isFavorite ? Icons.star : Icons.star_border,
                    color: widget.data.isFavorite ? Colors.yellow : Colors.white,
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? chunk) {
    if (chunk == null) {
      if (!_loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _loaded = true);
        });
      }
      return child;
    }
    if (_loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _loaded = false);
      });
    }
    return const _SkeletonCard();
  }

  Widget _errorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
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
