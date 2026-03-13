class Slot {
  final String id;
  final String timeRange;
  final double price;
  bool isBooked;

  Slot({
    required this.id,
    required this.timeRange,
    required this.price,
    this.isBooked = false,
  });
}
