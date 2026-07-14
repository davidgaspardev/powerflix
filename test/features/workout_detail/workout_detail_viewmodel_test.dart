import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_preferences_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/toggle_favorite_workout_use_case.dart';
import 'package:moveflix/features/workout/presentation/detail/workout_detail_viewmodel.dart';

class _FakeWorkoutPreferencesRepository implements WorkoutPreferencesRepository {
  WorkoutPreferences _prefs;

  _FakeWorkoutPreferencesRepository({Set<String>? initialFavorites})
      : _prefs = WorkoutPreferences(
          favoriteWorkoutIds: initialFavorites?.toList() ?? [],
        );

  @override
  Future<WorkoutPreferences> getPreferences() async => _prefs;

  @override
  Future<void> savePreferences(WorkoutPreferences prefs) async =>
      _prefs = prefs;
}

WorkoutPlan _plan() => const WorkoutPlan(
      id: 'test-plan',
      name: 'Test Plan',
      description: 'A test plan',
      coverUrl: 'https://example.com/cover.jpg',
      levels: [],
    );

WorkoutDetailViewModel _vm({
  _FakeWorkoutPreferencesRepository? repo,
}) {
  final r = repo ?? _FakeWorkoutPreferencesRepository();
  return WorkoutDetailViewModel(
    plan: _plan(),
    getPreferences: GetWorkoutPreferencesUseCase(r),
    toggleFavorite: ToggleFavoriteWorkoutUseCase(r),
  );
}

void main() {
  group('WorkoutDetailViewModel', () {
    test('initial state: currentLevel=0, isFavorite=false', () {
      final vm = _vm();
      expect(vm.currentLevelNotifier.value, 0);
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('exposes the plan passed to the constructor', () {
      final vm = _vm();
      expect(vm.plan.id, 'test-plan');
      expect(vm.plan.name, 'Test Plan');
    });

    test('toggleFavorite: false → true', () async {
      final vm = _vm();
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite: true → false when toggled twice', () async {
      final vm = _vm();
      await vm.toggleFavorite();
      await vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('toggleFavorite notifies isFavoriteNotifier listeners', () async {
      final vm = _vm();
      var notified = false;
      vm.isFavoriteNotifier.addListener(() => notified = true);
      await vm.toggleFavorite();
      expect(notified, isTrue);
    });

    test('init loads favorite state from repository', () async {
      final vm = _vm(
        repo: _FakeWorkoutPreferencesRepository(
          initialFavorites: {'test-plan'},
        ),
      );
      await vm.init();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite persists state in repository', () async {
      final repo = _FakeWorkoutPreferencesRepository();
      final vm = _vm(repo: repo);
      await vm.toggleFavorite();
      final prefs = await repo.getPreferences();
      expect(prefs.favoriteWorkoutIds.contains('test-plan'), isTrue);
    });

    test('onLevelChanged updates currentLevelNotifier', () {
      final vm = _vm();
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged reflects the last value when called multiple times', () {
      final vm = _vm();
      vm.onLevelChanged(1);
      vm.onLevelChanged(0);
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged notifies currentLevelNotifier listeners', () {
      final vm = _vm();
      var notified = false;
      vm.currentLevelNotifier.addListener(() => notified = true);
      vm.onLevelChanged(1);
      expect(notified, isTrue);
    });

    test('dispose does not throw', () {
      final vm = _vm();
      expect(() => vm.dispose(), returnsNormally);
    });
  });
}
