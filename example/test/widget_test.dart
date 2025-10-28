import 'package:flutter_test/flutter_test.dart';
import 'package:enviro_example/main.dart';

void main() {
  testWidgets('Enviro example app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EnviroExampleApp());

    // Verify that the app loads without crashing
    expect(find.text('Enviro Example'), findsOneWidget);
    expect(find.text('Environment Selection'), findsOneWidget);
    expect(find.text('Environment Variables'), findsOneWidget);
  });
}
