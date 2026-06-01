import 'package:flutter/material.dart';

class SlidePanel extends StatefulWidget {
  final Widget child;
  final double topDistance;

  const SlidePanel({
    super.key,
    required this.child,
    required this.topDistance,
  });

  @override
  State<SlidePanel> createState() => _SlidePanelState();
}

class _SlidePanelState extends State<SlidePanel>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _animation;
  late double endPosition;
  late double currentTop;
  double get closedTop => widget.topDistance;

  bool get _isOpen => currentTop <= (closedTop + endPosition) / 2;

  @override
  void initState() {
    super.initState();
    currentTop = closedTop;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childHeight = globalKey.currentContext!.size!.height;
      endPosition = MediaQuery.of(context).size.height - childHeight;
      _setupAnimation(from: closedTop, to: closedTop);
    });
  }

  void _setupAnimation({required double from, required double to}) {
    _animation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() => currentTop = _animation.value);
      });
  }

  void open() {
    _setupAnimation(from: currentTop, to: endPosition);
    _controller.forward(from: 0);
  }

  void close() {
    _setupAnimation(from: currentTop, to: closedTop);
    _controller.forward(from: 0);
  }

  void onVerticalDragStart(DragStartDetails details) {
    _controller.stop();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      currentTop =
          (currentTop + details.delta.dy).clamp(endPosition, closedTop);
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -300) {
      open();
    } else if (velocity > 300) {
      close();
    } else if (_isOpen) {
      // Snap back to open — covers the case of taps or tiny drags while open
      open();
    } else {
      close();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: currentTop,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        child: Container(
          key: globalKey,
          child: Column(children: [widget.child]),
        ),
      ),
    );
  }
}
