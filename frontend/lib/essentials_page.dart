import 'package:flutter/material.dart';
import 'product_list_page.dart';

class EssentialsPage extends StatelessWidget {
  const EssentialsPage({super.key});

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
        title: _buildSearchBar(),
        titleSpacing: 0,
        actions: const [SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Popular categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1D2939),
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Grid of Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 135,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(categories[index]);
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: const TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search for',
          hintStyle: TextStyle(color: Color(0xFF667085), fontSize: 16),
          suffixIcon: Icon(Icons.search, color: Color(0xFF1D2939), size: 28),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(_CategoryData category) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 85,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF4F1), // Soft peach from screenshot
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: category.imagePath != null
                        ? Image.asset(category.imagePath!, fit: BoxFit.contain)
                        : Icon(category.icon, size: 50, color: const Color(0xFF1D2939).withOpacity(0.7)),
                  ),
                ),
              ),
            ),
            if (category.badge != null)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 85,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: category.badgeColor ?? const Color(0xFFF04438),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    category.badge!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (category.name.contains('Vitamins')) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductListPage()),
              );
            }
          },
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF344054),
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryData {
  final String name;
  final IconData? icon;
  final String? imagePath;
  final String? badge;
  final Color? badgeColor;

  const _CategoryData({
    required this.name,
    this.icon,
    this.imagePath,
    this.badge,
    this.badgeColor,
  });
}

const categories = [
  _CategoryData(
    name: 'Vitamins &\nSupplements', 
    imagePath: 'assets/images/vitamins.png',
  ),
  _CategoryData(
    name: 'Homeopathic\nMedicine', 
    imagePath: 'assets/images/homeopathic.png',
  ),
  _CategoryData(
    name: 'Monitoring\nDevices', 
    imagePath: 'assets/images/monitoring.png',
  ),
  _CategoryData(
    name: 'Sexual\nWellness', 
    imagePath: 'assets/images/sexual_wellness.png',
  ),
  _CategoryData(name: 'Ayurvedic\nWellness', icon: Icons.eco),
  _CategoryData(name: 'Food &\nNutrition', icon: Icons.set_meal),
  _CategoryData(name: 'Fitness &\nHealth', icon: Icons.fitness_center, badge: 'Best Seller', badgeColor: Color(0xFFF79009)),
  _CategoryData(name: 'Skin Care', icon: Icons.face),
  _CategoryData(name: 'Men Care', icon: Icons.face_retouching_natural),
  _CategoryData(name: 'Women Care', icon: Icons.woman),
  _CategoryData(name: 'Elderly Care', icon: Icons.elderly),
  _CategoryData(name: 'Pet Care', icon: Icons.pets, badge: 'New', badgeColor: Color(0xFFF04438)),
  _CategoryData(name: 'Pain Relief', icon: Icons.healing),
  _CategoryData(name: 'Supports &\nBraces', icon: Icons.accessible),
  _CategoryData(name: 'Stomach\nCare', icon: Icons.health_and_safety, badge: 'Trending'),
  _CategoryData(name: 'Clean\nEnvironmen...', icon: Icons.sanitizer, badge: 'Must Have', badgeColor: Color(0xFFF79009)),
];

];
