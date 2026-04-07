import 'package:flutter/material.dart';
import 'health_assistant_page.dart';
import 'widgets/axio_card.dart';
import 'widgets/axio_button.dart';
import 'theme.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderBanner(context),
                  const SizedBox(height: 16),
                  _buildPrescriptionCard(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context),
                  const SizedBox(height: 16),
                  _buildProductHorizontalList(context),
                ],
              ),
            ),
          ),
          _buildFloatingFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF903050), // Consistent medical maroon
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5), width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Search medicines & health products',
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 13, color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'EXTRA 15% OFF ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'on medicines with coupon',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AxioCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        showShadow: false,
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: theme.primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Have a prescription? Order quickly!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'In the spotlight',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('Ad', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHorizontalList(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildProductCard(
            context,
            imageUrl: 'https://m.media-amazon.com/images/I/61KpxBfokKL.jpg',
            rating: '4.5',
            isBestseller: false,
            title: 'Prohance Mom Nutritional Drink for...',
            volume: '400 gm Powder',
            deliveryTime: 'Get by Wed, 8 Apr',
            price: '₹523',
            oldPrice: '₹630',
            discount: '17% off',
            tagPrice: '₹471',
          ),
          const SizedBox(width: 12),
          _buildProductCard(
            context,
            imageUrl: 'https://m.media-amazon.com/images/I/41-qX36sN0L.jpg',
            rating: '4.2',
            isBestseller: true,
            title: 'Minimalist SPF 50 PA++++ Sunscreen ...',
            volume: '50 gm Cream',
            deliveryTime: 'Get by Wed, 8 Apr',
            price: '₹379',
            oldPrice: '₹399',
            discount: '5% off',
            tagPrice: '₹341',
          ),
          const SizedBox(width: 12),
          _buildProductCard(
            context,
            imageUrl: 'https://m.media-amazon.com/images/I/71uK5JbWeAL.jpg',
            rating: '4.3',
            isBestseller: false,
            title: 'Organic India Liver-Kidney Care...',
            volume: '60 capsules',
            deliveryTime: 'Get by Wed, 8 Apr',
            price: '₹222',
            oldPrice: '₹285',
            discount: '22% off',
            tagPrice: '₹200',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required String imageUrl,
    required String rating,
    required bool isBestseller,
    required String title,
    required String volume,
    required String deliveryTime,
    required String price,
    required String oldPrice,
    required String discount,
    required String tagPrice,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                width: 160,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? const Color(0xFFF9FAFB) : theme.colorScheme.surfaceContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => Icon(Icons.image, color: theme.dividerColor)),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(rating, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, color: Colors.white, size: 10),
                        ],
                      ),
                    ),
                    if (isBestseller) ...[
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.light ? const Color(0xFFFFF7ED) : Colors.white10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bestseller', 
                          style: TextStyle(
                            color: theme.brightness == Brightness.light ? const Color(0xFFC2410C) : Colors.orangeAccent, 
                            fontSize: 10, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface, height: 1.2),
                  ),
                  Text(volume, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                  Text(deliveryTime, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(price, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                          const SizedBox(width: 4),
                          Text(oldPrice, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.3), decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      Text(discount, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.successColor)),
                    ],
                  ),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF903050),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$tagPrice order for ₹1200',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insights_outlined, color: theme.colorScheme.onSurface, size: 26),
                const SizedBox(height: 4),
                Text('Insights', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14)),
              ],
            ),
            
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthAssistantPage()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [AppTheme.primaryColor, Color(0xFF903050)],
                        center: Alignment.center,
                        radius: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Ask me', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.onSurface.withOpacity(0.6), size: 28),
                const SizedBox(height: 4),
                Text('Profile', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
