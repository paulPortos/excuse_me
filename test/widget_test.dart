import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excuse_me/main.dart';

void main() {
  testWidgets('App loads input screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ExcuseMeApp(),
      ),
    );

    // Verify that the input screen title is displayed.
    expect(find.text('Excuse Me 👋'), findsOneWidget);

    // Verify that the continue button exists.
    expect(find.text('Continue'), findsOneWidget);
  });
}
