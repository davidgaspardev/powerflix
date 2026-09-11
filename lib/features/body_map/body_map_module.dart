import 'package:moveflix/app/locator.dart';
import 'package:moveflix/features/body_map/data/repositories/body_map_repository_impl.dart';
import 'package:moveflix/features/body_map/domain/repositories/body_map_repository.dart';

class BodyMapModule {
  static void register() {
    ServiceLocator.register<BodyMapRepository>(
      BodyMapRepositoryImpl(),
    );
  }
}
