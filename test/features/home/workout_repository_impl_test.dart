import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/domain/models/workout_plan.dart';
import 'package:moveflix/features/home/data/datasources/workout_cache_datasource.dart';
import 'package:moveflix/features/home/data/datasources/workout_datasource.dart';
import 'package:moveflix/features/home/data/repositories/workout_repository_impl.dart';

// ── fakes ──────────────────────────────────────────────────────────────────

class _FakeSource implements WorkoutDatasource {
  final List<WorkoutPlan> plans;
  int callCount = 0;

  _FakeSource(this.plans);

  @override
  Future<List<WorkoutPlan>> fetchWorkouts() async {
    callCount++;
    return plans;
  }
}

class _FakeCache implements WorkoutCacheDatasource {
  List<WorkoutPlan> _stored = [];
  int getCachedCallCount = 0;
  int cacheCallCount = 0;

  void seed(List<WorkoutPlan> plans) => _stored = List.of(plans);

  @override
  Future<List<WorkoutPlan>> getCached() async {
    getCachedCallCount++;
    return List.of(_stored);
  }

  @override
  Future<void> cache(List<WorkoutPlan> plans) async {
    cacheCallCount++;
    _stored = List.of(plans);
  }

  @override
  Future<void> clearCache() async => _stored = [];
}

// ── helpers ────────────────────────────────────────────────────────────────

WorkoutPlan _plan(String id) => WorkoutPlan(
      id: id,
      name: id,
      description: '',
      coverUrl: '',
      levels: const [],
    );

// ── tests ──────────────────────────────────────────────────────────────────

void main() {
  group('WorkoutRepositoryImpl — cache-aside', () {
    test('cold start: reads from source, writes to cache, returns plans', () async {
      final source = _FakeSource([_plan('p1'), _plan('p2')]);
      final cache = _FakeCache();
      final repo = WorkoutRepositoryImpl(source, cache);

      final result = await repo.getWorkouts();

      expect(result, hasLength(2));
      expect(source.callCount, 1);
      expect(cache.cacheCallCount, 1);
      expect(cache.getCachedCallCount, 1);
    });

    test('warm cache: returns from cache without touching source', () async {
      final source = _FakeSource([_plan('p1')]);
      final cache = _FakeCache()..seed([_plan('p1'), _plan('p2')]);
      final repo = WorkoutRepositoryImpl(source, cache);

      final result = await repo.getWorkouts();

      expect(result, hasLength(2));
      expect(source.callCount, 0);
    });

    test('second call hits cache populated on first call', () async {
      final source = _FakeSource([_plan('p1')]);
      final cache = _FakeCache();
      final repo = WorkoutRepositoryImpl(source, cache);

      await repo.getWorkouts();
      await repo.getWorkouts();

      expect(source.callCount, 1);
    });

    test('returns correct plan data from source on cold start', () async {
      final source = _FakeSource([_plan('abc')]);
      final cache = _FakeCache();
      final repo = WorkoutRepositoryImpl(source, cache);

      final result = await repo.getWorkouts();

      expect(result.first.id, 'abc');
    });

    test('returns correct plan data from warm cache', () async {
      final source = _FakeSource([]);
      final cache = _FakeCache()..seed([_plan('xyz')]);
      final repo = WorkoutRepositoryImpl(source, cache);

      final result = await repo.getWorkouts();

      expect(result.first.id, 'xyz');
    });
  });
}
