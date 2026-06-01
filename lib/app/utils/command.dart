import 'package:flutter/foundation.dart';
import 'package:powerflix/app/utils/result.dart';

/**
 * Command pattern implementation
 */
abstract class Command<T> extends ChangeNotifier {
  bool running = false;
  Result<T>? _result;
}