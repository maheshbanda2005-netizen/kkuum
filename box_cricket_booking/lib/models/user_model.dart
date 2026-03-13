class AppUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String? phone;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.phone,
  });
}
