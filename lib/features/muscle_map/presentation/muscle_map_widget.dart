import 'package:flutter/material.dart';
import 'package:powerflix/features/muscle_map/data/datasources/muscle_map_asset_datasource.dart';
import 'package:powerflix/features/muscle_map/data/repositories/muscle_map_repository_impl.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_viewmodel.dart';
import 'package:powerflix/features/muscle_map/presentation/widget/muscle_painter.dart';
import 'package:powerflix/features/muscle_map/presentation/widget/muscle_side_toggle.dart';
import 'package:powerflix/features/muscle_map/presentation/widget/stress_legend.dart';
import 'package:powerflix/shared/widgets/loading.dart';

class MuscleMapWidget extends StatefulWidget {
  static const routeName = '/muscle_map';

  const MuscleMapWidget({super.key});

  @override
  State<MuscleMapWidget> createState() => _MuscleMapWidgetState();
}

class _MuscleMapWidgetState extends State<MuscleMapWidget> {
  late final MuscleMapViewModel _viewModel;

  // Holds a reference to the painter so we can call hitTest from the
  // GestureDetector without re-creating it on every frame.
  MusclePainter? _painter;

  @override
  void initState() {
    super.initState();
    _viewModel = MuscleMapViewModel(
      MuscleMapRepositoryImpl(MuscleMapAssetDatasource()),
    );
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onTapUp(TapUpDetails details, Size canvasSize) {
    final muscleId = _painter?.findMuscleAt(details.localPosition, canvasSize);
    if (muscleId != null) _viewModel.onMuscleTap(muscleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muscle Map')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return Loading();
          if (_viewModel.hasError) {
            return const Center(child: Text('Failed to load muscle map.'));
          }
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 16),
        MuscleSideToggle(
          isFront: _viewModel.isFront,
          onToggle: _viewModel.toggleSide,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AspectRatio(
              aspectRatio: kMuscleMapAspectRatio,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvasSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  _painter = MusclePainter(
                    paths: _viewModel.paths,
                    stress: _viewModel.stress,
                  );
                  return GestureDetector(
                    onTapUp: (d) => _onTapUp(d, canvasSize),
                    child: CustomPaint(
                      painter: _painter,
                      size: canvasSize,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const StressLegend(),
        const SizedBox(height: 24),
      ],
    );
  }
}
