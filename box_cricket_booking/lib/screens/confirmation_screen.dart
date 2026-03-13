import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const ConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text('SUCCESS!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
              const Text('BOOKING CONFIRMED',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    const Text('🏏', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 16),
                    // Simulated QR Code
                    Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.qr_code_2, size: 120),
                    ),
                    const SizedBox(height: 16),
                    Text('BOOKING ID: ${booking.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailRow('🏟️ GROUND', booking.ground.name),
              _buildDetailRow('📅 DATE', DateFormat('EEEE, d MMM yyyy').format(booking.date)),
              _buildDetailRow('🕒 TIME', booking.slot.timeRange),
              _buildDetailRow('💰 AMOUNT PAID', '₹${booking.totalAmount.toInt()}'),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('BACK TO HOME'),
              ),
              TextButton(
                onPressed: () {}, // Navigate to My Bookings
                child: const Text('VIEW MY BOOKINGS', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
