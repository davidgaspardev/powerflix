import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/features/home/presentation/home_viewmodel.dart';

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle({String? content, Object? error})
      : _content = content,
        _error = error;

  final String? _content;
  final Object? _error;

  @override
  Future<ByteData> load(String key) async {
    if (_error != null) throw _error!;
    final bytes = utf8.encode(_content!);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

const _singlePlanJson = '''
[
  {
    "id": "plan-1",
    "name": "Leg Day",
    "description": "A leg workout",
    "coverUrl": "https://example.com/legs.jpg",
    "levels": [
      {
        "difficulty": "LIGHT",
        "description": "Easy",
        "volume": {"sets": 3, "reps": 10},
        "exercises": [{"order": 1, "name": "Squat"}]
      }
    ]
  }
]
''';

const _twoPlanJson = '''
[
  {
    "id": "plan-1", "name": "Leg Day", "description": "desc",
    "coverUrl": "https://example.com/a.jpg",
    "levels": [{"difficulty": "SOFT", "description": "d", "volume": {"sets": 3}, "exercises": []}]
  },
  {
    "id": "plan-2", "name": "Arm Day", "description": "desc",
    "coverUrl": "https://example.com/b.jpg",
    "levels": [{"difficulty": "HARD", "description": "d", "volume": {"sets": 5}, "exercises": []}]
  }
]
''';

void main() {
  group('HomeViewModel', () {
    test('initial state: isLoading=true, empty workouts, no error', () {
      final vm = HomeViewModel(bundle: _FakeBundle(content: _singlePlanJson));
      expect(vm.isLoading, isTrue);
      expect(vm.workouts, isEmpty);
      expect(vm.hasError, isFalse);
      expect(vm.error, isNull);
    });

    test('loadWorkouts success: populates workouts, clears error, isLoading=false', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(content: _singlePlanJson));
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.workouts, hasLength(1));
      expect(vm.workouts.first.id, 'plan-1');
      expect(vm.workouts.first.name, 'Leg Day');
    });

    test('loadWorkouts parses multiple plans correctly', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(content: _twoPlanJson));
      await vm.loadWorkouts();

      expect(vm.workouts, hasLength(2));
      expect(vm.workouts[0].id, 'plan-1');
      expect(vm.workouts[1].id, 'plan-2');
    });

    test('loadWorkouts error: sets error, workouts remain empty, isLoading=false', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(error: Exception('asset not found')));
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isTrue);
      expect(vm.error, contains('asset not found'));
      expect(vm.workouts, isEmpty);
    });

    test('loadWorkouts notifies listeners on success', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(content: _singlePlanJson));
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('loadWorkouts notifies listeners on error', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(error: Exception('fail')));
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('init() triggers loadWorkouts asynchronously', () async {
      final vm = HomeViewModel(bundle: _FakeBundle(content: _singlePlanJson));
      vm.init();
      expect(vm.isLoading, isTrue);
      await Future.delayed(Duration.zero);
      expect(vm.isLoading, isFalse);
      expect(vm.workouts, hasLength(1));
    });
  });
}
