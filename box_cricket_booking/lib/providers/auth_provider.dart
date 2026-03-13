import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  bool _isLoggedIn = false;
  final AuthService _authService = AuthService();

  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      // Simulate fetching user data
      _user = AppUser(
        id: 'google-uid-12345',
        name: 'Rahul Sharma',
        email: 'rahul.sharma@gmail.com',
        photoUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      );
    }
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      _user = user;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> continueAsGuest() async {
    _isLoggedIn = true;
    _user = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}
