import 'package:flutter/material.dart';
import '../models/ground_model.dart';
import '../models/slot_model.dart';
import 'booking_summary_screen.dart';
import 'package:intl/intl.dart';

class SlotSelectionScreen extends StatefulWidget {
  final Ground ground;

  const SlotSelectionScreen({super.key, required this.ground});

  @override
  State<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends State<SlotSelectionScreen> {
  DateTime _selectedDate = DateTime.now();
  Slot? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<Slot> slots = widget.ground.availability[dateStr] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ground.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('SELECT DATE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime date = DateTime.now().add(Duration(days: index));
                bool isSelected = DateFormat('yyyy-MM-dd').format(date) == dateStr;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDate = date;
                    _selectedSlot = null;
                  }),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade700 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('EEE').format(date),
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                        Text(DateFormat('d').format(date),
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('AVAILABLE SLOTS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Expanded(
            child: slots.isEmpty
                ? const Center(child: Text('No slots available for this date'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      bool isSelected = _selectedSlot?.id == slot.id;
                      return GestureDetector(
                        onTap: slot.isBooked
                            ? null
                            : () => setState(() => _selectedSlot = slot),
                        child: Container(
                          decoration: BoxDecoration(
                            color: slot.isBooked
                                ? Colors.red.shade100
                                : (isSelected ? Colors.green.shade700 : Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected ? Colors.green.shade700 : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              slot.timeRange.split(' - ')[0], // Short version
                              style: TextStyle(
                                color: slot.isBooked
                                    ? Colors.red
                                    : (isSelected ? Colors.white : Colors.black),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _LegendItem(color: Colors.green, label: 'Available'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.red, label: 'Booked'),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedSlot == null
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingSummaryScreen(
                                ground: widget.ground, date: _selectedDate, slot: _selectedSlot!),
                          ),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(_selectedSlot == null
                    ? 'SELECT A SLOT'
                    : 'PROCEED TO BOOKING (₹${_selectedSlot!.price})'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
