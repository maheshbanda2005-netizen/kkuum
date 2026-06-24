import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trip_nest/models/destination.dart';
import 'package:trip_nest/screens/destination_detail_screen.dart';
import 'package:trip_nest/utils/app_colors.dart';

class DestinationListScreen extends StatelessWidget {
  const DestinationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<Destination> destinations = [
      Destination(
        id: '1',
        name: 'Charminar',
        location: 'Hyderabad, India',
        description: 'A 16th-century mosque with four grand arches and minarets, Charminar is the global icon of Hyderabad. Surrounded by bustling markets, it stands as a testament to the city\'s rich history and architectural brilliance.',
        imageUrl: 'https://images.unsplash.com/photo-1590766948512-48175d13f1d1?q=80&w=600',
        rating: 4.7,
        entryFee: '₹25 (Indians), ₹300 (Foreigners)',
        timings: '9:30 AM - 5:30 PM',
        bestSeason: 'October to March',
        galleryUrls: [
          'https://images.unsplash.com/photo-1590766948512-48175d13f1d1?q=80&w=400',
          'https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=400',
        ],
        videoUrl: 'https://www.youtube.com/watch?v=X-X-X',
      ),
      Destination(
        id: '2',
        name: 'Golconda Fort',
        location: 'Hyderabad, India',
        description: 'Once the capital of the Qutb Shahi kingdom, this massive fortress is famous for its acoustic effects, grand structure, and the legendary Hope Diamond that was once stored here.',
        imageUrl: 'https://images.unsplash.com/photo-1600100397608-f010e42ed38a?q=80&w=600',
        rating: 4.6,
        entryFee: '₹25 (Indians), ₹300 (Foreigners)',
        timings: '9:00 AM - 5:30 PM',
        bestSeason: 'October to March',
        galleryUrls: [],
        videoUrl: 'https://www.youtube.com/watch?v=Y-Y-Y',
      ),
      Destination(
        id: '3',
        name: 'Taj Mahal',
        location: 'Agra, India',
        description: 'An immense mausoleum of white marble, built in Agra between 1631 and 1648 by order of the Mughal emperor Shah Jahan in memory of his favourite wife.',
        imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657451dad?q=80&w=600',
        rating: 4.9,
        entryFee: '₹50 (Indians), ₹1100 (Foreigners)',
        timings: '6:00 AM - 6:30 PM',
        bestSeason: 'November to February',
        galleryUrls: [],
        videoUrl: 'https://www.youtube.com/watch?v=Z-Z-Z',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.explore, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DestinationDetailScreen(destination: destination)),
              );
            },
            child: Card(
              margin: const EdgeInsets.bottom(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(destination.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(destination.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(destination.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(destination.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
