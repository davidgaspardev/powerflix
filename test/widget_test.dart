import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:powerflix/app/databases/hive_adapter.dart';
import 'package:powerflix/main.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_widget_test_');
    Hive.init(tempDir.path);
    loadTypeAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('App smoke test — renders without exception',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/register'));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
