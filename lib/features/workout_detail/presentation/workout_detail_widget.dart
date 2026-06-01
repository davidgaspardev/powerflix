import 'package:flutter/material.dart';
import 'package:powerflix/shared/theme/colors.dart';
import 'package:powerflix/shared/widgets/label.dart';
import 'package:powerflix/shared/widgets/loading.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/video/presentation/video_widget.dart';
import 'package:powerflix/features/workout_detail/presentation/widget/difficulty_tier_card.dart';
import 'package:powerflix/features/workout_detail/presentation/widget/slide_panel.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_viewmodel.dart';

class WorkoutDetailWidget extends StatefulWidget {
  static const routeName = '/workout_detail';

  final WorkoutPlan plan;

  const WorkoutDetailWidget({super.key, required this.plan});

  @override
  State<WorkoutDetailWidget> createState() => _WorkoutDetailWidgetState();
}

class _WorkoutDetailWidgetState extends State<WorkoutDetailWidget> {
  late final WorkoutDetailViewModel _viewModel;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _viewModel = WorkoutDetailViewModel(plan: widget.plan);
    _pageController = PageController();
    _viewModel.currentLevelNotifier.addListener(_syncPage);
  }

  void _syncPage() {
    final page = _viewModel.currentLevelNotifier.value;
    if (_pageController.hasClients && _pageController.page?.round() != page) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _viewModel.currentLevelNotifier.removeListener(_syncPage);
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildCover(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final coverHeight = (size.width - 32) * 1.48;

    return Stack(
      children: [
        Hero(
          tag: widget.plan.id,
          child: Container(
            margin: const EdgeInsets.all(16),
            height: coverHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                widget.plan.coverUrl,
                fit: BoxFit.fill,
                loadingBuilder: _loadingImage,
                errorBuilder: _loadingError,
              ),
            ),
          ),
        ),
        Positioned(
          top: 32,
          right: 32,
          child: ValueListenableBuilder<bool>(
            valueListenable: _viewModel.isFavoriteNotifier,
            builder: (_, isFavorite, __) => GestureDetector(
              onTap: _viewModel.toggleFavorite,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SlidePanel(
      topDistance: width * 1.45,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                height: 4,
                width: 48,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Label(
              widget.plan.name,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              padding: const EdgeInsets.only(top: 25, bottom: 5, left: 16),
              color: Colors.black,
            ),
            Label(
              widget.plan.description,
              padding: const EdgeInsets.only(bottom: 25, left: 16),
            ),
            _buildLevels(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevels(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _viewModel.currentLevelNotifier,
      builder: (_, currentLevel, __) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label('Módulos de exercícios'),
                Row(
                  children: List.generate(
                    widget.plan.levels.length,
                        (i) => Container(
                      width: 16,
                      height: 8,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == currentLevel
                            ? difficultyColors[i % difficultyColors.length]
                            : Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 500,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: _viewModel.onLevelChanged,
              children: widget.plan.levels
                  .map<Widget>((level) => DifficultyTierCard(
                        data: level,
                        onVideoTap: (url) => Navigator.of(context).pushNamed(
                          VideoWidget.routeName,
                          arguments: url,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingImage(
    BuildContext context,
    Widget child,
    ImageChunkEvent? chunk,
  ) {
    if (chunk == null) return child;
    return Loading();
  }

  Widget _loadingError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) =>
      LoadingError(message: error.toString());
}
