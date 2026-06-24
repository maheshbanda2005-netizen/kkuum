import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_nest/main.dart';

void main() {
  testWidgets('Smoke test - App builds and shows TripNest', (WidgetTester tester) async {
    await tester.pumpWidget(const TripNestApp());
    expect(find.text('TripNest'), findsWidgets);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
