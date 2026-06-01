import 'package:flutter/material.dart';
import 'package:powerflix/shared/widgets/loading.dart';
import 'package:powerflix/shared/widgets/top_drawer.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_widget.dart';
import 'package:powerflix/features/home/presentation/home_viewmodel.dart';
import 'package:powerflix/features/home/presentation/widget/header.dart';
import 'package:powerflix/features/home/presentation/widget/workout_plan_card.dart';

class HomeWidget extends StatefulWidget {
  static const routeName = '/home';

  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late final HomeViewModel _viewModel;

  static const double _menuHeight = 260;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget _buildGrid(double topInset) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: topInset + Header.height),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1417 / 2008,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, int index) => WorkoutPlanCard(
                data: _viewModel.workouts[index],
                onTap: () => Navigator.of(context).pushNamed(
                  WorkoutDetailWidget.routeName,
                  arguments: _viewModel.workouts[index],
                ),
              ),
              childCount: _viewModel.workouts.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: TopDrawer(
        menuHeight: _menuHeight,
        footerHeight: Header.height,
        menuBuilder: (_) => Container(color: Colors.amber),
        footerBuilder: (_, toggle) => Header(onTap: toggle),
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.isLoading) return Loading();
            if (_viewModel.hasError) {
              return LoadingError(message: 'Erro ao carregar os treinos.');
            }
            return _buildGrid(topInset);
          },
        ),
      ),
    );
  }
}
