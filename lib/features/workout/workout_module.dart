import 'package:flutter/material.dart';
import 'package:moveflix/app/locator.dart';
import 'package:moveflix/core/data/datasources/user_local_datasource.dart';
import 'package:moveflix/core/data/repositories/user_repository_impl.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/data/datasources/workout_hive_datasource.dart';
import 'package:moveflix/features/workout/data/datasources/workout_local_datasource.dart';
import 'package:moveflix/features/workout/data/datasources/workout_preferences_datasource.dart';
import 'package:moveflix/features/workout/data/repositories/workout_preferences_repository_impl.dart';
import 'package:moveflix/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/browse_workouts_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_preferences_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/toggle_favorite_workout_use_case.dart';
import 'package:moveflix/features/workout/presentation/detail/workout_detail_viewmodel.dart';
import 'package:moveflix/features/workout/presentation/detail/workout_detail_widget.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_viewmodel.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_widget.dart';
import 'package:moveflix/features/workout/workout_routes.dart';

class WorkoutModule {
  static void register() {
    ServiceLocator.register<UserRepository>(
      UserRepositoryImpl(UserLocalDatasource()),
    );
    ServiceLocator.register<WorkoutPlanRepository>(
      WorkoutPlanRepositoryImpl(WorkoutLocalDatasource(), WorkoutHiveDatasource()),
    );
    ServiceLocator.register<WorkoutPreferencesRepository>(
      WorkoutPreferencesRepositoryImpl(WorkoutPreferencesDatasource()),
    );
  }

  static Map<String, WidgetBuilder> get routes => {
        WorkoutRoutes.list: (_) {
          final userRepository = ServiceLocator.get<UserRepository>();
          final workoutRepo = ServiceLocator.get<WorkoutPlanRepository>();
          final prefsRepo = ServiceLocator.get<WorkoutPreferencesRepository>();

          return WorkoutListWidget(
            viewModel: WorkoutListViewModel(
              userRepository: userRepository,
              workoutPlanRepository: workoutRepo,
              browseWorkoutsUseCase: BrowseWorkoutsUseCase(
                workoutPlanRepository: workoutRepo,
                preferencesRepository: prefsRepo,
              ),
              toggleFavoriteWorkoutUseCase: ToggleFavoriteWorkoutUseCase(prefsRepo),
            ),
          );
        },
        WorkoutRoutes.detail: (ctx) {
          final prefsRepo = ServiceLocator.get<WorkoutPreferencesRepository>();
          final plan = ModalRoute.of(ctx)!.settings.arguments as WorkoutPlan;

          return WorkoutDetailWidget(
            plan: plan,
            viewModel: WorkoutDetailViewModel(
              plan: plan,
              getPreferences: GetWorkoutPreferencesUseCase(prefsRepo),
              toggleFavorite: ToggleFavoriteWorkoutUseCase(prefsRepo),
            ),
          );
        },
      };
}
