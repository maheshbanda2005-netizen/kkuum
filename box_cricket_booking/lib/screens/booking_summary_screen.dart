import 'package:flutter/material.dart';
import '../models/ground_model.dart';
import '../models/slot_model.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  final Ground ground;
  final DateTime date;
  final Slot slot;

  const BookingSummaryScreen({
    super.key,
    required this.ground,
    required this.date,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    double gst = slot.price * 0.18;
    double platformFee = 20;
    double total = slot.price + gst + platformFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Booking', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(ground.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ground.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(ground.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              title: 'BOOKING DETAILS',
              items: [
                _InfoRow(label: 'Date', value: DateFormat('EEEE, d MMM yyyy').format(date)),
                _InfoRow(label: 'Time', value: slot.timeRange),
                _InfoRow(label: 'Duration', value: '1 Hour'),
                _InfoRow(label: 'Players', value: 'Upto 12'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'PRICE DETAILS',
              items: [
                _InfoRow(label: 'Ground Charges', value: '₹${slot.price.toInt()}'),
                _InfoRow(label: 'GST (18%)', value: '₹${gst.toInt()}'),
                _InfoRow(label: 'Platform Fee', value: '₹${platformFee.toInt()}'),
                const Divider(),
                _InfoRow(
                  label: 'TOTAL AMOUNT',
                  value: '₹${total.toInt()}',
                  isBold: true,
                  color: Colors.green.shade700,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('APPLY COUPON', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                suffixIcon: TextButton(onPressed: () {}, child: const Text('APPLY')),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('CANCELLATION POLICY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('• Before 3 hrs: Full refund', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Text('• Before 1 hr: 50% refund', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Text('• After: No refund', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(ground: ground, date: date, slot: slot, totalAmount: total),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('CONFIRM & PAY ₹${total.toInt()}'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _InfoRow({required this.label, required this.value, this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
