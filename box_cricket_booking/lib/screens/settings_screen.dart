import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'my_bookings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 50,
              backgroundImage: authProvider.user?.photoUrl != null
                  ? NetworkImage(authProvider.user!.photoUrl)
                  : null,
              child: authProvider.user?.photoUrl == null ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 16),
            Text(authProvider.user?.name ?? 'Guest User',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(authProvider.user?.email ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _SettingsTile(
              icon: Icons.calendar_today,
              title: 'My Bookings',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBookingsScreen())),
            ),
            _SettingsTile(
              icon: Icons.account_balance_wallet,
              title: 'Wallet',
              trailing: const Text('₹500', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.language,
              title: 'Language',
              trailing: DropdownButton<String>(
                value: localeProvider.locale.languageCode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                  DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
                ],
                onChanged: (code) {
                  if (code != null) localeProvider.setLocale(Locale(code));
                },
              ),
              onTap: () {},
            ),
            const _SettingsTile(icon: Icons.notifications, title: 'Notifications'),
            const _SettingsTile(icon: Icons.help_outline, title: 'Help & Support'),
            const _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy'),
            _SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red,
              onTap: () async {
                await authProvider.logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Colors.black87),
      title: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
