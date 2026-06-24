import 'package:flutter/material.dart';

enum BookingType { hotel, hostel, bus, train, flight, car, bike, restaurant }

class BookingOption {
  final String title;
  final IconData icon;
  final String appUrl;
  final String webUrl;
  final BookingType type;
  final Color color;

  BookingOption({
    required this.title,
    required this.icon,
    required this.appUrl,
    required this.webUrl,
    required this.type,
    this.color = Colors.blue,
  });
}
