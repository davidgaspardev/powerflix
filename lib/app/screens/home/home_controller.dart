/// External package
import 'package:flutter/material.dart';
/// Internal package
import 'package:powerflix/app/helpers/abstraction/controller.dart';

/// Home controller
class HomeController extends Controller {
  /// Reference to the location in the tree structure
  late BuildContext context;
  /// Widget notification for update
  final countNotifier = ValueNotifier<int>(0);

  
  int get currentCount => countNotifier.value;

  /// Send change to notifier
  void increment() {
    countNotifier.value += 1;
  }

  // ========================== OVERRIDE ========================== //

  @override
  void init(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
    this.countNotifier.dispose();
  }
}
