import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerflix/app/databases/hive.dart';
import 'package:powerflix/app/locator.dart';
import 'package:powerflix/core/data/datasources/user_local_datasource.dart';
import 'package:powerflix/core/data/repositories/user_repository_impl.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/muscle_map/data/repositories/body_map_repository_impl.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_viewmodel.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_widget.dart';
import 'package:powerflix/features/profile/presentation/register_widget.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_widget.dart';
import 'package:powerflix/features/home/presentation/home_widget.dart';
import 'package:powerflix/features/video/presentation/video_widget.dart';
import 'package:powerflix/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase().initilize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final user = await UserRepositoryImpl(UserLocalDatasource()).getUser();
  final initialRoute = user == null
      ? RegisterWidget.routeName
      : HomeWidget.routeName;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlix',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: initialRoute,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: child!,
        );
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RegisterWidget.routeName:
            return MaterialPageRoute(
              builder: (_) => const RegisterWidget(),
            );

          case HomeWidget.routeName:
            return MaterialPageRoute(
              builder: (_) => const HomeWidget(),
            );

          case WorkoutDetailWidget.routeName:
            final plan = settings.arguments as WorkoutPlan;
            return MaterialPageRoute(
              builder: (_) => WorkoutDetailWidget(plan: plan),
            );

          case VideoWidget.routeName:
            final link = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => VideoWidget(link: link),
            );

          case MuscleMapWidget.routeName:
            ServiceLocator.register(MuscleMapViewModel(BodyMapRepositoryImpl()));
            return MaterialPageRoute(
              builder: (_) => const MuscleMapWidget(),
            );

          default:
            return null;
        }
      },
    );
  }
}
