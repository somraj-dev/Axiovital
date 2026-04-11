import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'product_details_page.dart';
import 'cart_page.dart';

class Product {
  final String id;
  final String name;
  final String quantity;
  final double rating;
  final int ratingCount;
  final String deliveryDate;
  final double currentPrice;
  final double originalPrice;
  final int discount;
  final String imagePath;
  final String specialOffer;

  const Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.rating,
    required this.ratingCount,
    required this.deliveryDate,
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
    required this.imagePath,
    required this.specialOffer,
  });
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedSubCategory = 'Top Picks';

  final List<String> subCategories = [
    'Top Picks',
    'Omega & Fish Oil & DHA',
    'Multivitamins & Minerals',
    'Hair & Skin Supplements',
    'Calcium',
    'Magnesium',
  ];

  final List<Product> products = [
    const Product(
      id: 'limcee_vinc',
      name: 'Limcee Vitamin C Chewable Tablet | Fla...',
      quantity: '15 Chewable Tablets',
      rating: 4.5,
      ratingCount: 17808,
      deliveryDate: 'Tue, 7 Apr',
      currentPrice: 20.7,
      originalPrice: 24.7,
      discount: 7,
      imagePath: 'assets/images/limcee.png',
      specialOffer: '₹20.7 order for ₹1200',
    ),
    const Product(
      id: 'neurobion_forte',
      name: 'Neurobion Forte Tablet with Vitamin B12 | He...',
      quantity: '30 tablets',
      rating: 4.5,
      ratingCount: 17787,
      deliveryDate: 'Tue, 7 Apr',
      currentPrice: 41.2,
      originalPrice: 47.5,
      discount: 4,
      imagePath: 'assets/images/neurobion.png',
      specialOffer: '₹41.2 order for ₹1200',
    ),
  ];

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
        title: const Text(
          'Vitamins & Nutrition',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black87), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  }),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) => cart.itemCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Sort', Icons.swap_vert),
                const SizedBox(width: 12),
                _buildFilterChip('All filters', Icons.tune),
              ],
            ),
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    border: Border(right: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: ListView.builder(
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final title = subCategories[index];
                      final isSelected = selectedSubCategory == title;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSubCategory = title),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            border: isSelected
                                ? const Border(left: BorderSide(color: Color(0xFF8B1A4B), width: 4))
                                : null,
                          ),
                          child: Column(
                            children: [
                              if (index == 0)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.purple.shade200, Colors.purple.shade400],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.star, color: Colors.white, size: 24),
                                )
                              else if (title.contains('Omega'))
                                Image.asset('assets/images/limcee.png', height: 40) // Placeholder for Omega
                              else
                                const Icon(Icons.medication_liquid, color: Colors.blueGrey, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.black87 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Main Product List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Promo Banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/complan_ad.png', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 24),

                      // Products
                      ...products.map((product) => _buildProductCard(context, product)).toList(),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Promotion Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFF8B1A4B)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Apply coupon to get ',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'EXTRA 15% OFF',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const Text(
                  ' on medicines',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(width: 4),
          Icon(icon, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: Image.asset(product.imagePath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(product.quantity, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF039855), borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Text('${product.rating}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 2),
                              const Icon(Icons.star, color: Colors.white, size: 10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${product.ratingCount} ratings', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Get by ${product.deliveryDate}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('₹${product.currentPrice}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                        const SizedBox(width: 6),
                        Text('₹${product.originalPrice}', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13)),
                        const SizedBox(width: 6),
                        Text('${product.discount}% off', style: const TextStyle(color: Color(0xFF039855), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFDE8E3), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        product.specialOffer,
                        style: const TextStyle(color: Color(0xFF8B1A4B), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // ADD Button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addItem(
                      productId: product.id,
                      name: product.name,
                      price: product.currentPrice,
                      imagePath: product.imagePath,
                      type: CartItemType.essential,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE05A47)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('ADD', style: TextStyle(color: Color(0xFFE05A47), fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          
          const Divider(height: 32),
        ],
      ),
    );
  }
}
