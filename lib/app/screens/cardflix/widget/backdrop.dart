import 'package:flutter/material.dart';

class Backdrop extends StatefulWidget {
  final Widget child;
  final double topDistance;

  const Backdrop({
    Key? key,
    required this.child,
    required this.topDistance,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> {
  final globalKey = GlobalKey();

  double get top => widget.topDistance;
  Widget get child => widget.child;

  late double lastTop;
  late double currentTop;
  late double startPosition;
  late double endPosition;
  late double distancePositions;

  onVerticalDragStart(DragStartDetails details) {
    startPosition = details.localPosition.dy;
    distancePositions = 0;
  }

  onVerticalDragUpdate(DragUpdateDetails details) {
    distancePositions = startPosition - details.localPosition.dy;

    setState(() {
      currentTop = lastTop - distancePositions;
    });
  }

  onVerticalDragEnd(DragEndDetails details) {
    final diff = lastTop - currentTop;
    if(diff > 30) {
      open();
    } else if(diff < 0) {
      close();
    }
    lastTop = currentTop;
  }

  void open() async {
    if((currentTop < (endPosition - 3)) || (currentTop > endPosition + 3)) {
      setState(() {
        if(currentTop > endPosition) {
          currentTop -= 5;
        } else {
          currentTop += 5;
        }
      });
      await Future.delayed(Duration(milliseconds: 1));
      open();
    } else if(currentTop != lastTop) {
      lastTop = currentTop;
    }
  }

  void close() async {
    if((currentTop > (top + 3)) || (currentTop < (top - 3))) {
      setState(() {
        if(currentTop > top) {
          currentTop -= 5;
        } else {
          currentTop += 5;
        }
      });
      await Future.delayed(Duration(milliseconds: 1));
      close();
    } else if(currentTop != lastTop) {
      lastTop = currentTop;
    }
  }

  @override
  void initState() {
    super.initState();

    currentTop = top;
    lastTop = top;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final childHeight = globalKey.currentContext!.size!.height;
      endPosition = MediaQuery.of(context).size.height - childHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: currentTop,
      // bottom: currentTop * -1,
      right: 0,
      left: 0,
      child: GestureDetector(
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        child: Container(
          key: globalKey,
          child: Column(
            children: [
              child,
            ],
          ),
        ),
      ),
    );
  }
}
