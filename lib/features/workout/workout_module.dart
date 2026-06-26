import 'package:flutter/material.dart';
import 'package:moveflix/app/locator.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/data/datasources/workout_hive_datasource.dart';
import 'package:moveflix/features/workout/data/datasources/workout_local_datasource.dart';
import 'package:moveflix/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_cover_list_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_plan_by_id.dart';
import 'package:moveflix/features/workout/presentation/detail/workout_detail_viewmodel.dart';
import 'package:moveflix/features/workout/presentation/detail/workout_detail_widget.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_viewmodel.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_widget.dart';
import 'package:moveflix/features/workout/workout_routes.dart';

class WorkoutModule {
  static void register() {
    ServiceLocator.register<WorkoutPlanRepository>(
      WorkoutPlanRepositoryImpl(WorkoutLocalDatasource(), WorkoutHiveDatasource()),
    );
  }

  static Map<String, WidgetBuilder> get routes => {
        WorkoutRoutes.list: (_) {
          return WorkoutListWidget(
            viewModel: WorkoutListViewModel(
              getWorkoutCoverListUseCase: GetWorkoutCoverListUseCase(
                workoutPlanRepository: ServiceLocator.get<WorkoutPlanRepository>(),
                userRepository: ServiceLocator.get<UserRepository>(),
              ),
              getWorkoutPlanByIdUseCase: GetWorkoutPlanByIdUseCase(
                workoutPlanRepository: ServiceLocator.get<WorkoutPlanRepository>(),
              ),
            ),
          );
        },
        WorkoutRoutes.detail: (ctx) {
          final plan = WorkoutPlan.fromJson(ModalRoute.of(ctx)!.settings.arguments as String);
          return WorkoutDetailWidget(
            plan: plan,
            viewModel: WorkoutDetailViewModel(
              plan: plan,
              repository: ServiceLocator.get<UserRepository>(),
            ),
          );
        },
      };
}
