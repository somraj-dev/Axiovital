import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class CarePlanPage extends StatefulWidget {
  const CarePlanPage({super.key});

  @override
  State<CarePlanPage> createState() => _CarePlanPageState();
}

class _CarePlanPageState extends State<CarePlanPage> {
  // Plan State: true for 3 months, false for 6 months
  bool is3MonthsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F1), // Gentle background tint at top
      body: Stack(
        children: [
          // Background Gradient (Matches top part)
          Positioned(
            top: 0, left: 0, right: 0, height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.6),
                  radius: 1.0,
                  colors: [
                    const Color(0xFFFBE4D3).withOpacity(0.6),
                    const Color(0xFFFBF8F1).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Body
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 220), // Leave space for sticky footer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  
                  // Wrap rest in white container
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMembershipBenefits(),
                        _buildAdditionalBenefits(),
                        _buildTestimonials(),
                        _buildFAQs(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                  ),
                ),
              ],
            ),
          ),
          
          // 3D Gold Heart Icon (Approximation)
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/10473/10473461.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.health_and_safety,
              size: 80,
              color: Color(0xFFE5B96E),
            ),
          ),
          const SizedBox(height: 16),
          
          // Title Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF90323D), // Deep red/brown
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Care Plan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          
          // Hero Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Increase your savings with exclusive benefits.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFBA935D), // Gold-ish text
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Color(0xFF7B2A33), // Deep reddish brown
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: const Color(0xFFE5D5C5))),
        ],
      ),
    );
  }

  Widget _buildMembershipBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading('MEMBERSHIP BENEFITS'),
        _buildBenefitItem(Icons.percent, 'Extra 4% discount', 'on all applicable products'),
        _buildBenefitItem(Icons.local_shipping_outlined, 'Free delivery', 'on orders above ₹249'),
        _buildBenefitItem(Icons.medical_services_outlined, 'Free Doctor consultation', 'chat with premium doctors 24x7'),
        _buildBenefitItem(Icons.science_outlined, 'Upto ₹500 off on popular lab tests', 'on selected tests'),
      ],
    );
  }

  Widget _buildAdditionalBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildBenefitItem(Icons.support_agent, 'VIP support', 'Get your queries resolved on priority'),
        _buildBenefitItem(Icons.shopping_cart_outlined, 'Early sale access', 'Be among the first to shop during sale'),
        _buildBenefitItem(Icons.local_offer_outlined, 'Exclusive Wellness Offers', 'from top healthcare and lifestyle brands'),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF2E6), // Light beige
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF907044), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading('WHAT MEMBERS SAY'),
        SizedBox(
          height: 160,
          child: ListView(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _buildTestimonialCard(
                'There is a good discount for a new customer. even in low price for existing customer. The best thing is...',
                'Piyush Patel',
                'Gurugram, India',
                'P',
              ),
              _buildTestimonialCard(
                'Serving their Customers wholeheartedly. Quick delivery of medicines and seamless process.',
                'Jyoti Sharma',
                'Mumbai, India',
                'J',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTestimonialCard(String text, String name, String location, String initial) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
          const Spacer(),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFD0A56E),
                child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(location, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFAQs() {
    final faqs = [
      "How do I avail discount on medicines?",
      "Terms & conditions around Free Shipping",
      "My Care Plan is a one-time membership fee or do I have to pay extra?",
      "Can I cancel my subscription plan?",
      "Is the membership fee final?",
      "Is my order eligible for rapid delivery with this Care Plan membership?",
      "Termination & Misuse of Membership",
      "Is there a maximum limit on the discounts?",
      "What are NeuCoins? When will they be credited and how can I use them?",
      "What benefits will I get with Exclusive Coupons?",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading('FAQS'),
        ...faqs.map((q) => _buildFAQItem(q)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFAQItem(String question) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          question,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 20),
        ),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text('This is a placeholder answer. Expand actual FAQ descriptions here.', style: TextStyle(color: Colors.black54)),
          )
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Radio Cards
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Expanded(child: _buildPlanCard(true)),
                const SizedBox(width: 12),
                Expanded(child: _buildPlanCard(false)),
              ],
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => _handleJoinCarePlan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5247), // UI Red
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Join Care Plan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      is3MonthsSelected ? 'for 3 months at ₹165' : 'for 6 months at ₹275',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(bool is3Months) {
    bool isSelected = (is3Months == is3MonthsSelected);
    
    // Values
    String tag = is3Months ? 'Most Popular' : '20% Cheaper';
    Color tagColor = is3Months ? const Color(0xFFD0D5DD) : const Color(0xFF2E7D32); // Grey vs Green
    Color tagTextColor = is3Months ? const Color(0xFF475467) : Colors.white;
    String duration = is3Months ? '3 months' : '6 months';
    String price = is3Months ? '₹165' : '₹275';
    String subtext = is3Months ? '(₹55/month)' : '(₹46/month)';

    return GestureDetector(
      onTap: () {
        setState(() {
          is3MonthsSelected = is3Months;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.black38 : const Color(0xFFEAECF0), width: isSelected ? 1.5 : 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Tag Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Text(
                tag,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: tagTextColor),
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(duration, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      // Radio icon
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? const Color(0xFFFF5247) : Colors.grey.shade400,
                        size: 20,
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                      const SizedBox(width: 4),
                      Text(subtext, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleJoinCarePlan(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Dynamic details based on selection
    final String planId = is3MonthsSelected ? 'care_plan_3m' : 'care_plan_6m';
    final String planName = is3MonthsSelected ? 'Care Plan - 3 Months' : 'Care Plan - 6 Months';
    final double planPrice = is3MonthsSelected ? 165.0 : 275.0;

    cartProvider.addItem(
      productId: planId,
      name: planName,
      price: planPrice,
      imagePath: 'https://cdn-icons-png.flaticon.com/512/3596/3596091.png', 
      type: CartItemType.subscription,
      subtitle: 'Extra 4% off + Free Shipping',
      timing: 'Active instantly',
    );

    // Show toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Care Plan added to cart!'),
        backgroundColor: Color(0xFF039855),
        duration: Duration(seconds: 2),
      )
    );

    // Redirect to Cart Options
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }
}
