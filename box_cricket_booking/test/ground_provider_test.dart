import 'package:flutter_test/flutter_test.dart';
import 'package:box_cricket_booking/providers/ground_provider.dart';

void main() {
  group('GroundProvider Tests', () {
    test('Initial grounds list is not empty', () {
      final provider = GroundProvider();
      expect(provider.grounds.isNotEmpty, true);
    });

    test('Ground availability has slots', () {
      final provider = GroundProvider();
      final ground = provider.grounds.first;
      final slots = ground.availability.values.first;
      expect(slots.isNotEmpty, true);
    });
  });
}
