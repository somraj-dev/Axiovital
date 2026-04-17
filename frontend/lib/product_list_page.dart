import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';
import 'widgets/product/premium_product_card.dart';
import 'search_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(context),
          _buildStickyCategoryBar(productProvider),
          _buildProductGrid(productProvider),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildStickyDiscountBanner(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 140,
      backgroundColor: const Color(0xFFF9FAFF),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
        }),
        _buildCartBadge(context),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF0FDF4), Color(0xFFF9FAFF)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Vitamins & Nutrition',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2939),
                ),
              ),
              Text(
                'Premium essentials for your daily wellness',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartBadge(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Consumer<CartProvider>(
            builder: (context, cart, _) => cart.itemCount > 0
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFF04438), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCategoryBar(ProductProvider provider) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        Container(
          color: Colors.white,
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              final isSelected = provider.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => provider.selectCategory(cat),
                  selectedColor: const Color(0xFFF0FDF4),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF039855) : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: isSelected ? const Color(0xFF12B76A) : Colors.grey[200]!),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider provider) {
    if (provider.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: Color(0xFF0052CC))),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PremiumProductCard(product: provider.products[index]);
          },
          childCount: provider.products.length,
        ),
      ),
    );
  }

  Widget _buildStickyDiscountBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF8B1A4B),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 13),
              children: [
                TextSpan(text: 'USE CODE '),
                TextSpan(text: 'AXIOVIT20', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' FOR '),
                TextSpan(text: '20% OFF', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFEC84B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._widget);

  final Widget _widget;

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

