import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class LabTestDetailsPage extends StatefulWidget {
  final String title;
  final double currentPrice;
  final double originalPrice;
  final String discountPercentage;
  final String testCount;

  const LabTestDetailsPage({
    super.key,
    required this.title,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.testCount,
  });

  @override
  State<LabTestDetailsPage> createState() => _LabTestDetailsPageState();
}

class _LabTestDetailsPageState extends State<LabTestDetailsPage> {
  void _addToCart() {
    Provider.of<CartProvider>(context, listen: false).addItem(
      productId: 'pkg_${widget.title.replaceAll(' ', '_')}',
      name: widget.title,
      price: widget.currentPrice,
      imagePath: 'https://images.unsplash.com/photo-1576091160550-217359f42f8c?w=400',
      type: CartItemType.labTest,
      timing: '24-48 hrs',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} added to cart'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderInfo(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Divider(color: Color(0xFFEAECF0), thickness: 1, height: 1),
              ),
              _buildPricingAndCoupon(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Divider(color: Color(0xFFEAECF0), thickness: 1, height: 1),
              ),
              _buildMoreOffers(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Divider(color: Color(0xFFEAECF0), thickness: 1, height: 1),
              ),
              _buildKnowMoreSection(),
              const SizedBox(height: 16),
              _buildConductedBy(),
              _buildUnderstandingSection(),
              _buildFAQSection(),
              _buildReviewerInfo(),
              _buildNeedHelp(),
              _buildReferences(),
              const SizedBox(height: 100), // Padding for sticky bottom bar
            ],
          ),
        ),
      ),
      bottomSheet: _buildStickyBottomBar(),
    );
  }

  Widget _buildHeaderInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1D2939)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Also referred as', style: TextStyle(color: Color(0xFF667085), fontSize: 14)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Diabetes package', style: TextStyle(color: Color(0xFF344054), fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('+1', style: TextStyle(color: Color(0xFF344054), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF2E90FA), size: 20),
              const SizedBox(width: 8),
              const Text('7,368+ booked recently', style: TextStyle(color: Color(0xFF344054), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.transgender, color: Colors.purple.shade300, size: 20),
              const SizedBox(width: 8),
              const Text('For ', style: TextStyle(color: Color(0xFF344054), fontSize: 14)),
              const Text('men & women', style: TextStyle(color: Color(0xFF344054), fontSize: 14, decoration: TextDecoration.underline)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Earliest reports in', style: TextStyle(color: Color(0xFF475467), fontSize: 12)),
                          Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade600),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Color(0xFF12B76A), size: 16),
                          const SizedBox(width: 6),
                          const Text('21 hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
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
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Contains', style: TextStyle(color: Color(0xFF475467), fontSize: 12)),
                          Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade600),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.science, color: Color(0xFF2E90FA), size: 16),
                          const SizedBox(width: 6),
                          Text('${widget.testCount} tests', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingAndCoupon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Package price:', style: TextStyle(color: Color(0xFF475467), fontSize: 14)),
              const SizedBox(width: 8),
              Text('₹${widget.currentPrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
              const SizedBox(width: 8),
              Text('₹${widget.originalPrice.toInt()}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14, decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 6),
              Text(widget.discountPercentage, style: const TextStyle(color: Color(0xFF039855), fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2E90FA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upto 15% extra discount with\ncoupon',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D2939), height: 1.4),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Min. order value: ₹5000 | Coupon: 1MGNEWG',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF2E90FA)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5247),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('BOOK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOffers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FADF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.percent, color: Color(0xFF039855), size: 14),
            ),
            const SizedBox(width: 12),
            const Text('More offers available', style: TextStyle(fontSize: 16, color: Color(0xFF1D2939))),
            const Spacer(),
            const Text('View all', style: TextStyle(color: Color(0xFFFF5247), fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Color(0xFFFF5247), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowMoreSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade100.withOpacity(0.5),
            Colors.blue.shade50.withOpacity(0.5),
            Colors.pink.shade50.withOpacity(0.5),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Know more about this test',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF6941C6)),
          ),
          Container(
            height: 3,
            width: 100,
            margin: const EdgeInsets.only(top: 4, bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF9B8AFB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xFF1D2939), fontSize: 14, height: 1.5, fontFamily: 'Inter'),
                children: [
                  TextSpan(text: 'The ${widget.title} is a health assessment designed to screen for diabetes and monitor related risk factors. It includes a set of tests that measure important markers linked to bl... '),
                  TextSpan(text: 'See more', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKnowMoreCard(
                  Icons.bloodtype_outlined,
                  'Samples required',
                  'Urine & Blood',
                  Colors.purple.shade300,
                  Colors.purple.shade50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKnowMoreCard(
                  Icons.science_outlined,
                  'Find out',
                  'Why is this\npackage booked?',
                  Colors.purple.shade400,
                  Colors.green.shade700,
                  subtitleColor: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildKnowMoreRowCard(
            Icons.access_time_outlined,
            'Preparations',
            'Overnight fasting required for 8 to 12 hours',
          ),
          const SizedBox(height: 12),
          _buildKnowMoreRowCard(
            Icons.delivery_dining_outlined,
            'Sample Collection',
            'Who will collect your samples?',
          ),
        ],
      ),
    );
  }

  Widget _buildKnowMoreCard(IconData icon, String title, String subtitle, Color iconColor, Color titleColor, {Color? subtitleColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 28),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: titleColor == Colors.purple.shade50 ? Colors.grey.shade600 : titleColor, fontSize: 12, fontWeight: titleColor == Colors.purple.shade50 ? FontWeight.normal : FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: subtitleColor ?? const Color(0xFF1D2939), fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildKnowMoreRowCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple.shade300, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF1D2939), fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildConductedBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Conducted by',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      child: const Text('Tata 1mg Labs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Positioned(
                      top: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_right, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, color: Colors.green.shade300, size: 24),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const Text('Most trusted labs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('By customers', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.eco, color: Colors.green.shade300, size: 24),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabBadge('Accredited\nlabs'),
                    Container(height: 30, width: 1, color: Colors.grey.shade200),
                    _buildLabBadge('Highly\nskilled...'),
                    Container(height: 30, width: 1, color: Colors.grey.shade200),
                    _buildLabBadge('Verified\nreports'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF6941C6),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Who will collect your samples?', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Tata 1mg certified phlebotomists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_right, size: 16, color: Color(0xFF6941C6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLabBadge(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFF475467), fontSize: 13, height: 1.3),
    );
  }

  Widget _buildUnderstandingSection() {
    return Container(
      color: const Color(0xFFF9FAFB),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Understanding ${widget.title}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
          ),
          const SizedBox(height: 12),
          Text(
            'The ${widget.title} offers an in-depth evaluation of metabolic, cardiovascular, and kidney health, essential for comprehensive diabetes care. With the information obtained from these tests, individuals and doctors make informed decisions about medication, diet, and lifestyle adjustments to optimize diabetes care and improve overall health.',
            style: const TextStyle(color: Color(0xFF475467), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      'Why is the ${widget.title} important?',
      'What are the tests offered in the ${widget.title}?',
      'What are the risks associated with the ${widget.title}?',
      'How often should I book the ${widget.title}?',
      'Who should get the ${widget.title}?',
      'Can I take the ${widget.title} during pregnancy?',
      'What is the difference between type 1 and type 2 diabetes?',
      'What should I do if my results are abnormal?',
      'How does Tata 1mg ensure accurate lab test results?'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'FAQs related to ${widget.title}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
          ),
        ),
        const SizedBox(height: 8),
        ...faqs.map((faq) => Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(faq, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D2939))),
            iconColor: Colors.black87,
            collapsedIconColor: Colors.black87,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Detailed answer explaining the specifics of the query for the user\'s understanding.', style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildReviewerInfo() {
    return Container(
      color: const Color(0xFFF2F4F7).withOpacity(0.5),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test Information is reviewed by: Dr. Swati Gupta (Anand), MBBS, MD Lab Medicine and written by Dr. Lipika Khurana, BDS, PGDHHM . The test details are for information purpose only. Consult a doctor before taking any test. Last updated on: 14th Apr 2026',
            style: TextStyle(color: Color(0xFF667085), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Did you find information useful ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.black87),
                label: const Text('YES (42)', style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_down_alt_outlined, size: 16, color: Colors.black87),
                label: const Text('NO (3)', style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeedHelp() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need help?',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
          ),
          const SizedBox(height: 16),
          _buildHelpRow(Icons.call_outlined, 'Call our health adviser to book', 'Our team of experts will guide you'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFFEAECF0), thickness: 1, height: 1),
          ),
          _buildHelpRow(Icons.chat_outlined, 'Chat with our 1mg expert', 'Tell us about your lab booking needs', iconColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildHelpRow(IconData icon, String title, String subtitle, {Color iconColor = const Color(0xFF2E90FA)}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildReferences() {
    return Container(
      color: const Color(0xFFF9FAFB),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'References',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1.  ', style: TextStyle(color: Color(0xFF667085), fontSize: 13)),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Color(0xFF667085), fontSize: 13, height: 1.4, fontFamily: 'Inter'),
                    children: [
                      TextSpan(text: 'Diabetes in India [Internet]. WHO; 5 Apr. 2023 [Accessed 18 Sep. 2024]. Available from: '),
                      TextSpan(text: 'https://www.who.int/india/health-topics/mobile-technology-for-preventing-ncds', style: TextStyle(decoration: TextDecoration.underline)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('2.  ', style: TextStyle(color: Color(0xFF667085), fontSize: 13)),
              const Expanded(
                child: Text(
                  'Diabetes [Internet]. WHO; 5 Apr. 2023 [Accessed 18 Sep. 2024]. Available from: https://www.who.int/india/health-topics/mobile-technology-for-preventing-ncds',
                  style: TextStyle(color: Color(0xFF667085), fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Package price:', style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
                  Row(
                    children: [
                      Text('₹${widget.currentPrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
                      const SizedBox(width: 8),
                      Text('₹${widget.originalPrice.toInt()}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14, decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 4),
                      Text(widget.discountPercentage, style: const TextStyle(color: Color(0xFF039855), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 140,
              height: 48,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5247),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('BOOK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
