import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'product_list_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Pulse animation for ADD button
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Entrance animation controller for staggered reveals
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildUltraSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _staggeredReveal(0, _buildProductHeader()),
                    _staggeredReveal(1, _buildDeliveryInfo()),
                    _staggeredReveal(2, _buildPricingAndCoupons()),
                    _staggeredReveal(3, _buildMembershipBanner()),
                    _staggeredReveal(4, _buildOffersSection()),
                    _staggeredReveal(5, _buildUpsellBanner()),
                    _staggeredReveal(6, _buildTabSection()),
                    const SizedBox(height: 8),
                    _staggeredReveal(7, _buildDetailedRatings()),
                    const SizedBox(height: 8),
                    _staggeredReveal(8, _buildPetCareAd()),
                    const SizedBox(height: 8),
                    _staggeredReveal(9, _buildFrequentlyBoughtTogether()),
                    const SizedBox(height: 8),
                    _staggeredReveal(10, _buildTrustIconsRow()),
                    const SizedBox(height: 8),
                    _staggeredReveal(11, _buildVendorDetails()),
                    const SizedBox(height: 160), 
                  ],
                ),
              ),
            ],
          ),
          
          // Ultra-Premium Sticky Bottom UI
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildUltraStickyFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _staggeredReveal(int index, Widget child) {
    final start = index * 0.1;
    final end = start + 0.4;
    
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOutQuart),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildUltraSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 440.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search_rounded, color: Colors.black87), onPressed: () {}),
        IconButton(icon: const Icon(Icons.share_rounded, color: Colors.black87), onPressed: () {}),
        _buildCartBadge(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double offset = 0.0;
            if (_scrollController.hasClients) {
              offset = _scrollController.offset;
            }
            // Parallax scale and translation
            double scale = (1.0 - (offset / 1000.0)).clamp(0.8, 1.5);
            double translation = offset * 0.4;

            return Container(
              color: Colors.white,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Minimal mesh gradient background for content depth
                  Positioned(
                    top: -100 + (offset * 0.2),
                    right: -50,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [const Color(0xFFFDE8E3).withOpacity(0.4), Colors.white],
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Transform.translate(
                      offset: Offset(0, translation),
                      child: Transform.scale(
                        scale: scale,
                        child: PageView(
                          onPageChanged: (index) => setState(() => _currentImageIndex = index),
                          children: [
                            _buildHeroImage(widget.product.imagePath),
                            _buildHeroImage(widget.product.imagePath),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: _buildGeometricIndicator(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroImage(String path) {
    return Center(
      child: Hero(
        tag: 'product_image_${widget.product.id}',
        child: Image.asset(path, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildGeometricIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        bool active = _currentImageIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active ? const Color(0xFF8B1A4B) : Colors.grey.shade300,
            boxShadow: active ? [BoxShadow(color: const Color(0xFF8B1A4B).withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
        );
      }),
    );
  }

  Widget _buildCartBadge() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87), onPressed: () {}),
          Positioned(
            right: 8,
            top: 10,
            child: Consumer<CartProvider>(
              builder: (context, cart, child) => cart.itemCount > 0
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Color(0xFFE05A47), shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: Color(0xFF1D2939), letterSpacing: -0.8),
          ),
          const SizedBox(height: 20),
          _buildPremiumTag('Official Abbott Partner', Icons.verified_rounded, Colors.blue),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureIcon(Icons.star_rounded, '4.5 Rating', Colors.orange),
              _buildFeatureIcon(Icons.shield_rounded, 'Clinical Safe', Colors.green),
              _buildFeatureIcon(Icons.trending_up_rounded, 'Top Choice', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTag(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.2)),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475467))),
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Express Delivery by Tomorrow, 11 AM',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1D2939), fontSize: 13),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildPricingAndCoupons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('₹${widget.product.currentPrice}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 42, letterSpacing: -1.5)),
              const SizedBox(width: 12),
              Text('₹${widget.product.originalPrice}', style: const TextStyle(color: Color(0xFF98A2B3), decoration: TextDecoration.lineThrough, fontSize: 20)),
              const Spacer(),
              _buildGlassBadge('${widget.product.discount}% OFF'),
            ],
          ),
          const SizedBox(height: 24),
          _buildUltraCouponCard('FLAT ₹50 OFF', 'On your first health purchase', 'WELCOME50'),
        ],
      ),
    );
  }

  Widget _buildGlassBadge(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFD1FADF).withOpacity(0.8), border: Border.all(color: Colors.green.withOpacity(0.2))),
          child: Text(label, style: const TextStyle(color: Color(0xFF039855), fontWeight: FontWeight.w900, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildUltraCouponCard(String title, String subtitle, String code) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF8B1A4B).withOpacity(0.05), const Color(0xFFFDF2F9)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF9DCF0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF8B1A4B), fontSize: 18)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF8B1A4B), fontSize: 12, opacity: 0.7)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF9DCF0))),
          child: Text(code, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF8B1A4B))),
        ),
      ),
    );
  }

  Widget _buildMembershipBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFFFEDF89).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
        gradient: const LinearGradient(
          colors: [Color(0xFF8B1A4B), Color(0xFF631235)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Care Plan Prime', style: TextStyle(color: Color(0xFFFEDF89), fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
                SizedBox(height: 8),
                Text('Unlock 20% Extra Benefits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('FREE delivery on all orders', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEDF89),
              foregroundColor: const Color(0xFF8B1A4B),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('JOIN NOW', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return _meshBackgroundSection(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Exclusive Wallet Offers', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF1D2939))),
          const SizedBox(height: 12),
          _buildPaymentRow(Icons.account_balance_rounded, 'SBI Cards', 'Up to ₹500 Instant Discount'),
          _buildPaymentRow(Icons.wallet_rounded, 'Paytm Wallet', 'Assured ₹50 Cashback'),
        ],
      ),
    );
  }

  Widget _meshBackgroundSection({required Widget child, required EdgeInsets padding}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        gradient: LinearGradient(
          colors: [const Color(0xFFF9FAFB), Colors.white.withOpacity(0.8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }

  Widget _buildPaymentRow(IconData icon, String title, String offer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, radius: 24, child: Icon(icon, color: Colors.blue, size: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(offer, style: const TextStyle(color: Color(0xFF039855), fontWeight: FontWeight.w700, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildUpsellBanner() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset('assets/images/complan_ad.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF8B1A4B),
          unselectedLabelColor: const Color(0xFF98A2B3),
          indicatorColor: const Color(0xFF8B1A4B),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          tabs: const [Tab(text: 'Product Details'), Tab(text: 'User Reviews')],
        ),
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Experience clinical-grade wellness with Limcee. Our chewable tablets are formulated for rapid absorption, supporting your immunity throughout the day. Trusted by millions for daily vitamin C excellence.',
            style: TextStyle(color: Color(0xFF475457), height: 1.7, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedRatings() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Consensus', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('4.5', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: -3)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, color: i < 4 ? Colors.green : Colors.grey.shade300, size: 24))),
                  const Text('Based on 17.8K verified buyers', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...List.generate(5, (i) => _buildUltraRatingBar(5 - i, [0.75, 0.17, 0.03, 0.01, 0.04][i])),
        ],
      ),
    );
  }

  Widget _buildUltraRatingBar(int star, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$star', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: const Color(0xFFF2F4F7),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.withOpacity(0.8)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPetCareAd() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/pet_care_ad.png', fit: BoxFit.cover)),
    );
  }

  Widget _buildFrequentlyBoughtTogether() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFFDF2F9).withOpacity(0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Bundle', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          const SizedBox(height: 24),
          _bundleRow(widget.product.name, widget.product.imagePath, '₹23'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Center(child: Icon(Icons.add_rounded, color: Color(0xFF8B1A4B)))),
          _bundleRow('Derma Co AHA+BHA Solution', 'assets/images/derma_co.png', '₹509'),
          const SizedBox(height: 32),
          _buildTotalBundleCard('₹532'),
        ],
      ),
    );
  }

  Widget _bundleRow(String name, String img, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF9DCF0))),
      child: Row(
        children: [
          Image.asset(img, width: 44, height: 44),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTotalBundleCard(String total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF8B1A4B), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('BUNDLE PRICE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            Text(total, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          ]),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF8B1A4B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('ADD BOTH', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIconsRow() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _trustItem(Icons.verified_user_rounded, 'GENUINE'),
          _trustItem(Icons.eco_rounded, 'NATURAL'),
          _trustItem(Icons.health_and_safety_rounded, 'SECURE'),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF8B1A4B), size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1, color: Color(0xFF475467))),
      ],
    );
  }

  Widget _buildVendorDetails() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compliance & Manufacturing', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 16),
          _specRow('Licensed By', 'Abbott India Ltd.'),
          _specRow('Origin', 'Maharashtra, India'),
          _specRow('Certifications', 'GMP, ISO 9001'),
        ],
      ),
    );
  }

  Widget _specRow(String l, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildUltraStickyFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDynamicProgressArea(),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 40, offset: const Offset(0, -10))],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
                  Text('₹${widget.product.currentPrice}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: -1.5)),
                ],
              ),
              const Spacer(),
              ScaleTransition(
                scale: _pulseAnimation,
                child: SizedBox(
                  width: 180,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        widget.product.id, widget.product.name, widget.product.currentPrice, widget.product.imagePath
                      );
                      Feedback.forTap(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4B3A),
                      elevation: 20,
                      shadowColor: const Color(0xFFFF4B3A).withOpacity(0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('ADD TO CART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicProgressArea() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        const double threshold = 1200.0;
        final double progress = (cart.totalAmount / threshold).clamp(0.0, 1.0);
        final bool isUnlocked = progress >= 1.0;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isUnlocked ? [const Color(0xFF039855), const Color(0xFF027A48)] : [const Color(0xFF8B1A4B), const Color(0xFF631235)],
            ),
          ),
          child: Row(
            children: [
              Icon(isUnlocked ? Icons.verified_rounded : Icons.local_shipping_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isUnlocked ? 'YAY! FREE DELIVERY UNLOCKED' : 'Add ₹${(threshold - cart.totalAmount).toInt()} for FREE Delivery',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                ),
              ),
              const Icon(Icons.arrow_upward_rounded, color: Colors.white70, size: 16),
            ],
          ),
        );
      },
    );
  }
}
