import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_breath/main.dart';

void main() {
  testWidgets('VibeBreathApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VibeBreathApp());
    expect(find.text('BOX BREATHING'), findsOneWidget);
  });
}
