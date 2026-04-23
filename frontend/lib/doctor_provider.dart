import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

class MedicalCategory {
  final String id;
  final String name;
  final String icon;
  final int specialistCount;

  MedicalCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.specialistCount,
  });
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String qualifications;
  final String imageUrl;
  final int sessionPrice;
  final Color cardColor;
  final double rating;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.imageUrl,
    required this.sessionPrice,
    required this.cardColor,
    this.rating = 4.5,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
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
      rating: (map['rating'] ?? 4.5).toDouble(),
    );
  }
}

class DoctorProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Doctor> _doctors = [];
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors.isNotEmpty ? _doctors : _mockDoctors;
  bool get isLoading => _isLoading;

  final List<MedicalCategory> categories = [
    MedicalCategory(id: '1', name: 'Pediatrics', icon: '👶', specialistCount: 18),
    MedicalCategory(id: '2', name: 'Cardiology', icon: '❤️', specialistCount: 24),
    MedicalCategory(id: '3', name: 'Neurology', icon: '🧠', specialistCount: 33),
    MedicalCategory(id: '4', name: 'Oncologist', icon: '🎗️', specialistCount: 29),
    MedicalCategory(id: '5', name: 'Gynologist', icon: '🤰', specialistCount: 27),
    MedicalCategory(id: '6', name: 'Radiology', icon: '☢️', specialistCount: 25),
    MedicalCategory(id: '7', name: 'ENT', icon: '👂', specialistCount: 31),
    MedicalCategory(id: '8', name: 'Urology', icon: '🚿', specialistCount: 37),
    MedicalCategory(id: '9', name: 'Medicine', icon: '💊', specialistCount: 28),
  ];

  final List<Doctor> _mockDoctors = [
    Doctor(
      id: 'd1',
      name: 'Dr. Vivian Green',
      specialty: 'General Dentist',
      qualifications: 'DDS, MSD',
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=2070&auto=format&fit=crop',
      sessionPrice: 150,
      cardColor: const Color(0xFFE0F2F1),
      rating: 4.8,
    ),
    Doctor(
      id: 'd2',
      name: 'Dr. Lisa Tran',
      specialty: 'ENT Specialist',
      qualifications: 'MD, FACS',
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71f1e3c77e?q=80&w=2070&auto=format&fit=crop',
      sessionPrice: 180,
      cardColor: const Color(0xFFE1F5FE),
      rating: 4.7,
    ),
    Doctor(
      id: 'd3',
      name: 'Dr. Alice Huang',
      specialty: 'Cardiologist',
      qualifications: 'MD, FACC',
      imageUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=2070&auto=format&fit=crop',
      sessionPrice: 200,
      cardColor: const Color(0xFFFCE4EC),
      rating: 4.9,
    ),
    Doctor(
      id: 'd4',
      name: 'Dr. Omar Hassan',
      specialty: 'Pediatrician',
      qualifications: 'MD, FAAP',
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=2070&auto=format&fit=crop',
      sessionPrice: 120,
      cardColor: const Color(0xFFF3E5F5),
      rating: 4.6,
    ),
  ];

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

