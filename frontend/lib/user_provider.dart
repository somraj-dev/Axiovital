import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'main.dart'; // To access kIsAuthBypass

class UserProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();
  
  // Local state
  String _name = 'New User';
  String _avatarUrl = '';
  String _clinicalId = 'AX-00000';
  String _age = '--';
  String _weight = '--';
  String _bloodGroup = '--';
  String _dob = '--';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _height = '--';
  String _gender = '--';
  String _membershipType = 'FREE MEMBER';
  String _memberSince = 'Oct 2023';
  bool _isTwoFactorEnabled = false;
  String _digitalTwinStatus = 'Inactive';
  String _wearableStatus = 'DISCONNECTED';
  String _language = 'English (United States)';
  
  List<dynamic> _conditions = [];
  bool _isLoading = false;

  UserProvider() {
    _initPersistence();
  }

  Future<void> _initPersistence() async {
    if (kIsAuthBypass) {
      _loadMockDeveloperData();
    } else {
      await _loadFromPrefs();
      await fetchProfileFromCloud();
    }
  }

  void _loadMockDeveloperData() {
    _name = 'Somraj Dev';
    _avatarUrl = 'https://api.dicebear.com/7.x/avataaars/svg?seed=Somraj';
    _clinicalId = 'AX-DEBUG-001';
    _age = '28';
    _gender = 'Male';
    _membershipType = 'GOLD MEMBER';
    _digitalTwinStatus = 'Active';
    _wearableStatus = 'CONNECTED (MOCK)';
    notifyListeners();
  }

  // Fetch profile from Supabase
  Future<void> fetchProfileFromCloud() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (data != null) {
        _name = data['name'] ?? _name;
        _avatarUrl = data['avatar_url'] ?? _avatarUrl;
        _clinicalId = data['clinical_id'] ?? _clinicalId;
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
        
        // Calculate age
        if (_dob != '--') {
           try {
            final yearStr = _dob.split('/').last;
            final year = int.tryParse(yearStr);
            if (year != null) {
              _age = (DateTime.now().year - year).toString();
            }
          } catch (_) {}
        }
        
        await _saveToPrefs();
      }
    } catch (e) {
      debugPrint('Error fetching profile from Supabase: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile and sync to Supabase
  Future<void> updateProfile({
    String? name,
    String? dob,
    String? gender,
    String? email,
    String? phone,
    String? address,
    String? height,
    String? weight,
    String? bloodGroup,
    String? avatarUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final updates = {
      'id': user.id,
      if (name != null) 'name': name,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await _supabase.from('profiles').upsert(updates);
      await fetchProfileFromCloud(); // Refresh local state
    } catch (e) {
      debugPrint('Error updating profile in Supabase: $e');
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
  String get language => _language;
  bool get isLoading => _isLoading;

  // Additional getters for ProfilePage compatibility
  String get axioId => _clinicalId;
  List<dynamic> get conditions => _conditions;
  bool get isLoadingConditions => false;

  Future<void> fetchConditions() async {
    // Mock or implement if needed
    notifyListeners();
  }

  Future<void> updateLanguage(String newLanguage) async {
    _language = newLanguage;
    await _saveToPrefs();
    notifyListeners();
  }

  // Mock translation method
  String translate(String key) => key;

  // Persistence (same as before)
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? _name;
    _avatarUrl = prefs.getString('user_avatar') ?? _avatarUrl;
    _language = prefs.getString('user_language') ?? _language;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    await prefs.setString('user_avatar', _avatarUrl);
    await prefs.setString('user_language', _language);
  }
}
