import 'package:flutter/material.dart';
import 'find_doctor_page.dart';
import 'widgets/axio_avatar.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3282), // Dark blue from references
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specialty,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.star_border, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Block
              _buildHeaderSection(),
              
              // Divider
              Container(height: 8, color: const Color(0xFFF3F5F4)),

              // Patient Stories Summary
              _buildPatientStoriesSummary(),

              // Patient Stories List
              _buildPatientStoriesList(),

              // Divider
              Container(height: 8, color: const Color(0xFFF3F5F4)),

              // Clinic Details
              _buildClinicDetails(),

              // Divider
              Container(height: 8, color: const Color(0xFFF3F5F4)),

              // Location Tab
              _buildLocationDetails(),

              // Clinic Photos
              _buildClinicPhotos(),

              // Divider
              Container(height: 8, color: const Color(0xFFF3F5F4)),

              // About the doctor
              _buildAboutSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomStickyBar(),
    );
  }

  Widget _buildBottomStickyBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('NEXT AVAILABLE AT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                Text('10:00 AM, tomorrow', style: TextStyle(color: Color(0xFF00B02A), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Color(0xFF2E90FA), size: 18),
              label: const Text('Call Clinic', style: TextStyle(color: Color(0xFF2E90FA), fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF2E90FA)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AxioAvatar(
                radius: 40,
                imageUrl: doctor.imageUrl,
                name: doctor.name,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${doctor.specialty}, Interventional ${doctor.specialty}',
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(doctor.qualifications, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('21 Years overall experience', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.thumb_up, color: Color(0xFF00B02A), size: 16),
                        SizedBox(width: 4),
                        Text('100%', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 12),
                        Icon(Icons.chat_bubble, color: Color(0xFF00B02A), size: 16),
                        SizedBox(width: 4),
                        Text('2 Patient Stories', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Clinic Visit Card
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Light blue header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9F5FB),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.home, color: Color(0xFF2E90FA), size: 20),
                      SizedBox(width: 8),
                      Text('Book Clinic Visit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pariniti Heart Centre', style: TextStyle(fontSize: 15, color: Colors.black87)),
                          Text('₹ ${doctor.sessionPrice} fee', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Govindpuri, ~6.4 km', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      const Divider(height: 32),
                      const Text('Clinic accepts appointment only via calls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('To check for doctor availability and appointment confirmation, please call the clinic', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2E90FA)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Contact Clinic', style: TextStyle(color: Color(0xFF2E90FA), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientStoriesSummary() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('2 Patient Stories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 12),
          const Text(
            "These stories represent patient opinions and experiences. They do not reflect the doctor's medical capabilities.",
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Row(
                children: const [
                  Icon(Icons.thumb_up, color: Color(0xFF00B02A), size: 32),
                  SizedBox(width: 8),
                  Text('100%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 20)),
              const Expanded(
                child: Text(
                  'Out of all patients who were surveyed, 100% of them recommend visiting this doctor',
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('SHOWING STORIES FOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: const Text('All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('2 STORIES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Row(
                children: const [
                  Text('Sorted by Most Helpful', style: TextStyle(fontSize: 14, color: Colors.black87)),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientStoriesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildReviewItem(
            'I have never seen a Docter like Prateek ,he saved my father\'s life.We know, life is in God\'s control ,but the kind of trust ,s...Read More',
          ),
          const Divider(height: 32),
          _buildReviewItem(
            'listen problem patiently and recommend medicine after all test and now My wife feeling good.My wife feeling nervousness...Read More',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Share Your Story', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AxioAvatar(radius: 18, backgroundColor: Color(0xFF333333), name: 'Verified Patient'),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Verified Patient', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('5 years ago', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(Icons.thumb_up_alt_outlined, color: Colors.black54, size: 16),
            SizedBox(width: 8),
            Text('I recommend this doctor!', style: TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }

  Widget _buildClinicDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Clinic Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pariniti Heart Centre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Multi Speciality Clinic', style: TextStyle(color: Colors.black54, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Govindpuri • ~6.4km', style: TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('₹${doctor.sessionPrice} In-clinic fees', style: const TextStyle(color: Colors.black87, fontSize: 14)),
                ],
              ),
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.business, color: Colors.grey, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Timings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTimingCard('Fri - Sat', '10:00 AM - 01:00 PM\n05:00 PM - 07:30 PM'),
                const SizedBox(width: 12),
                _buildTimingCard('Sun', 'CLOSED'),
                const SizedBox(width: 12),
                _buildTimingCard('Mon - Thu', '10:00 AM - 01:00 PM\n05:00 PM - 07:30 PM'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, color: Color(0xFF2D3282), size: 18),
                  label: const Text('Contact Clinic', style: TextStyle(color: Color(0xFF2D3282), fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions, color: Colors.black87, size: 18),
                  label: const Text('Get Directions', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimingCard(String day, String times) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(times, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildLocationDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  // Instead of an actual map image, just use a light pattern
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Govindpuri&zoom=14&size=400x200&sensor=false'), // generic map placeholder
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.lighten)
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D3282).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2D3282).withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFF2D3282), size: 40),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: const Text('Tap on the map for complete address', style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicPhotos() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Clinic Photos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=150&h=150&q=80', width: 100, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network('https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=150&h=150&q=80', width: 100, height: 100, fit: BoxFit.cover),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About The Doctor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    const Text('Listed on Practo since October 2019', style: TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
              ),
              AxioAvatar(
                radius: 36,
                imageUrl: doctor.imageUrl,
                name: doctor.name,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF2D3282), size: 18),
              const SizedBox(width: 8),
              Text(doctor.qualifications, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.verified, color: Color(0xFF2D3282), size: 18),
              SizedBox(width: 8),
              Text('Council verified practitioner', style: TextStyle(color: Colors.black87, fontSize: 14)),
              SizedBox(width: 4),
              Icon(Icons.info_outline, color: Colors.grey, size: 16),
            ],
          ),
          const SizedBox(height: 32),
          const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          const Icon(Icons.format_quote, color: Colors.grey, size: 24),
          const SizedBox(height: 8),
          const Text(
            'MBBS (AIIMS, Delhi), MD DM\n(PGI,Chandigarh)\nFSCAI (USA)\nWorked extensively in India and Abroad, total 15 yrs, more than 15000 heart surgeries done',
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text('${doctor.name} has claimed their profile', style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline))),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Education and achievements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Know more about ${doctor.name}\'s education, practices and affiliations.',
            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text('View more details', style: TextStyle(color: Color(0xFF00CED1), fontSize: 15)), // cyan color
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
