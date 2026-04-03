import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserProvider with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
  final AuthService _authService = AuthService();
  
  String _name = 'Dr. Julian Vance';
  String _avatarUrl = 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=200';
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
  String _membershipType = 'PREMIUM MEMBER';
  String _memberSince = 'Oct 2023';
  bool _isTwoFactorEnabled = true;
  String _digitalTwinStatus = 'Active';
  String _wearableStatus = 'CONNECTED';

  List<dynamic> _conditions = [];
  bool _isLoadingConditions = false;

  UserProvider() {
    _initDio();
    _initPersistence();
  }

  void _initDio() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authService.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> _initPersistence() async {
    await _loadFromPrefs();
    await fetchConditions();
    await syncProfileWithBackend();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? _name;
    _avatarUrl = prefs.getString('user_avatar') ?? _avatarUrl;
    _dob = prefs.getString('user_dob') ?? _dob;
    _gender = prefs.getString('user_gender') ?? _gender;
    _email = prefs.getString('user_email') ?? _email;
    _phone = prefs.getString('user_phone') ?? _phone;
    _address = prefs.getString('user_address') ?? _address;
    _height = prefs.getString('user_height') ?? _height;
    _weight = prefs.getString('user_weight') ?? _weight;
    _bloodGroup = prefs.getString('user_blood_group') ?? _bloodGroup;
    _isTwoFactorEnabled = prefs.getBool('user_2fa') ?? _isTwoFactorEnabled;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    await prefs.setString('user_avatar', _avatarUrl);
    await prefs.setString('user_dob', _dob);
    await prefs.setString('user_gender', _gender);
    await prefs.setString('user_email', _email);
    await prefs.setString('user_phone', _phone);
    await prefs.setString('user_address', _address);
    await prefs.setString('user_height', _height);
    await prefs.setString('user_weight', _weight);
    await prefs.setString('user_blood_group', _bloodGroup);
    await prefs.setBool('user_2fa', _isTwoFactorEnabled);
  }

  Future<void> syncProfileWithBackend() async {
    try {
      final response = await _dio.get('/api/v1/profile/$_clinicalId');
      final data = response.data;
      if (data != null) {
        _name = data['name'] ?? _name;
        _avatarUrl = data['avatar_url'] ?? _avatarUrl;
        _dob = data['dob'] ?? _dob;
        _gender = data['gender'] ?? _gender;
        _email = data['email'] ?? _email;
        _phone = data['phone'] ?? _phone;
        _address = data['address'] ?? _address;
        _height = data['height'] ?? _height;
        _weight = data['weight'] ?? _weight;
        _bloodGroup = data['blood_group'] ?? _bloodGroup;
        _membershipType = data['membership_type'] ?? _membershipType;
        _memberSince = data['member_since'] ?? _memberSince;
        _isTwoFactorEnabled = data['is_two_factor_enabled'] ?? _isTwoFactorEnabled;
        _digitalTwinStatus = data['digital_twin_status'] ?? _digitalTwinStatus;
        _wearableStatus = data['wearable_status'] ?? _wearableStatus;
        
        // Recalculate age
        if (_dob.isNotEmpty) {
           try {
            final yearStr = _dob.split('/').last;
            final year = int.tryParse(yearStr);
            if (year != null) {
              _age = (DateTime.now().year - year).toString();
            }
          } catch (_) {}
        }
        
        await _saveToPrefs();
        notifyListeners();
      }
    } catch (e) {
      print('Error syncing profile with backend: $e');
    }
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
  String get membershipType => _membershipType;
  String get memberSince => _memberSince;
  bool get isTwoFactorEnabled => _isTwoFactorEnabled;
  String get digitalTwinStatus => _digitalTwinStatus;
  String get wearableStatus => _wearableStatus;
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
    _saveToPrefs();
    _pushToBackend();
  }

  Future<void> _pushToBackend() async {
    try {
      await _dio.put('/api/v1/profile/$_clinicalId', data: {
        'name': _name,
        'avatar_url': _avatarUrl,
        'dob': _dob,
        'gender': _gender,
        'email': _email,
        'phone': _phone,
        'address': _address,
        'height': _height,
        'weight': _weight,
        'blood_group': _bloodGroup,
        'is_two_factor_enabled': _isTwoFactorEnabled,
      });
    } catch (e) {
      print('Error pushing profile to backend: $e');
    }
  }
}
