import 'package:flutter/material.dart';
import 'find_doctor_page.dart'; // import to reuse the Doctor model

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4), // Light grey matching the top section
      body: CustomScrollView(
        slivers: [
          // The Top Hero Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 440,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Upper Background color
                  Container(
                    height: 400,
                    width: double.infinity,
                    color: const Color(0xFFF3F5F4),
                  ),
                  
                  // Doctor Image (right aligned, filling the height)
                  Positioned(
                    right: -20,
                    bottom: 0,
                    height: 380, // Let the image stand large
                    child: Image.network(
                      doctor.imageUrl,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  
                  // Top Navbar (Back & Camera icons)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconButton(context, Icons.arrow_back, onTap: () => Navigator.pop(context)),
                        _buildIconButton(context, Icons.camera_alt_outlined),
                      ],
                    ),
                  ),
                  
                  // Doctor Info
                  Positioned(
                    top: 180,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Large wrapping text (needs to constrain width)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: Colors.black87,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFE2EF), // Soft blue for badge
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            doctor.specialty,
                            style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // White Sheet Content below
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 'We Offer Services' row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('We Offer', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Services', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Color(0xFFE2F0D9), shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(doctor.imageUrl),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Color(0xFF2F66F6), shape: BoxShape.circle), // Vivid blue icon
                            child: const Icon(Icons.pie_chart_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Graph Area (Using placeholder shapes for the textured bar)
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
                              stops: [0.1, 0.9],
                            ),
                          ),
                          child: CustomPaint(painter: _StripesPainter()),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFF3F4F6),
                          ),
                          child: CustomPaint(painter: _DotsPainter()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Spent / Available text
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Spent', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('\$580', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Available', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('\$830', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Service Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _ServiceCard(
                          title: 'Family\nMedicine',
                          icon: Icons.people_outline,
                          color: const Color(0xFFE2E2F6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ServiceCard(
                          title: 'Allergy &\nImmunology',
                          icon: Icons.coronavirus_outlined,
                          color: const Color(0xFFDCE2CD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF0CC), // light lime green
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Orthopedics', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 1.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sports_gymnastics, size: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceCard({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: Colors.black54),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, height: 1.2),
          ),
        ],
      ),
    );
  }
}

// Painters to simulate the texture map in the spent/available widget

class _StripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 2;
    for (double i = 10; i < size.width + size.height; i += 8) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    // draw a few random dots
    final offsets = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.6, size.height * 0.8),
    ];
    for (int i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], (i % 3) + 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
