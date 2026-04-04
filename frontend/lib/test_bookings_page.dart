import 'package:flutter/material.dart';

class TestBookingsPage extends StatelessWidget {
  const TestBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF2F4F7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdni.iconscout.com/illustration/premium/thumb/empty-state-3622432-3047240.png', 
              height: 220,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2_outlined, size: 120, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text(
              'Sorry, no test Bookings found',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Start booking lab tests at discounted prices',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF667085), fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D2939), // Dark, almost black
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                elevation: 0,
              ),
              child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 64), // Bottom offset
          ],
        ),
      ),
    );
  }
}
