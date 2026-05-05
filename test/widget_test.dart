import 'package:biydaaltproject/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Naadam app loads access page in preview mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NaadamApp());

    expect(find.text('Naadam Access'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}
