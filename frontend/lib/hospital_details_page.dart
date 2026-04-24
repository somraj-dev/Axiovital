import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class HospitalDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hospital;

  const HospitalDetailsPage({super.key, required this.hospital});

  @override
  State<HospitalDetailsPage> createState() => _HospitalDetailsPageState();
}

class _HospitalDetailsPageState extends State<HospitalDetailsPage> {
  final Color primaryDarkBlue = const Color(0xFF1E2A4F);
  final Color primaryDarkGreen = const Color(0xFF0F3D3E);
  final Color greenAccent = const Color(0xFF00BFA5);

  void _addToCart({
    required String id,
    required String name,
    required double price,
    required CartItemType type,
    String subtitle = '',
  }) {
    Provider.of<CartProvider>(context, listen: false).addItem(
      productId: id,
      name: name,
      price: price,
      imagePath: widget.hospital['image'] ?? 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=800&q=80',
      type: type,
      subtitle: subtitle,
      fulfilledBy: widget.hospital['name'] ?? 'Hospital',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryDarkBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryDarkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.hospital['name'] ?? 'Hospital Details', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 24),
                      _buildStatsRow(),
                      const SizedBox(height: 24),
                      _buildAvailabilityBoxes(),
                      const SizedBox(height: 16),
                      _buildInsuranceBox(),
                      const SizedBox(height: 24),
                      _buildBookServices(),
                      const SizedBox(height: 24),
                      _buildTopDepartments(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildFacilitiesRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Image.network(
          widget.hospital['image'] ?? 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=800&q=80',
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 220,
            color: Colors.grey.shade300,
            child: const Icon(Icons.local_hospital, size: 60, color: Colors.grey),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFF00BFA5), size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.hospital['rating'] ?? '4.8',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.hospital['name'] ?? 'CityCare Hospital',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E2A4F)),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: Color(0xFF00BFA5), size: 20),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.hospital['type'] ?? 'Multi Speciality Hospital',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${widget.hospital['location'] ?? 'Indiranagar, Bengaluru'}, Karnataka',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '~2.4 km',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.star_outline, widget.hospital['rating'] ?? '4.8', 'Rating'),
        _buildStatItem(Icons.chat_bubble_outline, '1.2K+', 'Patient Reviews'),
        _buildStatItem(Icons.person_outline, '250+', 'Doctors'),
        _buildStatItem(Icons.bed_outlined, '500+', 'Beds'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
      ],
    );
  }

  Widget _buildAvailabilityBoxes() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green tint
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.bed_outlined, color: Color(0xFF00BFA5), size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text('${widget.hospital['beds'] ?? 125} Beds Available', style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, color: Color(0xFF00BFA5), size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('24x7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      SizedBox(height: 2),
                      Text('Emergency Care', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security, color: Color(0xFF1E2A4F), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cashless Insurance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2A4F), fontSize: 14)),
                SizedBox(height: 4),
                Text('We accept 25+ insurance providers', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBookServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Book Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2A4F))),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _addToCart(
                  id: 'hosp_apt_${widget.hospital['name']}',
                  name: 'Appointment at ${widget.hospital['name']}',
                  price: 500.0,
                  type: CartItemType.appointment,
                  subtitle: widget.hospital['type'] ?? 'General Consultation',
                ),
                child: _buildServiceCard(Icons.calendar_month, 'Book Appointment', 'Consult with our specialists'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _addToCart(
                  id: 'hosp_bed_${widget.hospital['name']}',
                  name: 'Bed Booking at ${widget.hospital['name']}',
                  price: 2500.0,
                  type: CartItemType.hospitalBed,
                  subtitle: 'Standard Bed',
                ),
                child: _buildServiceCard(Icons.bed_outlined, 'Book a Bed', 'Check availability and book'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: primaryDarkBlue, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2A4F)), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTopDepartments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top Departments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2A4F))),
            Text('View All', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDepartmentIcon(Icons.favorite_border, 'Cardiology', '25 Doctors', Colors.pink.shade50, Colors.pink),
            _buildDepartmentIcon(Icons.psychology_outlined, 'Neurology', '18 Doctors', Colors.blue.shade50, Colors.blue),
            _buildDepartmentIcon(Icons.accessibility_new_outlined, 'Orthopaedics', '22 Doctors', Colors.grey.shade100, Colors.grey.shade700),
            _buildDepartmentIcon(Icons.spa_outlined, 'Gastroenterology', '15 Doctors', Colors.purple.shade50, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildDepartmentIcon(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2A4F)), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About ${widget.hospital['name'] ?? 'CityCare Hospital'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2A4F))),
        const SizedBox(height: 12),
        Text(
          '${widget.hospital['name'] ?? 'CityCare Hospital'} is a leading multi speciality hospital committed to providing world-class healthcare with compassion and excellence. Equipped with advanced technology and a team of experienced specialists, we ensure the best outcomes for our patients.',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 8),
        Text('Read More', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFacilitiesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFacilityItem(Icons.verified_outlined, 'NABH\nAccredited'),
        _buildFacilityItem(Icons.local_pharmacy_outlined, '24x7\nPharmacy'),
        _buildFacilityItem(Icons.monitor_heart_outlined, 'Advanced\nICU'),
        _buildFacilityItem(Icons.directions_bus_outlined, 'Ambulance\nService'),
      ],
    );
  }

  Widget _buildFacilityItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00BFA5), size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2A4F)), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEXT AVAILABLE APPOINTMENT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Today, 06:30 PM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryDarkGreen)),
                ],
              ),
              ElevatedButton(
                onPressed: () => _addToCart(
                  id: 'hosp_apt_footer_${widget.hospital['name']}',
                  name: 'Appointment at ${widget.hospital['name']}',
                  price: 500.0,
                  type: CartItemType.appointment,
                  subtitle: widget.hospital['type'] ?? 'Next Available',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDarkBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Row(
                  children: [
                    Text('Book Appointment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
