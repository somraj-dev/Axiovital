import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../product_provider.dart';
import '../../cart_provider.dart';
import '../../product_details_page.dart';

class PremiumProductCard extends StatelessWidget {
  final Product product;

  const PremiumProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFF9FAFB),
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/3063/3063822.png', // Placeholder 
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, __) => const Icon(Icons.medication, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              
              // Info Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2939),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.quantity,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${product.currentPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D2939),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₹${product.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Best Seller Badge
          if (product.isBestSeller)
            Positioned(
              top: 12,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFAEB),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFF79009), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'BEST SELLER',
                      style: TextStyle(
                        color: Color(0xFFB54708),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // Rating Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    product.rating.toString(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.star, color: Colors.amber, size: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
