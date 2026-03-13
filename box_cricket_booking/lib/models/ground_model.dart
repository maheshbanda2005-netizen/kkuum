import 'slot_model.dart';

class Ground {
  final String id;
  final String name;
  final String location;
  final double rating;
  final double basePrice;
  final String imageUrl;
  final String description;
  final List<String> facilities;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final Map<String, List<Slot>> availability; // Date string -> List of slots

  Ground({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.basePrice,
    required this.imageUrl,
    required this.description,
    required this.facilities,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.availability,
  });
}
