import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerflix/app/models/cardflix_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_screen.dart';
import 'package:powerflix/features/home/presentation/home_widget.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlix',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: "/home",
      onGenerateRoute: (RouteSettings settings) {
        print("routing: ${settings.name}");
        switch(settings.name) {

          case HomeWidget.routeName:
            return MaterialPageRoute(builder: (BuildContext context) => const HomeWidget());

          case CardflixScreen.routeName: 
            var data = settings.arguments as CardflixData;
            return MaterialPageRoute(builder: (BuildContext context) => CardflixScreen(data: data));

          case VideoScreen.routeName:
            var data = settings.arguments as String;
            return MaterialPageRoute(builder: (BuildContext context) => VideoScreen(link: data));
          
          default:
            return null;
        }
      },
    );
  }
}
