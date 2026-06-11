import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/app/locator.dart';

abstract class _A {}

class _AImpl implements _A {}

abstract class _B {}

class _BImpl implements _B {}

void main() {
  tearDown(ServiceLocator.reset);

  group('ServiceLocator', () {
    test('get returns the registered instance', () {
      final instance = _AImpl();
      ServiceLocator.register<_A>(instance);
      expect(ServiceLocator.get<_A>(), same(instance));
    });

    test('get throws when type is not registered', () {
      expect(() => ServiceLocator.get<_A>(), throwsA(isA<TypeError>()));
    });

    test('registering the same type twice overwrites the previous instance', () {
      final first = _AImpl();
      final second = _AImpl();
      ServiceLocator.register<_A>(first);
      ServiceLocator.register<_A>(second);
      expect(ServiceLocator.get<_A>(), same(second));
    });

    test('multiple types coexist independently', () {
      final a = _AImpl();
      final b = _BImpl();
      ServiceLocator.register<_A>(a);
      ServiceLocator.register<_B>(b);
      expect(ServiceLocator.get<_A>(), same(a));
      expect(ServiceLocator.get<_B>(), same(b));
    });

    test('reset clears all registrations', () {
      ServiceLocator.register<_A>(_AImpl());
      ServiceLocator.reset();
      expect(() => ServiceLocator.get<_A>(), throwsA(isA<TypeError>()));
    });
  });
}
