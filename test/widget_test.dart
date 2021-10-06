// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bike_life/views/widgets/nav_button.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bike_life/main.dart';

void main() {
  testWidgets('Test home actions', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.widgetWithText(AppNavButton, 'Se connecter'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppNavButton, 'Se connecter'));
    await tester.pump();
  });
}
