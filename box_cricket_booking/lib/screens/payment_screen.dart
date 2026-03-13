import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ground_model.dart';
import '../models/slot_model.dart';
import '../models/booking_model.dart';
import '../providers/ground_provider.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  final Ground ground;
  final DateTime date;
  final Slot slot;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.ground,
    required this.date,
    required this.slot,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('PAYABLE AMOUNT', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('₹${totalAmount.toInt()}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('SELECT PAYMENT METHOD',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            _PaymentOption(
              icon: Icons.account_balance_wallet,
              title: 'WALLET',
              subtitle: 'Box Cricket Wallet (Balance: ₹500)',
              onTap: () {},
            ),
            _PaymentOption(
              icon: Icons.qr_code,
              title: 'UPI',
              subtitle: 'Google Pay • PhonePe • Paytm',
              onTap: () => _processPayment(context),
            ),
            _PaymentOption(
              icon: Icons.credit_card,
              title: 'CARDS',
              subtitle: 'Credit / Debit Cards',
              onTap: () {},
            ),
            _PaymentOption(
              icon: Icons.account_balance,
              title: 'NET BANKING',
              subtitle: 'All Major Banks',
              onTap: () {},
            ),
            _PaymentOption(
              icon: Icons.handshake,
              title: 'PAY ON ARRIVAL',
              subtitle: 'Pay at Ground (Cash/UPI)',
              onTap: () => _processPayment(context),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Column(
                children: [
                  Text('Secured by Razorpay', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('256-bit SSL Encryption', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) async {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;
    Navigator.pop(context); // Remove progress indicator

    final booking = Booking(
      id: 'BC${DateTime.now().millisecondsSinceEpoch}',
      ground: ground,
      slot: slot,
      date: date,
      totalAmount: totalAmount,
      status: BookingStatus.upcoming,
      qrCodeData: 'https://box-cricket-booking.com/verify/BC${DateTime.now().millisecondsSinceEpoch}',
    );

    Provider.of<GroundProvider>(context, listen: false).addBooking(booking);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ConfirmationScreen(booking: booking)),
      (route) => route.isFirst,
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
