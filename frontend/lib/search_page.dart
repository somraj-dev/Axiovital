import 'package:flutter/material.dart';
import 'health_assistant_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Search Bar & Promo Banner
                  _buildHeader(context),
                  
                  const SizedBox(height: 16),
                  
                  // Prescription Card
                  _buildPrescriptionCard(),
                  
                  const SizedBox(height: 24),
                  
                  // "In the spotlight" Section
                  _buildSpotlightSection(),
                  
                  const SizedBox(height: 100), // Space for floating footer
                ],
              ),
            ),
          ),
          
          // Floating Footer
          _buildFloatingFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Search Input
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search medicines & health products',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Deep Pink/Purple Promo Banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8E3E63), Color(0xFFA84478)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: Text(
              'EXTRA 15% OFF on medicines with coupon',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE4E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_outlined, color: Color(0xFFD42620), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Have a prescription? Order quickly!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF101828)),
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFD42620)),
        ],
      ),
    );
  }

  Widget _buildSpotlightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'In the spotlight',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Ad', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              _buildProductCard(
                'Prohance Mom\nNutritional Drink for...',
                '400 gm Powder',
                '4.5',
                '₹471',
                '₹523',
                '₹630',
                '17%',
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _buildProductCard(
                'Minimalist SPF 50\nPA++++ Sunscreen...',
                '50 gm Cream',
                '4.2',
                '₹341',
                '₹379',
                '₹399',
                '5%',
                Colors.green,
                status: 'Bestseller+',
              ),
              const SizedBox(width: 16),
              _buildProductCard(
                'Organic Liver\nCare Capsules...',
                '60 caps',
                '4.3',
                '₹200',
                '₹222',
                '₹280',
                '22%',
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    String name, 
    String qty, 
    String rating, 
    String specialPrice, 
    String currentPrice, 
    String oldPrice, 
    String discount, 
    Color brandColor,
    {String? status}
  ) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area with Rating
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Icon(Icons.medical_services_outlined, size: 60, color: Colors.grey.shade300),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2939).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.white, size: 12),
                    ],
                  ),
                ),
              ),
              if (status != null)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Color(0xFFB42318), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(qty, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 8),
                Text('Get by Wed, 8 Apr', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(currentPrice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$discount off',
                  style: const TextStyle(color: Color(0xFF12B76A), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA84478).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$specialPrice order for ₹1200',
                      style: const TextStyle(color: Color(0xFFA84478), fontSize: 11, fontWeight: FontWeight.bold),
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

  Widget _buildFloatingFooter(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 40,
      right: 40,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // White Capsule
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFooterItem(Icons.lightbulb_outline, 'Insights'),
                const SizedBox(width: 60), // Space for center button
                _buildFooterItem(Icons.person_outline, 'Profile'),
              ],
            ),
          ),
          
          // "Ask me" Central Button (Overlapping)
          Positioned(
            top: -25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HealthAssistantPage()),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF4B89FF), Color(0xFF1570EF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4B89FF).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.filter_vintage, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ask me',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF344054)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF344054), size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF344054)),
        ),
      ],
    );
  }
}
