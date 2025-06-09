/// External package
import 'package:flutter/material.dart';

/// Controller to the Provider widget
abstract class Controller {
  late final BuildContext context;
  /// initilize controller
  void init() /** optional */ {}
  /// [Provider] mounted
  void mounted() /** optional */ {}
  /// Build [Provider]
  void build() /** optional */ {}
  /// Clean data from Android/iOS
  void dispose() /** optional */ {}
}
