import '../models/user_model.dart';

class AuthService {
  Future<AppUser?> signInWithGoogle() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return AppUser(
      id: 'google-uid-12345',
      name: 'Rahul Sharma',
      email: 'rahul.sharma@gmail.com',
      photoUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    );
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
