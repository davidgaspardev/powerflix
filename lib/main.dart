import 'package:flutter/material.dart';
import 'package:powerflix/app/models/card_data.dart';
import 'package:powerflix/app/screens/cardflix/cardflix_screen.dart';
import 'package:powerflix/app/screens/home/home_screen.dart';
import 'package:powerflix/app/screens/video/video_screen.dart';
// import 'package:powerflix/app/screens/home/widgets/cardflix.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerFlix',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
