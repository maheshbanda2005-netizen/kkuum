import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.satellite), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // Simulated Map
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('GOOGLE MAPS INTEGRATION', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text('(Simulated for this project)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          // Markers (Simulated)
          const Positioned(top: 150, left: 100, child: _MapMarker(price: '₹800')),
          const Positioned(top: 250, right: 80, child: _MapMarker(price: '₹900')),
          const Positioned(bottom: 200, left: 150, child: Icon(Icons.my_location, color: Colors.blue, size: 30)),
          // Selected Ground Preview
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://img3.khelomore.com/venues/2292/coverphoto/1040x490/IMG-4258.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Super Turf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('⭐ 4.5 • 800m • ₹800/hr', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('Open Now • 5 slots available',
                            style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String price;
  const _MapMarker({required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const Icon(Icons.location_on, color: Colors.green, size: 30),
      ],
    );
  }
}
