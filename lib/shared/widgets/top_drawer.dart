import 'package:flutter/material.dart';

/// A panel that slides down from the top of the screen.
///
/// When closed, only the [footer] is visible (pinned at the top).
/// When opened, the full panel — safe area + [menu] + [footer] — slides down
/// over [child], with a dim barrier covering the rest of the screen.
class TopDrawer extends StatefulWidget {
  final double menuHeight;
  final double footerHeight;
  final WidgetBuilder menuBuilder;
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen) footerBuilder;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color barrierColor;
  final Color panelColor;

  const TopDrawer({
    super.key,
    required this.menuHeight,
    required this.footerHeight,
    required this.menuBuilder,
    required this.footerBuilder,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.barrierColor = Colors.black54,
    this.panelColor = Colors.white,
  });

  @override
  State<TopDrawer> createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final panelHeight = topInset + widget.menuHeight + widget.footerHeight;

    return Stack(
      children: [
        widget.child,
        if (_isOpen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggle,
              child: ColoredBox(color: widget.barrierColor),
            ),
          ),
        AnimatedPositioned(
          duration: widget.duration,
          curve: widget.curve,
          top: _isOpen ? 0 : -widget.menuHeight,
          left: 0,
          right: 0,
          height: panelHeight,
          child: ColoredBox(
            color: widget.panelColor,
            child: Column(
              children: [
                SizedBox(height: topInset),
                SizedBox(
                  height: widget.menuHeight,
                  width: double.infinity,
                  child: Builder(builder: widget.menuBuilder),
                ),
                SizedBox(
                  height: widget.footerHeight,
                  width: double.infinity,
                  child: Builder(
                    builder: (ctx) => widget.footerBuilder(ctx, _toggle, _isOpen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
