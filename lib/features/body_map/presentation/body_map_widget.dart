import 'package:flutter/material.dart';
import 'package:moveflix/features/body_map/body_map_routes.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/presentation/body_map_viewmodel.dart';
import 'package:moveflix/features/body_map/presentation/widget/body_side_toggle.dart';
import 'package:moveflix/features/body_map/presentation/widget/body_map_painter.dart';
import 'package:moveflix/features/body_map/presentation/widget/stress_legend.dart';
import 'package:moveflix/shared/widgets/loading.dart';

class BodyMapWidget extends StatefulWidget {
  static const routeName = BodyMapRoutes.map;

  final BodyMapViewModel viewModel;

  const BodyMapWidget({super.key, required this.viewModel});

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  late final BodyMapViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Map')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) return const Loading();
          if (_viewModel.hasError) {
            return const Center(child: Text('Failed to load body map.'));
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
        BodySideToggle(
          isFront: _viewModel.side == BodySide.front,
          onToggle: _viewModel.toggleSide,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AspectRatio(
              aspectRatio: kBodyMapAspectRatio,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvasSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return CustomPaint(
                    painter: BodyMapPainter(
                      regions: _viewModel.regions,
                      outline: _viewModel.outline,
                      stressByRegion: _viewModel.stressByRegion,
                    ),
                    size: canvasSize,
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
