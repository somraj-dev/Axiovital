import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodAnalysisPage extends StatefulWidget {
  const FoodAnalysisPage({super.key});

  @override
  State<FoodAnalysisPage> createState() => _FoodAnalysisPageState();
}

class _FoodAnalysisPageState extends State<FoodAnalysisPage> {
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  bool _analysisComplete = false;

  void _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _capturedImage = image;
        _isAnalyzing = true;
      });
      // Simulate AI Processing
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
            _analysisComplete = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background: Camera Preview or Captured Image
          Positioned.fill(
            child: _capturedImage == null
                ? Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 80),
                    ),
                  )
                : kIsWeb
                    ? Image.network(_capturedImage!.path, fit: BoxFit.cover)
                    : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),

          // Header Overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
                Text(
                  'AI Scaner',
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const Icon(Icons.more_horiz, color: Colors.white),
              ],
            ),
          ),

          // Scanning Frame (Visible when no image or analyzing)
          if (_capturedImage == null || _isAnalyzing)
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    // Corner effects could be added here
                    if (_isAnalyzing)
                      const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ],
                ),
              ),
            ),

          // Scanning Controls (Visible only when no image)
          if (_capturedImage == null)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(Icons.camera_alt, 'AI Camera', isActive: true, onTap: _openCamera),
                      const SizedBox(width: 12),
                      _buildControlButton(Icons.qr_code_scanner, '', isActive: false),
                      const SizedBox(width: 12),
                      _buildControlButton(Icons.image_outlined, '', isActive: false),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _openCamera,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.center_focus_strong, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Results Bottom Sheet
          if (_analysisComplete) _buildResultSheet(),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, {required bool isActive, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.black : Colors.white, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: isActive ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Breakfast',
                  style: GoogleFonts.inter(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: const [
                      Icon(Icons.remove, size: 16),
                      SizedBox(width: 8),
                      Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.add, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Kiwi Smoothie Bowl\nwith Granola',
              style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildNutrientCard('🔥 Calories', '450', Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildNutrientCard('🫙 Protein', '20gm', Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildNutrientCard('🍇 Carbs', '140gm', Colors.purple)),
                const SizedBox(width: 12),
                Expanded(child: _buildNutrientCard('🥦 Fat', '12gm', Colors.green)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
              const Text('Edit', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

