import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String qualifications;
  final String imageUrl;
  final int sessionPrice;
  final Color cardColor;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.imageUrl,
    required this.sessionPrice,
    required this.cardColor,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    // Helper to convert hex string to Color
    Color hexToColor(String? hexString) {
      if (hexString == null) return const Color(0xFFE2E8F0);
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    return Doctor(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      qualifications: map['qualifications'] ?? '',
      imageUrl: map['image_url'] ?? '',
      sessionPrice: map['session_price'] ?? 0,
      cardColor: hexToColor(map['card_color_hex']),
    );
  }
}

class DoctorProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Doctor> _doctors = [];
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> loadDoctors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('doctors')
          .select()
          .order('name', ascending: true);
      
      _doctors = data.map((item) => Doctor.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Error loading doctors from Supabase: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
