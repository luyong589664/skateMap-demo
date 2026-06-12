import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';

void main() {
  testWidgets('App should display map page', (WidgetTester tester) async {
    await tester.pumpWidget(const SkateMapApp());

    expect(find.text('地图页'), findsOneWidget);
  });
}
