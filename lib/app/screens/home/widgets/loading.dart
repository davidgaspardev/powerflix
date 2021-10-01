import 'dart:math';
import 'package:flutter/material.dart';

// class Loading extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: CircularProgressIndicator(),
//     );
//   }
// }

class Loading extends StatefulWidget {

  @override
  _LoadingState createState() {
    return _LoadingState();
  }
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  void _log(String method, { String? message }) {
    print("($hashCode) [ Loading | $method ] ${message != null ? message : ""}");
  }

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    animation.addListener(() {
      setState(() {});
    });

    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Opacity(
        opacity: animation.value,
        child: Image.asset("lib/app/assets/image/logo.png"),
      )
    );
  }

  @override
  void dispose() {
    _log("dispose");
    controller.dispose();

    super.dispose();
  }
}