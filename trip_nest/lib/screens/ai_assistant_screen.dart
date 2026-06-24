import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trip_nest/utils/app_colors.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi! I\'m your TripNest AI. Ask me about hotels, destinations, or travel tips!', 'isUser': false},
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        String response = 'That sounds interesting! Let me look that up for you.';
        if (text.toLowerCase().contains('hotel')) {
          response = 'I found some top-rated hotels in Hyderabad like The Park and ITC Kohenur. Would you like to see more?';
        } else if (text.toLowerCase().contains('weather')) {
          response = 'The weather in your destination is currently 28°C with clear skies. Perfect for sightseeing!';
        }
        _messages.add({'text': response, 'isUser': false});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(loc.aiHelper),
        actions: [
          IconButton(onPressed: () => _navigateToEmergency(context), icon: const Icon(Icons.sos, color: AppColors.error)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : Colors.grey[100],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send, color: Colors.white, size: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEmergency(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
  }
}

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.emergency)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.warning_amber_rounded, size: 80, color: AppColors.error),
            ),
            const SizedBox(height: 24),
            Text(loc.emergency, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(loc.sosDesc, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                child: Text(loc.activateSos, style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
            _buildContactTile(Icons.local_police, 'Police', '100'),
            _buildContactTile(Icons.medical_services, 'Ambulance', '102'),
            _buildContactTile(Icons.support_agent, 'Tourist Helpline', '1800-XXX-XXXX'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String title, String number) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(number),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.green)),
    );
  }
}
