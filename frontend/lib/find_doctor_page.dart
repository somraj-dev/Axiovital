import 'package:flutter/material.dart';
import 'dart:ui';
import 'doctor_details_page.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String qualifications;
  final String imageUrl;
  final int sessionPrice;
  final Color cardColor;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.imageUrl,
    required this.sessionPrice,
    required this.cardColor,
  });
}

const List<Doctor> mockDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. Jessica Miller',
    specialty: 'Cardiologist',
    qualifications: 'MBBS, FCPS (Cardiology)',
    imageUrl: 'https://ui-avatars.com/api/?name=Jessica+Miller&background=DBE7D6&color=444&size=400',
    sessionPrice: 120,
    cardColor: Color(0xFFDBE7D6), // Soft green
  ),
  Doctor(
    id: '2',
    name: 'Dr. William Harris',
    specialty: 'ENT Specialist',
    qualifications: 'ENT Specialist',
    imageUrl: 'https://ui-avatars.com/api/?name=William+Harris&background=E4DDF5&color=444&size=400', 
    sessionPrice: 130,
    cardColor: Color(0xFFE4DDF5), // Soft purple
  ),
  Doctor(
    id: '3',
    name: 'Dr. Andreaw Jamison',
    specialty: 'Neurologist',
    qualifications: 'MD, PhD',
    imageUrl: 'https://ui-avatars.com/api/?name=Andreaw+Jamison&background=E2E8F0&color=444&size=400',
    sessionPrice: 180,
    cardColor: Color(0xFFE2E8F0), 
  ),
];

class FindDoctorPage extends StatelessWidget {
  const FindDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black54),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.black26),
                          SizedBox(width: 8),
                          Text('Find your doctor...', style: TextStyle(color: Colors.black38)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Expert Medical Help\nAnytime',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _CategoryPill('Cardiologist', isSelected: false),
                  _CategoryPill('Psychiatrist', isSelected: false),
                  _CategoryPill('Orthopedics', isSelected: false),
                  _CategoryPill('Neurologist', isSelected: false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Doctor List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                itemCount: mockDoctors.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return _DoctorCard(doctor: mockDoctors[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _CategoryPill(this.label, {required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => DoctorDetailsPage(doctor: doctor),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: doctor.cardColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            // Doctor cropped image in the background (right aligned)
            Positioned(
              right: 0,
              bottom: 0,
              top: 20,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(28),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    // slightly tone down the image so text pops. (Optional, since the design looks clean)
                    Colors.transparent, 
                    BlendMode.multiply,
                  ),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 180,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 180,
                      color: Colors.white24,
                      child: const Center(child: Icon(Icons.person, size: 80, color: Colors.white54)),
                    ),
                  ),
                ),
              ),
            ),
            
            // Text Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    doctor.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.qualifications,
                    style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$ ${doctor.sessionPrice}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.black87),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '/session',
                        style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Translucent Book Appointment Button
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_outward, size: 16, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          'Book Appointment',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
