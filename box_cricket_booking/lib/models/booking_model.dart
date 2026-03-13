import 'ground_model.dart';
import 'slot_model.dart';

enum BookingStatus { upcoming, past, cancelled }

class Booking {
  final String id;
  final Ground ground;
  final Slot slot;
  final DateTime date;
  final double totalAmount;
  final BookingStatus status;
  final String qrCodeData;

  Booking({
    required this.id,
    required this.ground,
    required this.slot,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.qrCodeData,
  });
}
