import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/core/domain/repositories/favorites_repository.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_viewmodel.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  final Map<String, bool> _data = {};

  @override
  Future<bool> isFavorite(String id) async => _data[id] ?? false;

  @override
  Future<void> setFavorite(String id, bool value) async => _data[id] = value;
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
        repository: _FakeFavoritesRepository(),
      );
      expect(vm.currentLevelNotifier.value, 0);
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('exposes the plan passed to the constructor', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      expect(vm.plan.id, 'test-plan');
      expect(vm.plan.name, 'Test Plan');
    });

    test('toggleFavorite: false → true', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite: true → false when toggled twice', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      await vm.toggleFavorite();
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('toggleFavorite notifies isFavoriteNotifier listeners', () async {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      var notified = false;
      vm.isFavoriteNotifier.addListener(() => notified = true);
      await vm.toggleFavorite();
      expect(notified, isTrue);
    });

    test('init loads favorite state from repository', () async {
      final repo = _FakeFavoritesRepository();
      await repo.setFavorite('test-plan', true);
      final vm = WorkoutDetailViewModel(plan: _plan(), repository: repo);
      await vm.init();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite persists state in repository', () async {
      final repo = _FakeFavoritesRepository();
      final vm = WorkoutDetailViewModel(plan: _plan(), repository: repo);
      await vm.toggleFavorite();
      expect(await repo.isFavorite('test-plan'), isTrue);
    });

    test('onLevelChanged updates currentLevelNotifier', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged reflects the last value when called multiple times', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      vm.onLevelChanged(1);
      vm.onLevelChanged(0);
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged notifies currentLevelNotifier listeners', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      var notified = false;
      vm.currentLevelNotifier.addListener(() => notified = true);
      vm.onLevelChanged(1);
      expect(notified, isTrue);
    });

    test('dispose does not throw', () {
      final vm = WorkoutDetailViewModel(
        plan: _plan(),
        repository: _FakeFavoritesRepository(),
      );
      expect(() => vm.dispose(), returnsNormally);
    });
  });
}
