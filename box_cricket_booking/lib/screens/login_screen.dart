import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏏', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              const Text('Welcome to', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                'Box Cricket Booking',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 8),
              const Text("India's #1 Turf Booking App", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 60),
              _buildGoogleSignInButton(context),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).continueAsGuest();
                  Navigator.pushReplacementNamed(context, '/main');
                },
                child: const Text('Continue as Guest', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
              const SizedBox(height: 40),
              const Text(
                'By continuing, you agree to our\nTerms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          bool success = await Provider.of<AuthProvider>(context, listen: false).loginWithGoogle();
          if (success) {
            if (context.mounted) Navigator.pushReplacementNamed(context, '/main');
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign-in failed. Please try again.')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            const Text('Continue with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
