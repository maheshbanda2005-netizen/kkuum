import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trip_nest/models/destination.dart';
import 'package:trip_nest/services/booking_service.dart';
import 'package:trip_nest/utils/app_colors.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(destination.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(destination.name, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.favorite_border, color: AppColors.error),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                      const SizedBox(width: 4),
                      Text(destination.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(Icons.star, Colors.amber, destination.rating.toString()),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.access_time, Colors.blue, 'Open Now'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Description', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(destination.description, style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
                  const SizedBox(height: 32),
                  _buildDetailSection(loc.quickInfo, [
                    _buildDetailItem(Icons.payments_outlined, 'Entry Fee', destination.entryFee),
                    _buildDetailItem(Icons.history_toggle_off, 'Timings', destination.timings),
                    _buildDetailItem(Icons.wb_sunny_outlined, 'Best Season', destination.bestSeason),
                  ]),
                  const SizedBox(height: 32),
                  Text('Nearby Attractions', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildNearbyItem('Mecca Masjid', '0.2 km'),
                        _buildNearbyItem('Chowmahalla Palace', '0.8 km'),
                        _buildNearbyItem('Salar Jung Museum', '1.5 km'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => BookingService.launchBooking(destination.videoUrl, destination.videoUrl),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(loc.watchVideo),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => BookingService.launchBooking('', 'https://www.google.com/maps/search/${destination.name}'),
                          icon: const Icon(Icons.map),
                          label: Text(loc.viewMap),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyItem(String name, String dist) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(dist, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
