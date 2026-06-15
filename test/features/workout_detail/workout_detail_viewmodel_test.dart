import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/core/domain/models/user_preferences.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/core/domain/repositories/user_repository.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_viewmodel.dart';

class _FakeUserRepository implements UserRepository {
  UserPreferences _prefs;

  _FakeUserRepository({Set<String>? initialFavorites})
      : _prefs = UserPreferences(
          favoriteWorkoutIds: initialFavorites?.toList() ?? [],
        );

  @override
  Future<UserModel?> getUser() async => null;

  @override
  Future<void> saveUser(UserModel user) async {}

  @override
  Future<UserPreferences> getPreferences() async => _prefs;

  @override
  Future<void> savePreferences(UserPreferences prefs) async => _prefs = prefs;
}

WorkoutPlan _plan() => const WorkoutPlan(
      id: 'test-plan',
      name: 'Test Plan',
      description: 'A test plan',
      coverUrl: 'https://example.com/cover.jpg',
      levels: [],
    );

void main() {
  group('WorkoutDetailViewModel', () {
    test('initial state: currentLevel=0, isFavorite=false', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      expect(vm.currentLevelNotifier.value, 0);
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('exposes the plan passed to the constructor', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      expect(vm.plan.id, 'test-plan');
      expect(vm.plan.name, 'Test Plan');
    });

    test('toggleFavorite: false → true', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite: true → false when toggled twice', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      await vm.toggleFavorite();
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('toggleFavorite notifies isFavoriteNotifier listeners', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      var notified = false;
      vm.isFavoriteNotifier.addListener(() => notified = true);
      await vm.toggleFavorite();
      expect(notified, isTrue);
    });

    test('init loads favorite state from repository', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(initialFavorites: {'test-plan'}),
      );
      await vm.init();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite persists state in repository', () async {
      final repo = _FakeUserRepository();
      final vm = WorkoutDetailViewModel(plan: _plan(), repository: repo);
      await vm.toggleFavorite();
      final prefs = await repo.getPreferences();
      expect(prefs.favoriteWorkoutIds.contains('test-plan'), isTrue);
    });

    test('onLevelChanged updates currentLevelNotifier', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged reflects the last value when called multiple times', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      vm.onLevelChanged(1);
      vm.onLevelChanged(0);
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged notifies currentLevelNotifier listeners', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      var notified = false;
      vm.currentLevelNotifier.addListener(() => notified = true);
      vm.onLevelChanged(1);
      expect(notified, isTrue);
    });

    test('dispose does not throw', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeUserRepository(),
      );
      expect(() => vm.dispose(), returnsNormally);
    });
  });
}
