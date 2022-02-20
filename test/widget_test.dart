import 'package:flutter_test/flutter_test.dart';

import 'package:bike_life/main.dart';

void main() {
  testWidgets('Test home actions', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}
