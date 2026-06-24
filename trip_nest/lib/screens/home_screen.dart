import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trip_nest/models/booking_option.dart';
import 'package:trip_nest/services/booking_service.dart';
import 'package:trip_nest/screens/destination_list_screen.dart';
import 'package:trip_nest/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<BookingOption> options = [
      BookingOption(title: 'Hotels', icon: FontAwesomeIcons.hotel, appUrl: 'booking://', webUrl: 'https://www.booking.com', type: BookingType.hotel, color: Colors.blue),
      BookingOption(title: 'Flights', icon: FontAwesomeIcons.plane, appUrl: 'makemytrip://', webUrl: 'https://www.makemytrip.com/flights/', type: BookingType.flight, color: Colors.indigo),
      BookingOption(title: 'Bus', icon: FontAwesomeIcons.bus, appUrl: 'redbus://', webUrl: 'https://www.redbus.in', type: BookingType.bus, color: Colors.redAccent),
      BookingOption(title: 'Train', icon: FontAwesomeIcons.train, appUrl: 'irctc://', webUrl: 'https://www.irctc.co.in', type: BookingType.train, color: Colors.orange),
      BookingOption(title: 'Cars', icon: FontAwesomeIcons.car, appUrl: 'uber://', webUrl: 'https://www.uber.com', type: BookingType.car, color: Colors.green),
      BookingOption(title: 'Bikes', icon: FontAwesomeIcons.motorcycle, appUrl: 'royalbrothers://', webUrl: 'https://www.royalbrothers.com', type: BookingType.bike, color: Colors.teal),
      BookingOption(title: 'Food', icon: FontAwesomeIcons.utensils, appUrl: 'zomato://', webUrl: 'https://www.zomato.com', type: BookingType.restaurant, color: Colors.pink),
      BookingOption(title: 'Hostels', icon: FontAwesomeIcons.bed, appUrl: 'hostelworld://', webUrl: 'https://www.hostelworld.com', type: BookingType.hostel, color: Colors.deepPurple),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loc.appTitle, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, Color(0xFF1565C0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(FontAwesomeIcons.earthAmericas, size: 200, color: Colors.white.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: loc.searchHint,
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: AppColors.primary),
                        suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.mic, color: AppColors.primary)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(loc.planTrip, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return GestureDetector(
                        onTap: () => BookingService.launchBooking(option.appUrl, option.webUrl),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: option.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(option.icon, color: option.color, size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(option.title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(loc.trendingNow, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      TextButton(onPressed: () {}, child: Text(loc.seeAll)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTrendingCard('Goa', 'Beaches & Fun', 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?q=80&w=400'),
                        _buildTrendingCard('Manali', 'Snowy Mountains', 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?q=80&w=400'),
                        _buildTrendingCard('Kerala', 'Backwaters', 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?q=80&w=400'),
                      ],
                    ),
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

  Widget _buildTrendingCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
