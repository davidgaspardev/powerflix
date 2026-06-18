import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:powerflix/app/databases/hive_adapter.dart';
import 'package:powerflix/app/locator.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/core/domain/models/user_preferences.dart';
import 'package:powerflix/core/domain/repositories/user_repository.dart';
import 'package:powerflix/features/home/domain/repositories/workout_repository.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/main.dart';

class _FakeUserRepository implements UserRepository {
  @override Future<UserModel?> getUser() async => null;
  @override Future<void> saveUser(UserModel user) async {}
  @override Future<UserPreferences> getPreferences() async => const UserPreferences();
  @override Future<void> savePreferences(UserPreferences prefs) async {}
}

class _FakeWorkoutRepository implements WorkoutRepository {
  @override Future<List<WorkoutPlan>> getWorkouts() async => [];
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_widget_test_');
    Hive.init(tempDir.path);
    loadTypeAdapters();
    ServiceLocator.register<UserRepository>(_FakeUserRepository());
    ServiceLocator.register<WorkoutRepository>(_FakeWorkoutRepository());
  });

  tearDownAll(() async {
    ServiceLocator.reset();
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('App smoke test — renders without exception',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/register'));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
