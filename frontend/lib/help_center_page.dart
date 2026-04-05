import 'package:flutter/material.dart';
import 'issue_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Matching HomePage background
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828), // Dark slate/black matching app's dark elements
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IssuePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1570EF), // Brand blue
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Chat With Us',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            _buildBanner(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Support Info Section
                  _buildSupportInfo(),
                  
                  const SizedBox(height: 20),

                  // Refund Section
                  _buildRefundSection(),

                  const SizedBox(height: 32),

                  // FAQs Section Header
                  const Text(
                    'FAQs',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w700, 
                      color: Color(0xFF101828),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Get answers to the most frequently asked questions.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF475467)),
                  ),
                  const SizedBox(height: 24),

                  // FAQ Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.88,
                    children: [
                      _buildFAQItem(context, 'Video\nConsultation', 'Steps for consult, Doctor or Prescription Related issues', Icons.videocam_outlined),
                      _buildFAQItem(context, 'Clinic\nAppointment', 'Appointment cancellation, confirmation, rescheduling etc', Icons.calendar_today_outlined),
                      _buildFAQItem(context, 'Medicines\nOrder', 'Payment, Refund, Delivery or Order status related issues', Icons.medication_outlined),
                      _buildFAQItem(context, 'Lab Test\nOrder', 'Delay in Collection, Report Related, Order confirmation etc', Icons.biotech_outlined),
                      _buildFAQItem(context, 'Account', 'Account related information including create, edit and update', Icons.person_outline),
                      _buildFAQItem(context, 'Membership\nRetail', 'Subscription benefits, add or remove family members usage etc', Icons.card_membership_outlined, isPlus: true),
                      _buildFAQItem(context, 'Membership\nCorporate', 'Active corporate plan, manage benefits, add/remove family, usage etc', Icons.business_outlined, isPlus: true),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF101828), Color(0xFF1D2939)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle abstract shapes to mimic premium look
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.help_outline, size: 180, color: Colors.white.withOpacity(0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hi,',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                ),
                const SizedBox(height: 4),
                Text(
                  'We are here to help you.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: const [
          Text(
            'AxioVital Support',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
          ),
          SizedBox(height: 8),
          Text(
            'Get instant support 24/7.',
            style: TextStyle(fontSize: 14, color: Color(0xFF475467)),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Refund/Cancellation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                ),
                SizedBox(height: 4),
                Text(
                  'You have 0 active refund/cancellation',
                  style: TextStyle(fontSize: 12, color: Color(0xFF475467)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '0 ACTIVE REFUND',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB54708)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String title, String subtitle, IconData icon, {bool isPlus = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IssuePage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF2F4F7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF101828),
                      height: 1.2,
                    ),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: const Color(0xFF344054), size: 22),
                    ),
                    if (isPlus)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F56D9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PLUS',
                            style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF475467), height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

