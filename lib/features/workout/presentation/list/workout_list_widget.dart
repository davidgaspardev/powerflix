import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moveflix/app/router/route_observer.dart';
import 'package:moveflix/features/workout/presentation/list/widget/header.dart';
import 'package:moveflix/features/workout/presentation/list/widget/workout_plan_card.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_viewmodel.dart';
import 'package:moveflix/features/workout/workout_routes.dart';
import 'package:moveflix/shared/widgets/loading.dart';
import 'package:moveflix/shared/widgets/top_drawer.dart';

class WorkoutListWidget extends StatefulWidget {
  final WorkoutListViewModel viewModel;

  const WorkoutListWidget({super.key, required this.viewModel});

  @override
  State<WorkoutListWidget> createState() => _WorkoutListWidgetState();
}

class _WorkoutListWidgetState extends State<WorkoutListWidget> with RouteAware {
  late final WorkoutListViewModel _viewModel;
  late final StreamSubscription<String> _navigation;

  static const double _menuHeight = 260;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.init();

    _navigation = _viewModel.navigationEvents.listen((String workoutId) {
      Navigator.of(context).pushNamed(
        WorkoutRoutes.detail,
        arguments: workoutId,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _navigation.cancel();
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
          sliver: ListenableBuilder(
            listenable: _viewModel,
            builder: (BuildContext context, Widget? child) => SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1417 / 2008,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, int index) {
                  final workoutCover = _viewModel.workoutCoverList[index];
                  return WorkoutPlanCard(
                    data: workoutCover,
                    onTap: () => _viewModel.openWorkoutCover(workoutCover.id),
                  );
                },
                childCount: _viewModel.workoutCoverList.length,
              ),
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
        menuBuilder: (_) => Container(),
        footerBuilder: (_, toggle) => Header(onTap: toggle),
        panelColor: Theme.of(context).colorScheme.surface,
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

  @override
  void didPopNext() {
    _viewModel.loadWorkouts();
  }
}
