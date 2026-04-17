import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'theme.dart';
import 'coupons_page.dart';
import 'new_address_page.dart';
import 'checkout_sheets.dart';
import 'payment_options_page.dart';
import 'search_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();

  // Mock data for frequently booked together
  final List<Map<String, dynamic>> _recommendations = [
    {
      'id': 'rec1',
      'name': 'CBC (Complete Blood Count)',
      'subtitle': 'Test • Contains 21 tests',
      'timing': 'Report by 27 hours',
      'price': 264.0,
      'oldPrice': 350.0,
      'discount': '24% off',
    },
    {
      'id': 'rec2',
      'name': 'Urine Culture & Sensitivity',
      'subtitle': 'Test • Contains 1 test',
      'timing': 'Report by 48 hours',
      'price': 749.0,
      'oldPrice': 850.0,
      'discount': '12% off',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Remove auto-add logic as requested


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: cartProvider.items.isEmpty
                  ? _buildEmptyState(context)
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSavingsBanner(cartProvider.totalSavings),
                              
                              // Appointments Section
                              if (cartProvider.appointments.isNotEmpty) ...[
                                _buildSectionHeader('Appointments'),
                                ...cartProvider.appointments
                                    .map((item) => _buildCartItemCard(item, cartProvider))
                                    .toList(),
                                const Divider(height: 32, thickness: 1, color: Color(0xFFF2F4F7)),
                              ],

                              // Lab Tests Section
                              if (cartProvider.labTests.isNotEmpty) ...[
                                _buildSectionHeader('Test added'),
                                _buildFulfillmentHeader(context, 'AxioVital Labs'),
                                ...cartProvider.labTests
                                    .map((item) => _buildCartItemCard(item, cartProvider))
                                    .toList(),
                                _buildPreparationsGuide(context),
                                const Divider(height: 1, thickness: 8, color: Color(0xFFF2F4F7)),
                              ],

                              // Essentials Section
                              if (cartProvider.essentials.isNotEmpty) ...[
                                _buildSectionHeader('Essentials'),
                                ...cartProvider.essentials
                                    .map((item) => _buildCartItemCard(item, cartProvider))
                                    .toList(),
                                const Divider(height: 1, thickness: 8, color: Color(0xFFF2F4F7)),
                              ],

                              // Insurance Section
                              if (cartProvider.insuranceItems.isNotEmpty) ...[
                                _buildSectionHeader('Insurance Policy'),
                                _buildFulfillmentHeader(context, 'Axio Team'),
                                ...cartProvider.insuranceItems
                                    .map((item) => _buildInsuranceCartItem(item, cartProvider))
                                    .toList(),
                                const Divider(height: 1, thickness: 8, color: Color(0xFFF2F4F7)),
                              ],

                              // Memberships Section
                              if (cartProvider.subscriptions.isNotEmpty) ...[
                                _buildSectionHeader('Memberships'),
                                _buildFulfillmentHeader(context, 'AxioVital Team'),
                                ...cartProvider.subscriptions
                                    .map((item) => _buildSubscriptionCartItem(item, cartProvider))
                                    .toList(),
                                const Divider(height: 1, thickness: 8, color: Color(0xFFF2F4F7)),
                              ],

                              _buildFrequentlyBookedSection(context, cartProvider),
                              const Divider(height: 1, thickness: 8, color: Color(0xFFF2F4F7)),
                              _buildExploreCoupons(context, cartProvider),
                              const Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
                              _buildBillSummary(cartProvider),
                              const Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
                              _buildOtherDetails(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                        _buildStickyFooter(context, cartProvider),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_protected_setup, size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 40),
                      Icon(Icons.wifi_protected_setup, size: 16, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Your cart is empty',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1D2939),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'We have all the tests and packages that you need to book',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Find tests',
              style: TextStyle(
                color: Color(0xFFE11D48),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D2939)),
      ),
    );
  }

  Widget _buildFulfillmentHeader(BuildContext context, String labName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        children: [
          const Text('Fulfilled by ', style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
          Text(labName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D2939))),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showLabInfoPopup(context),
            child: Icon(Icons.info_outline, size: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _showLabInfoPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Know more about lab', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ]
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              // Image Banner
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade200,
                child: Image.network(
                  'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.local_hospital, size: 48, color: Colors.grey)),
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AxioVital Labs', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.black)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text('23,807 people booked from this lab recently', style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
                    ),
                    const Text('About this lab', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                    const SizedBox(height: 12),
                    Text(
                      'AxioVital Labs is a cutting-edge facility delivering top-quality diagnostic services right to your doorstep. We take pride in three core values: Assured Quality, Best Prices and Timely Reports. Transparency is at the heart of our operations, ensuring our customers always have clear and reliable information. Our dedicated team is committed to offering an exceptional customer experience and continually innovates to meet and exceed customer expectations.',
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.search, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBanner(double savings) {
    if (savings <= 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE7FDF0), Color(0xFFE0F2FE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text('₹${savings.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF039855), fontSize: 16)),
            const SizedBox(width: 8),
            const Text('saved on this order', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, CartProvider cartProvider) {
    bool isAppointment = item.type == CartItemType.appointment;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50, height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAppointment ? const Color(0xFFE9F5FB) : const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.type == CartItemType.appointment 
              ? const Icon(Icons.person, color: Color(0xFF2E90FA))
              : (item.imagePath.startsWith('http') 
                ? Image.network(item.imagePath, fit: BoxFit.contain)
                : Image.asset(item.imagePath, fit: BoxFit.contain)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D2939), height: 1.2)),
                const SizedBox(height: 4),
                if (item.timing.isNotEmpty)
                  Text('Get report in: ${item.timing}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11)),
                if (isAppointment)
                  const Text('In-clinic fee', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('₹${item.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                    const SizedBox(width: 6),
                    if (!isAppointment) ...[
                      Text('₹${(item.price * 1.7).toInt()}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12, decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 6),
                      const Text('41% off', style: TextStyle(color: Color(0xFF039855), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showPatientSelectionDialog(context, item, cartProvider),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAECF0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFE11D48))),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFFE11D48)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Patient(s)', style: TextStyle(color: Color(0xFF667085), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSubscriptionCartItem(CartItem item, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hot Deal Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('Hot Deal', style: TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Qty Column
              Column(
                children: [
                  Container(
                    width: 76, height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Icon(Icons.badge_outlined, color: Colors.white24, size: 28),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Qty: ${item.quantity}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D2939))),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Color(0xFF1D2939), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text('Instant Activation', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(4, (_) => const Icon(Icons.star, color: Color(0xFF16A34A), size: 14)),
                        const Icon(Icons.star_half, color: Color(0xFF16A34A), size: 14),
                        const SizedBox(width: 4),
                        const Text('4.8', style: TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Text('• (1,12,610)', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(width: 6),
                        Row(
                          children: const [
                            Icon(Icons.verified_user, color: Color(0xFF2E90FA), size: 14),
                            Text('Assured', style: TextStyle(color: Color(0xFF2E90FA), fontSize: 11, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Icon(Icons.arrow_downward, color: Color(0xFF16A34A), size: 16),
                        const Text('33%', style: TextStyle(color: Color(0xFF16A34A), fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        Text('₹${(item.price * 1.5).toInt()}', style: const TextStyle(color: Colors.black54, fontSize: 16, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        Text('₹${item.price.toInt()}', style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceCartItem(CartItem item, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fulfillment / Status Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF8FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: Color(0xFF175CD3), size: 14),
                const SizedBox(width: 4),
                const Text('Fulfilled by Axio Team', style: TextStyle(color: Color(0xFF175CD3), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D2939), Color(0xFF344054)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60, height: 40,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(item.imagePath, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            item.subtitle,
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Coverage Status', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF12B76A), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Active Proposal', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Premium', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        const SizedBox(height: 2),
                        Text(
                          '₹${item.price.toInt()}',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => cartProvider.updateQuantity(item.id, 0),
                icon: const Icon(Icons.delete_outline, color: Color(0xFF667085), size: 18),
                label: const Text('Remove from cart', style: TextStyle(color: Color(0xFF667085), fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPatientSelectionDialog(BuildContext context, CartItem item, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const SizedBox(width: 24),
                   const Text('Select your number of patients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   GestureDetector(
                     onTap: () => Navigator.pop(context),
                     child: const Icon(Icons.close, color: Colors.black54),
                   ),
                ],
              ),
              const SizedBox(height: 24),
              ...List.generate(5, (index) {
                int count = index + 1;
                bool isSelected = item.quantity == count;
                return GestureDetector(
                  onTap: () {
                    cartProvider.updateQuantity(item.id, count);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF1F2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$count', style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Color(0xFFFF5247))
                        else
                          const Icon(Icons.circle_outlined, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Divider(),
              TextButton.icon(
                onPressed: () {
                  cartProvider.updateQuantity(item.id, 0);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                label: const Text('Remove', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreparationsGuide(BuildContext context) {
    return InkWell(
      onTap: () => _showPreparationsBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: const [
            Text('Preparations guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1570EF))),
            Spacer(),
            Icon(Icons.chevron_right, size: 20, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequentlyBookedSection(BuildContext context, CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Frequently booked together', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D2939))),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final rec = _recommendations[index];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFEAECF0)), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(rec['subtitle'], style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12)),
                    Text(rec['timing'], style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12)),
                    const Spacer(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('₹${rec['price'].toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(width: 4),
                                Text('₹${rec['oldPrice'].toInt()}', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11, decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            Text(rec['discount'], style: const TextStyle(color: Color(0xFF039855), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () {
                              cartProvider.addItem(
                                productId: rec['id'], 
                                name: rec['name'], 
                                price: rec['price'], 
                                imagePath: 'https://cdn-icons-png.flaticon.com/512/3063/3063822.png',
                                type: CartItemType.labTest,
                                timing: rec['timing'],
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEAECF0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: const Text('Add', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildExploreCoupons(BuildContext context, CartProvider cartProvider) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponsPage())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFE7FDF0), shape: BoxShape.circle),
              child: const Icon(Icons.percent, color: Color(0xFF039855), size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Explore coupons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939))),
                if (cartProvider.appliedCoupon != null)
                  Text('Code ${cartProvider.appliedCoupon} applied', style: const TextStyle(color: Color(0xFF039855), fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFFF5247)),
          ],
        ),
      ),
    );
  }

  Widget _buildNeuCoinsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)]), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('My Trackcoins', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1D2939))),
                      SizedBox(height: 4),
                      Text('1 Trackcoin = ₹1', style: TextStyle(color: Color(0xFF667085), fontSize: 14)),
                    ],
                  ),
                ),
                Container(
                   padding: const EdgeInsets.all(4),
                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                   child: const Icon(Icons.smartphone, size: 40, color: Color(0xFF4C1D95)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('0.12 Trackcoins to be earned on this order*', style: TextStyle(color: Color(0xFF039855), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBillSummary(CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bill summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          _buildBillRow('Item total (MRP)', '₹${cartProvider.totalMRP.toInt()}'),
          const SizedBox(height: 12),
          _buildBillRow('Price discount', '-₹${(cartProvider.totalMRP - cartProvider.totalAmount - cartProvider.couponDiscountAmount).toInt()}', isDiscount: true),
          if (cartProvider.couponDiscountAmount > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow('Coupon discount', '-₹${cartProvider.couponDiscountAmount.toInt()}', isDiscount: true),
          ],
          const Divider(height: 32, thickness: 1, color: Color(0xFFF2F4F7)),
          _buildBillRow('Total amount', '₹${cartProvider.totalAmount.toInt()}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, color: isDiscount ? const Color(0xFF039855) : const Color(0xFF1D2939))),
        Text(value, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: FontWeight.bold, color: isDiscount ? const Color(0xFF039855) : const Color(0xFF1D2939))),
      ],
    );
  }

  Widget _buildOtherDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Other details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1D2939))),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Color(0xFF667085), fontSize: 12, height: 1.5),
              children: [
                TextSpan(text: 'AxioVital is a technology platform to facilitate transaction of business for pathology and radiology tests through various diagnostic lab service providers. For details, read '),
                TextSpan(text: 'terms and conditions', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context, CartProvider cartProvider) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFFFF1F2), shape: BoxShape.circle), child: const Icon(Icons.location_on, color: Color(0xFFE11D48), size: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sample collection from', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D2939))),
                      Text(cartProvider.fullAddress ?? cartProvider.address, style: const TextStyle(color: Color(0xFF667085), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewAddressPage())),
                  child: const Text('Add Address', style: TextStyle(color: Color(0xFFFF5247), fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${cartProvider.totalAmount.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black)),
                    GestureDetector(
                      onTap: () => _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                      child: const Text('See bill summary', style: TextStyle(color: Color(0xFFFF5247), fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 180, height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Check if any item in the cart requires patient and slot selection
                      bool requiresPatientOrSlot = cartProvider.items.values.any(
                        (item) => item.type == CartItemType.labTest || item.type == CartItemType.appointment
                      );
                      
                      if (!requiresPatientOrSlot) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentOptionsPage()));
                      } else {
                        CheckoutFlow.start(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5247), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Expanded(child: Container(height: 48, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: const TextField(decoration: InputDecoration(hintText: 'Search added tests or cart orders', prefixIcon: Icon(Icons.search), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12))))),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ]),
          ),
          const Expanded(child: Center(child: Text('Search results will appear here'))),
        ]),
      ),
    );
  }

  void _showPreparationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController, padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Preparation guide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
              const SizedBox(height: 24),
              const Text('General Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              const Text('• Fasting is not required for this test.\n• Maintain normal diet and fluid intake.\n• Morning sample is preferred but not mandatory.'),
              const SizedBox(height: 24),
              const Text('Selected Test Specimen:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              const Text('Urine Routine & Microscopy requires a clean catch urine sample.'),
            ],
          ),
        ),
      ),
    );
  }
}
