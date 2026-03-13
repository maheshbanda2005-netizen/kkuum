import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ground_provider.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<GroundProvider>(context).myBookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _BookingFilterChip(label: 'UPCOMING', isSelected: true),
                const SizedBox(width: 8),
                _BookingFilterChip(label: 'PAST'),
                const SizedBox(width: 8),
                _BookingFilterChip(label: 'CANCELLED'),
              ],
            ),
          ),
          Expanded(
            child: bookings.isEmpty
                ? const Center(child: Text('No bookings found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return _BookingItem(booking: booking);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BookingFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _BookingFilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade700 : Colors.white,
        border: Border.all(color: isSelected ? Colors.green.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final dynamic booking;
  const _BookingItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(booking.ground.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.ground.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(DateFormat('EEEE, d MMM yyyy').format(booking.date),
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                  child: Text('UPCOMING',
                      style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.slot.timeRange, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('₹${booking.totalAmount.toInt()} paid',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {}, child: const Text('CANCEL')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('VIEW'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
