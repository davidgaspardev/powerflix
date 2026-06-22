import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveflix/app/databases/hive.dart';
import 'package:moveflix/app/locator.dart';
import 'package:moveflix/core/data/datasources/user_local_datasource.dart';
import 'package:moveflix/core/data/repositories/user_repository_impl.dart';
import 'package:moveflix/core/domain/models/workout_plan.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/home/data/datasources/workout_hive_datasource.dart';
import 'package:moveflix/features/home/data/datasources/workout_local_datasource.dart';
import 'package:moveflix/features/home/data/repositories/workout_repository_impl.dart';
import 'package:moveflix/features/home/domain/repositories/workout_repository.dart';
import 'package:moveflix/features/home/presentation/home_viewmodel.dart';
import 'package:moveflix/features/home/presentation/home_widget.dart';
import 'package:moveflix/features/muscle_map/data/repositories/body_map_repository_impl.dart';
import 'package:moveflix/features/muscle_map/domain/repositories/body_map_repository.dart';
import 'package:moveflix/features/muscle_map/presentation/muscle_map_viewmodel.dart';
import 'package:moveflix/features/muscle_map/presentation/muscle_map_widget.dart';
import 'package:moveflix/features/profile/presentation/register_viewmodel.dart';
import 'package:moveflix/features/profile/presentation/register_widget.dart';
import 'package:moveflix/features/video/data/datasources/video_network_datasource.dart';
import 'package:moveflix/features/video/data/repositories/video_repository_impl.dart';
import 'package:moveflix/features/video/domain/repositories/video_repository.dart';
import 'package:moveflix/features/video/presentation/video_viewmodel.dart';
import 'package:moveflix/features/video/presentation/video_widget.dart';
import 'package:moveflix/features/workout_detail/presentation/workout_detail_viewmodel.dart';
import 'package:moveflix/features/workout_detail/presentation/workout_detail_widget.dart';
import 'package:moveflix/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase().initilize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  _registerDependencies();

  final user = await ServiceLocator.get<UserRepository>().getUser();
  final initialRoute = user == null
      ? RegisterWidget.routeName
      : HomeWidget.routeName;

  runApp(MyApp(initialRoute: initialRoute));
}

void _registerDependencies() {
  ServiceLocator.register<UserRepository>(
    UserRepositoryImpl(UserLocalDatasource()),
  );
  ServiceLocator.register<WorkoutRepository>(
    WorkoutRepositoryImpl(WorkoutLocalDatasource(), WorkoutHiveDatasource()),
  );
  ServiceLocator.register<VideoRepository>(
    VideoRepositoryImpl(VideoNetworkDatasource()),
  );
  ServiceLocator.register<BodyMapRepository>(
    BodyMapRepositoryImpl(),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlix',
      theme: AppTheme.light,
      initialRoute: initialRoute,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: child!,
        );
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RegisterWidget.routeName:
            return MaterialPageRoute(
              builder: (_) => RegisterWidget(
                viewModel: RegisterViewModel(
                  ServiceLocator.get<UserRepository>(),
                ),
              ),
            );

          case HomeWidget.routeName:
            return MaterialPageRoute(
              builder: (_) => HomeWidget(
                viewModel: HomeViewModel(
                  ServiceLocator.get<WorkoutRepository>(),
                ),
              ),
            );

          case WorkoutDetailWidget.routeName:
            final plan = settings.arguments as WorkoutPlan;
            return MaterialPageRoute(
              builder: (_) => WorkoutDetailWidget(
                plan: plan,
                viewModel: WorkoutDetailViewModel(
                  plan: plan,
                  repository: ServiceLocator.get<UserRepository>(),
                ),
              ),
            );

          case VideoWidget.routeName:
            final link = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => VideoWidget(
                viewModel: VideoViewModel(
                  link: link,
                  repository: ServiceLocator.get<VideoRepository>(),
                ),
              ),
            );

          case MuscleMapWidget.routeName:
            return MaterialPageRoute(
              builder: (_) => MuscleMapWidget(
                viewModel: MuscleMapViewModel(
                  ServiceLocator.get<BodyMapRepository>(),
                ),
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
