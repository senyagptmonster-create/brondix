import 'package:flutter_test/flutter_test.dart';
import 'package:brondix/brondix_app.dart';

void main() {
  testWidgets('BrondixApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrondixApp());
    await tester.pump();
    expect(find.text('Stamp Cards'), findsWidgets);
  });
}
