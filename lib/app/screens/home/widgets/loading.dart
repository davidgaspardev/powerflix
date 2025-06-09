import 'package:flutter/material.dart';
import 'package:powerflix/app/helpers/widgets/label.dart';

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
  void _log(String method, {String? message}) {
    print(
        "($hashCode) [ Loading | $method ] ${message != null ? message : ""}");
  }

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
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
        ));
  }

  @override
  void dispose() {
    _log("dispose");
    controller.dispose();

    super.dispose();
  }
}

class LoadingError extends StatefulWidget {
  final String message;

  const LoadingError({Key? key, required this.message}) : super(key: key);

  @override
  _LoadingError createState() => _LoadingError();
}

class _LoadingError extends State<LoadingError> {
  String get message => widget.message;

  late bool _showDetail;

  @override
  void initState() {
    super.initState();

    _showDetail = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: () {
          List<Widget> widgets = [];

          widgets.add(Icon(
            Icons.error,
            size: 48,
          ));

          widgets.add(Label(
            "Não foi possivel carregar a imagem",
            textAlign: TextAlign.center,
            padding: EdgeInsets.all(8),
          ));

          if (_showDetail) {
            widgets.add(Label(
              message,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            ));
          }

          widgets.add(
              GestureDetector(onTap: switchDetailMessage, child: button()));

          return widgets;
        }(),
      ),
    );
  }

  void switchDetailMessage() {
    setState(() {
      _showDetail = !_showDetail;
    });
  }

  Widget button() {
    return Container(
      width: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Label(
        _showDetail ? "ocultar detalhes" : "ver detalhes",
        textAlign: TextAlign.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
