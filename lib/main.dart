import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_screen.dart';
import 'package:powerflix/app/screens/home/home_screen.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';
// import 'package:powerflix/app/screens/home/widgets/cardflix.dart';

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
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home",
      onGenerateRoute: (RouteSettings settings) {
        print("routing: ${settings.name}");
        switch(settings.name) {

          case HomeScreen.routeName: 
            return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());

          case CardflixScreen.routeName: 
            var data = settings.arguments as CardData;
            return MaterialPageRoute(builder: (BuildContext context) => CardflixScreen(data: data));

          case VideoScreen.routeName:
            var data = settings.arguments as String;
            return MaterialPageRoute(builder: (BuildContext context) => VideoScreen(link: data));
          
          // default: throw Exception("Unmapped route: ${settings.name}");
        }
      },
    );
  }
}
