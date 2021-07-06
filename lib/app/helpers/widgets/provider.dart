/// External package
import 'package:flutter/material.dart';
/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';

/// Defining screen
typedef Screen = Widget Function();

/// Provider
class Provider<T extends Controller> extends StatefulWidget {
  // Attributes
  final T controller;
  final Screen screen;
  final bool useMaterial;

  /// Get controller associated with this typed [Provider]
  static T of<T extends Controller>(BuildContext context) {
    Provider<T> provider = context.findAncestorWidgetOfExactType<Provider<T>>()!;
    return provider.controller;
  }

  /// Constant constructor (optional)
  /// 
  /// If your class produces objects that never change, you can make these objects 
  /// compile-time constants. To do this, define a const constructor and 
  /// make sure that all instance variables are final.
  const Provider({
    Key? key,
    required this.controller,
    required this.screen,
    this.useMaterial = false,
  }) : super(key: key);

  @override
  _ProviderState createState() => _ProviderState();
}

class _ProviderState extends State<Provider> with WidgetsBindingObserver {

  // Getters methods
  Controller get controller => widget.controller;
  Screen get screen => widget.screen;
  bool get useMaterial => widget.useMaterial;

  void _log(String methodName, {String? message}) {
    print("[ Provider | $methodName] ${message ?? ""}");
  }

  @override
  void initState() {
    // The initState method is only executed once, after the widget object instantiation. 
    // It can be user to do pre-configuration for the screen.
    super.initState();
    // Initializing screen controller
    controller.init(context);
    // Listener state change 
    WidgetsBinding.instance!.addObserver(this);

    WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
      // After the first build
      controller.mounted();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    // Send build signal to the controller
    controller.build();
    // Check if is to use material widget
    if (useMaterial) return Material(child: screen());
    return screen();
  }

  @override
  void dispose() {
    // Remove all listtener from this provider
    WidgetsBinding.instance!.removeObserver(this);
    // Deposing controller
    controller.dispose();
    super.dispose();
  }
}
