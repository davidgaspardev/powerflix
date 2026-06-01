import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_widget.dart';
import 'package:powerflix/features/home/presentation/home_widget.dart';
import 'package:powerflix/features/video/presentation/video_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlix',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: HomeWidget.routeName,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
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

          default:
            return null;
        }
      },
    );
  }
}
