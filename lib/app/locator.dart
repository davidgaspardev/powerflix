class ServiceLocator {
  ServiceLocator._();

  static final _registry = <Type, Object>{};

  static void register<T extends Object>(T instance) {
    _registry[T] = instance;
  }

  static T get<T extends Object>() => _registry[T] as T;
}