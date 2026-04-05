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
      Future.delayed(const Duration(seconds: 3), () {
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
    if (_capturedImage == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text('Capture Food', style: TextStyle(color: Colors.black))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fastfood_outlined, size: 80, color: Color(0xFF6366F1)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('Capture to Analyze', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context))),
      body: Column(
        children: [
          Expanded(child: _buildImageSection()),
          if (_analysisComplete) _buildResultSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(24)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: kIsWeb ? Image.network(_capturedImage!.path, fit: BoxFit.cover) : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),
          if (_isAnalyzing)
            Container(color: Colors.black.withOpacity(0.5), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [CircularProgressIndicator(color: Colors.white), SizedBox(height: 16), Text('AI Analyzing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [Text('84', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)), Text('/ 100', style: TextStyle(color: Colors.grey, fontSize: 18)), Spacer(), Text('Good choice!', style: TextStyle(color: Color(0xFF12B76A), fontWeight: FontWeight.bold))]),
          const SizedBox(height: 24),
          const Text('Nutritional Data (100g)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
          const SizedBox(height: 12),
          _buildMacroRow('Carbs', '12g', Colors.orange),
          _buildMacroRow('Protein', '8g', Colors.pink.shade200),
          _buildMacroRow('Fat', '4g', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.grey)), const Spacer(), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]));
  }
}
