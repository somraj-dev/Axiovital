import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class FoodAnalysisPage extends StatefulWidget {
  const FoodAnalysisPage({super.key});

  @override
  State<FoodAnalysisPage> createState() => _FoodAnalysisPageState();
}

class _FoodAnalysisPageState extends State<FoodAnalysisPage> {
  bool _isAnalyzing = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null) {
        setState(() {
          _capturedImage = image;
          _isAnalyzing = true;
        });

        // Simulate mobile camera capture and AI analysis
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isAnalyzing = false;
            });
          }
        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Camera error: $e");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImage == null && !_isAnalyzing) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    if (_isAnalyzing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF1570EF), size: 100),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Color(0xFF1570EF)),
              const SizedBox(height: 24),
              const Text(
                'AI Analysis in Progress...',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Identifying nutrients and ingredients',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.blue),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        title: const Text('Search', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Captured Product Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: kIsWeb
                        ? Image.network(_capturedImage!.path, fit: BoxFit.cover)
                        : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harvest Snaps Green\nPea Snacks',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2),
                        ),
                        const SizedBox(height: 4),
                        const Text('Calbee', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(color: Color(0xFF12B76A), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '84/100',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text('Excellent', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // Positives Section
            _buildSectionHeader('Positives'),
            _buildNutrientItem(Icons.waves, 'Protein', 'Excellent amount of protein', '5g', true),
            _buildNutrientItem(Icons.eco_outlined, 'Fiber', 'Excellent amount of fiber', '4g', true),
            _buildNutrientItem(Icons.local_florist_outlined, 'Vegetables', 'Good quantity', '50%', true),
            _buildNutrientItem(Icons.water_drop_outlined, 'Saturated fat', 'No saturated fat', '0g', true),
            _buildNutrientItem(Icons.grid_view_rounded, 'Sugar', 'No sugar', '0g', true),
            _buildNutrientItem(Icons.kitchen_outlined, 'Sodium', 'Low impact', '75mg', true),

            const Divider(thickness: 1, height: 40),

            // Negatives Section
            _buildSectionHeader('Negatives'),
            _buildNutrientItem(Icons.biotech_outlined, 'Additives', 'Additives with limited risk', '1', false, isWarning: true),
            _buildNutrientItem(Icons.local_fire_department_outlined, 'Calories', 'A bit too caloric', '130 Cal', false, isWarning: true),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavIcon(Icons.eco_outlined, 'History'),
            _buildBottomNavIcon(Icons.swap_horiz, 'Recs'),
            _buildBottomNavIcon(Icons.qr_code_scanner, 'Scan', isActive: true),
            _buildBottomNavIcon(Icons.list_alt, 'Tops'),
            _buildBottomNavIcon(Icons.search, 'Search'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('per serving (28g)', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNutrientItem(IconData icon, String title, String subtitle, String amount, bool isPositive, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          const SizedBox(width: 8),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isWarning ? Colors.orange : (isPositive ? const Color(0xFF12B76A) : Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildBottomNavIcon(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF12B76A) : Colors.grey.shade400, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF12B76A) : Colors.grey.shade400,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
