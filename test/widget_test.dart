import 'package:flutter_test/flutter_test.dart';
import 'package:brondix/brondix_app.dart';

void main() {
  testWidgets('BrondixApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrondixApp());
    expect(find.text('BRONDIX STAMP WALLET'), findsOneWidget);
    expect(find.text('PUNCH COFFEE STAMP (+1)'), findsOneWidget);
  });
}
