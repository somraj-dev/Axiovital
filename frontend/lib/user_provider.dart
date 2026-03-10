import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserProvider with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
  
  String _name = 'Alexander Chen';
  String _avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200';
  String _clinicalId = 'VS-99283';
  String _age = '32';
  String _weight = '78';
  String _bloodGroup = 'O+';
  String _dob = '12/05/1992';
  String _email = 'alex.j@vitalsync.ai';
  String _phone = '+1 (555) 000-8829';
  String _address = '123 Health Ave, Clinical Park, New York, NY 10001';
  String _height = '182';
  String _gender = 'Male';

  List<dynamic> _conditions = [];
  bool _isLoadingConditions = false;

  UserProvider() {
    fetchConditions();
  }

  // Getters
  String get name => _name;
  String get avatarUrl => _avatarUrl;
  String get clinicalId => _clinicalId;
  String get age => _age;
  String get weight => _weight;
  String get bloodGroup => _bloodGroup;
  String get dob => _dob;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get height => _height;
  String get gender => _gender;
  List<dynamic> get conditions => _conditions;
  bool get isLoadingConditions => _isLoadingConditions;

  Future<void> fetchConditions() async {
    _isLoadingConditions = true;
    notifyListeners();
    try {
      final response = await _dio.get('/api/v1/conditions/$_clinicalId');
      _conditions = response.data;
    } catch (e) {
      print('Error fetching conditions: $e');
    } finally {
      _isLoadingConditions = false;
      notifyListeners();
    }
  }

  // Setters with notifyListeners
  void updateProfile({
    String? name,
    String? avatarUrl,
    String? dob,
    String? gender,
    String? email,
    String? phone,
    String? address,
    String? height,
    String? weight,
    String? bloodGroup,
  }) {
    if (name != null) _name = name;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    if (dob != null) _dob = dob;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address != null) _address = address;
    if (height != null) _height = height;
    if (gender != null) _gender = gender;
    if (weight != null) _weight = weight;
    if (bloodGroup != null) _bloodGroup = bloodGroup;
    
    // Auto-calculate age from DOB if needed, for now just keeping it simple
    if (dob != null) {
      // Very simple year-based age calculation for demo
      try {
        final yearStr = dob.split('/').last;
        final year = int.tryParse(yearStr);
        if (year != null) {
          _age = (DateTime.now().year - year).toString();
        }
      } catch (e) {
        // Fallback
      }
    }

    notifyListeners();
  }
}
