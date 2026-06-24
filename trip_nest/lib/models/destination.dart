class Destination {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final double rating;
  final String entryFee;
  final String timings;
  final String bestSeason;
  final List<String> galleryUrls;
  final String videoUrl;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.entryFee,
    required this.timings,
    required this.bestSeason,
    required this.galleryUrls,
    required this.videoUrl,
  });
}
