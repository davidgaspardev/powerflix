import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/workout_detail/presentation/workout_detail_viewmodel.dart';

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
      final vm = WorkoutDetailViewModel(plan: _plan());
      expect(vm.currentLevelNotifier.value, 0);
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('exposes the plan passed to the constructor', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      expect(vm.plan.id, 'test-plan');
      expect(vm.plan.name, 'Test Plan');
    });

    test('toggleFavorite: false → true', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isTrue);
    });

    test('toggleFavorite: true → false when toggled twice', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      vm.toggleFavorite();
      vm.toggleFavorite();
      expect(vm.isFavoriteNotifier.value, isFalse);
    });

    test('toggleFavorite notifies isFavoriteNotifier listeners', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      var notified = false;
      vm.isFavoriteNotifier.addListener(() => notified = true);
      vm.toggleFavorite();
      expect(notified, isTrue);
    });

    test('onLevelChanged updates currentLevelNotifier', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged reflects the last value when called multiple times', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      vm.onLevelChanged(1);
      vm.onLevelChanged(0);
      vm.onLevelChanged(2);
      expect(vm.currentLevelNotifier.value, 2);
    });

    test('onLevelChanged notifies currentLevelNotifier listeners', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      var notified = false;
      vm.currentLevelNotifier.addListener(() => notified = true);
      vm.onLevelChanged(1);
      expect(notified, isTrue);
    });

    test('dispose does not throw', () {
      final vm = WorkoutDetailViewModel(plan: _plan());
      expect(() => vm.dispose(), returnsNormally);
    });
  });
}
