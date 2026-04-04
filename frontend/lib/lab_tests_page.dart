import 'package:flutter/material.dart';
import 'upload_report_page.dart';
import 'widgets/axio_avatar.dart';

class LabTestsPage extends StatelessWidget {
  const LabTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Location & Cart)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5247),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Gwalior',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF344054)),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 24, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search for 'ultrasound'",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: SizedBox(width: 20),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.search, color: Colors.black, size: 24),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Quick Action Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction('Full body\nPackages', Icons.person_add_alt_1_outlined, const Color(0xFFF9E8FF)),
                    _buildQuickAction('Book via\nCall', Icons.phone_in_talk_outlined, const Color(0xFFE3F2FD)),
                    _buildQuickAction('Book via\nWhatsapp', Icons.chat_outlined, const Color(0xFFE8F5E9)),
                    _buildQuickAction('Upload\nPrescription', Icons.description_outlined, const Color(0xFFFFF1F2)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Promo Banner (Ticket Style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade50),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAYDAY SALE',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1.5, color: Color(0xFFC70000)),
                            ),
                            Text(
                              'UP TO 60% OFF',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'on Full Body Checkups',
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Extra 15% off on your first test | Code: AXIOVITAL',
                              style: TextStyle(fontSize: 10, color: Color(0xFFD32D2D), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/512/3063/3063822.png',
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Package Carousel Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPackageCard(
                        'Comprehensive Silver Package', 
                        '55% OFF', 
                        'https://images.unsplash.com/photo-1576091160550-217359f42f8c?w=400',
                        '84 tests',
                        '2026', '3598'
                      ),
                      _buildPackageCard(
                        'Comprehensive Gold Package', 
                        '56% OFF', 
                        'https://images.unsplash.com/photo-1581056771107-24ca5f033842?w=400',
                        '86 tests',
                        '2498', '4098'
                      ),
                      _buildPackageCard(
                        'Good Health Gold Package', 
                        '60% OFF', 
                        'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=400',
                        '80 tests',
                        '1699', '3798'
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 6. Most booked health checkups (Filtered list)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Most booked health checkups',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1D2939)),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildToggleTab('Packages', isActive: true),
                    const SizedBox(width: 12),
                    _buildToggleTab('Tests', isActive: false),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Re-use package carousel for the "Most booked" items too
              _buildHorizontalPackageList(), 
              const SizedBox(height: 32),

              // 7. Categories Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Lab tests & packages',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryCircle('For Women', 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=200'),
                      _buildCategoryCircle('For Men', 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200'),
                      _buildCategoryCircle('X-Rays', 'https://images.unsplash.com/photo-1516062423079-7ca13cdc7f5a?w=200'),
                      _buildCategoryCircle('Lifestyle', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=200'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 8. Women's Promo Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5247),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Explore Packages for Women',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 9. Detailed Home Sample Collection Guide
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'How does home sample collection\nfor lab tests work?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, height: 1.2, color: Color(0xFF1D2939)),
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailedStep(Icons.fact_check_outlined, 'Booking completion', 'User selects all required tests and\ncollection time slot'),
              _buildDetailedStep(Icons.home_work_outlined, 'Safe home sample collection', 'Highly trained phlebotomist adhering\nto stringent safety standards collects the\nsample at your home'),
              _buildDetailedStep(Icons.local_shipping_outlined, 'Sample delivery to labs for testing', 'Phlebotomist delivers your sample to\nlab with standard safety guidelines'),
              _buildDetailedStep(Icons.assignment_turned_in_outlined, 'Online report delivery and free\ndoctor consultation', 'Reports are delivered on your\nregistered email ID. You can avail a\nfree doctor consultation to better\nunderstand your lab report'),
              const SizedBox(height: 48),

              // 10. Benefit Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBenefitItem(Icons.verified_user_outlined, 'Trusted &\nAccredited Labs'),
                    _buildBenefitItem(Icons.medical_services_outlined, 'Doctor curated\nPackages'),
                    _buildBenefitItem(Icons.bloodtype_outlined, 'Home Sample\nCollection'),
                    _buildBenefitItem(Icons.timer_outlined, 'Accurate &\nFast Reports'),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // 11. Digital Health Reports Section (Image 3)
              _buildDigitalHealthReports(context),

              const SizedBox(height: 60),

              // 12. Final AxioVital Footer
              Container(
                width: double.infinity,
                color: const Color(0xFFF8F9FB),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Making healthcare',
                      style: TextStyle(color: Color(0xFF667085), fontSize: 16),
                    ),
                    const Text(
                      'Understandable, Accessible & Affordable',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF4B5563), height: 1.4),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Made with ', style: TextStyle(color: Color(0xFF667085), fontSize: 14)),
                        const Icon(Icons.favorite, color: Colors.red, size: 16),
                        const Text(' by ', style: TextStyle(color: Color(0xFF667085), fontSize: 14)),
                        const Text(
                          'AxioVital', 
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueGrey.shade800, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF344054)),
        ),
      ],
    );
  }

  Widget _buildToggleTab(String label, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D2939) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPackageCard(String title, String discount, String imgUrl, String tests, String currentPrice, String originalPrice) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(imgUrl, height: 110, width: 210, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E8FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(discount, style: const TextStyle(color: Color(0xFF8A00C4), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D2939))
                ),
                const SizedBox(height: 4),
                Text('Contains $tests', style: const TextStyle(color: Color(0xFF667085), fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('₹$currentPrice', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black)),
                    const SizedBox(width: 6),
                    Text(
                      '₹$originalPrice', 
                      style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12, decoration: TextDecoration.lineThrough)
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE7FDF0), borderRadius: BorderRadius.circular(4)), 
                      child: Text(discount, style: const TextStyle(color: Color(0xFF039855), fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF5247), width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('BOOK', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalPackageList() {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildPackageCard(
              'Comprehensive New Year Package', 
              '44% OFF', 
              'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=400',
              '84 tests',
              '2026', '3598'
            ),
            _buildPackageCard(
              'Full Body Checkup Special', 
              '55% OFF', 
              'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=400',
              '80 tests',
              '1699', '3798'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCircle(String label, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          AxioAvatar(
            radius: 40,
            imageUrl: imgUrl,
            name: label,
            backgroundColor: Colors.grey.shade100,
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
        ],
      ),
    );
  }

  Widget _buildDetailedStep(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF667085), size: 32)
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1D2939))),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667085), fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1570EF), size: 30),
        const SizedBox(height: 12),
        Text(
          label, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Color(0xFF667085), fontWeight: FontWeight.w500)
        ),
      ],
    );
  }

  Widget _buildDigitalHealthReports(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'DIGITAL HEALTH REPORTS',
                style: TextStyle(
                  color: Color(0xFF667085), 
                  fontSize: 13, 
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.info_outline, size: 18, color: Colors.blue.shade200),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                _buildReportItem('BloodTest_March.pdf', 'Clinical Lab A', 'March 10, 2026'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: Colors.grey.shade100, thickness: 1),
                ),
                _buildReportItem('XRay_Chest_Final.jpg', 'Modern Imaging', 'Feb 15, 2026'),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadReportPage()),
                      );
                    },
                    icon: const Icon(Icons.note_add_outlined, size: 22, color: Color(0xFF2E90FA)),
                    label: const Text('Upload New Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E90FA),
                      side: BorderSide(color: Colors.blue.shade100, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: const Color(0xFFF9FAFB),
                      textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String filename, String lab, String date) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF8FF), // Light blue variant for icons
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.description_rounded, color: Color(0xFF2E90FA), size: 28),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filename, 
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF101828))
              ),
              const SizedBox(height: 6),
              Text(
                '$lab • $date', 
                style: const TextStyle(color: Color(0xFF667085), fontSize: 13, fontWeight: FontWeight.normal)
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Color(0xFF98A2B3), size: 24),
      ],
    );
  }
}

// Helper extension for RoundedRectangleBorder as array syntax is limited in code replacement
extension RoundedExt on OutlinedButton {
  ButtonStyle roundedStyle(double r) => OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r)));
}
