import 'package:flutter/material.dart';
import '../models/ground_model.dart';
import '../models/slot_model.dart';
import '../models/booking_model.dart';

class GroundProvider with ChangeNotifier {
  List<Ground> _grounds = [];
  final List<Booking> _myBookings = [];

  List<Ground> get grounds => _grounds;
  List<Booking> get myBookings => _myBookings;

  GroundProvider() {
    _initializeData();
  }

  void _initializeData() {
    // Mock Data
    _grounds = [
      Ground(
        id: 'G1',
        name: 'Super Cricket Turf',
        location: 'Andheri East, Mumbai',
        rating: 4.8,
        basePrice: 800,
        imageUrl: 'https://img3.khelomore.com/venues/2292/coverphoto/1040x490/IMG-4258.jpg',
        description: 'Premium synthetic turf with excellent floodlights and facilities.',
        facilities: ['Floodlights', 'Parking', 'Drinking Water', 'Washroom', 'Changing Room'],
        ownerName: 'Rajesh Kumar',
        ownerPhone: '+91 98765 43210',
        ownerEmail: 'superturf@gmail.com',
        availability: {
          '2024-01-15': _generateSlots(800),
          '2024-01-16': _generateSlots(800),
        },
      ),
      Ground(
        id: 'G2',
        name: 'Cricket Arena',
        location: 'Bandra West, Mumbai',
        rating: 4.6,
        basePrice: 900,
        imageUrl: 'https://content.jdmagicbox.com/v2/comp/hyderabad/s3/040pxx40.xx40.210203205029.m9s3/catalogue/sixer-zone-box-cricket-uppal-hyderabad-cricket-turf-grounds-2xief16ulc.jpg',
        description: 'Indoor box cricket facility with high nets.',
        facilities: ['Floodlights', 'Parking', 'Equipment Rental'],
        ownerName: 'Amit Shah',
        ownerPhone: '+91 98765 12345',
        ownerEmail: 'arena@gmail.com',
        availability: {
          '2024-01-15': _generateSlots(900),
        },
      ),
    ];
    notifyListeners();
  }

  List<Slot> _generateSlots(double basePrice) {
    return [
      Slot(id: 'S1', timeRange: '6:00 AM - 7:00 AM', price: basePrice),
      Slot(id: 'S2', timeRange: '7:00 AM - 8:00 AM', price: basePrice),
      Slot(id: 'S3', timeRange: '6:00 PM - 7:00 PM', price: basePrice + 200),
      Slot(id: 'S4', timeRange: '7:00 PM - 8:00 PM', price: basePrice + 200, isBooked: true),
      Slot(id: 'S5', timeRange: '8:00 PM - 9:00 PM', price: basePrice + 200),
    ];
  }

  void addBooking(Booking booking) {
    _myBookings.add(booking);
    // Mark slot as booked in our mock data
    final ground = _grounds.firstWhere((g) => g.id == booking.ground.id);
    final dateStr = booking.date.toIso8601String().split('T')[0];
    final slots = ground.availability[dateStr];
    if (slots != null) {
      final slot = slots.firstWhere((s) => s.id == booking.slot.id);
      slot.isBooked = true;
    }
    notifyListeners();
  }
}
