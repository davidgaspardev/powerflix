/// External package
import 'package:flutter/material.dart';

/// Controller to the Provider widget
abstract class Controller {
  /// initilize controller
  void init(BuildContext context);
  /// [Provider] mounted
  void mounted() /** optional */ {}
  /// Build [Provider]
  void build() /** optional */ {}
  /// Clean data from Android/iOS
  void dispose();
}
