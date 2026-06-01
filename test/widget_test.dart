import 'package:flutter_test/flutter_test.dart';

import 'package:powerflix/main.dart';

void main() {
  testWidgets('App smoke test — renders without exception',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
