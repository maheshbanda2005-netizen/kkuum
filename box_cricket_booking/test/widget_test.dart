import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:box_cricket_booking/main.dart';
import 'package:box_cricket_booking/providers/auth_provider.dart';
import 'package:box_cricket_booking/providers/locale_provider.dart';
import 'package:box_cricket_booking/providers/ground_provider.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => GroundProvider()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Box Cricket Booking'), findsOneWidget);
  });
}
