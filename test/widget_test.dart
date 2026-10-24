import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimasi_rute_driver/app.dart';

void main() {
  testWidgets('App boots with RouteDriver shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('RouteDriver'), findsOneWidget);
  });
}
