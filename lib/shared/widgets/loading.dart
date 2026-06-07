import 'package:flutter/material.dart';
import 'package:powerflix/shared/widgets/label.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() => setState(() {}));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Opacity(
        opacity: _animation.value,
        child: Image.asset('assets/image/logo.png'),
      ),
    );
  }
}

class LoadingError extends StatefulWidget {
  final String message;

  const LoadingError({super.key, required this.message});

  @override
  State<LoadingError> createState() => _LoadingErrorState();
}

class _LoadingErrorState extends State<LoadingError> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 48),
        Label(
          'Não foi possível carregar',
          textAlign: TextAlign.center,
          padding: const EdgeInsets.all(8),
        ),
        if (_showDetail)
          Label(
            widget.message,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
        GestureDetector(
          onTap: () => setState(() => _showDetail = !_showDetail),
          child: Container(
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
            child: Label(
              _showDetail ? 'ocultar detalhes' : 'ver detalhes',
              textAlign: TextAlign.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }
}
