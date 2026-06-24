import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trip_nest/utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myAccount),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Mahesh Banda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('mahesh@example.com', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildSection(context, 'Personal Information', [
              _buildListTile(Icons.person_outline, 'Profile Details'),
              _buildListTile(Icons.wallet_outlined, 'Wallet & Payments'),
              _buildListTile(Icons.favorite_border, 'My Favorites'),
            ]),
            _buildSection(context, 'Travel History', [
              _buildListTile(Icons.history, 'Previous Trips'),
              _buildListTile(Icons.reviews_outlined, 'My Reviews'),
            ]),
            _buildSection(context, 'App Settings', [
              _buildListTile(Icons.language, 'Language'),
              _buildListTile(Icons.notifications_none, 'Notifications'),
              _buildListTile(Icons.dark_mode_outlined, 'Dark Mode', isSwitch: true),
            ]),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('LOGOUT'),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, {bool isSwitch = false}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: isSwitch
          ? Switch(value: false, onChanged: (v) {}, activeColor: AppColors.primary)
          : const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: isSwitch ? null : () {},
    );
  }
}
