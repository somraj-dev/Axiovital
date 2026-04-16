import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserProvider with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:7860'));
  final AuthService _authService = AuthService();
  
  String _name = 'Dr. Julian Vance';
  String _avatarUrl = 'https://ui-avatars.com/api/?name=Julian+Vance&background=0D8ABC&color=fff&size=200';
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
  String _language = 'English (United States)';
  
  final Map<String, Map<String, String>> _translations = {
    'English (United States)': {
      'profile': 'Profile',
      'account': 'Account',
      'manage_profile': 'Manage Profile',
      'password_security': 'Password & Security',
      'notifications': 'Notifications',
      'language': 'Language',
      'preferences': 'Preferences',
      'about_us': 'About Us',
      'theme': 'Theme',
      'appointments': 'Appointments',
      'support': 'Support',
      'help_center': 'Help Center',
      'settings': 'Settings',
      'settings_hub': 'Settings Hub',
      'account_management': 'Account Management',
      'delete_account': 'Delete Account',
      'support_faqs': 'Support & FAQs',
      'app': 'App',
      'app_updates': 'App Updates',
      'home': 'Home',
      'doctors': 'Doctors',
      'labs': 'Labs',
      'insights': 'Insights',
      'appearance': 'Appearance',
      'theme_presets': 'Theme Presets',
      'custom_primary': 'Custom Primary Color',
      'glass_nav': 'Glass Bottom Bar',
      'apply': 'Apply Theme',
      'hex_code': 'Hex Code',
    },
    'Nederlands (Belgie)': {
      'profile': 'Profiel',
      'account': 'Account',
      'manage_profile': 'Profiel beheren',
      'password_security': 'Wachtwoord & Beveiliging',
      'notifications': 'Meldingen',
      'language': 'Taal',
      'preferences': 'Voorkeuren',
      'about_us': 'Over ons',
      'theme': 'Thema',
      'appointments': 'Afspraken',
      'support': 'Ondersteuning',
      'help_center': 'Helpcentrum',
      'settings': 'Instellingen',
      'settings_hub': 'Instellingen Hub',
      'account_management': 'Accountbeheer',
      'delete_account': 'Account verwijderen',
      'support_faqs': 'Ondersteuning & Veelgestelde vragen',
      'app': 'App',
      'app_updates': 'App-updates',
      'home': 'Home',
      'doctors': 'Artsen',
      'labs': 'Labs',
      'insights': 'Inzichten',
      'appearance': 'Uiterlijk',
      'theme_presets': 'Thema Voorinstellingen',
      'custom_primary': 'Aangepaste Kleur',
      'glass_nav': 'Glazen Balk',
      'apply': 'Thema Toepassen',
      'hex_code': 'Hex-code',
    },
    'Hindi': {
      'profile': 'प्रोफ़ाइल',
      'account': 'खाता',
      'manage_profile': 'प्रोफ़ाइल प्रबंधित करें',
      'password_security': 'पासवर्ड और सुरक्षा',
      'notifications': 'सूचनाएं',
      'language': 'भाषा',
      'preferences': 'प्राथमिकताएं',
      'about_us': 'हमारे बारे में',
      'theme': 'थीम',
      'appointments': 'अपॉइंटमेंट',
      'support': 'सहायता',
      'help_center': 'सहायता केंद्र',
      'settings': 'सेटिंग्स',
      'settings_hub': 'सेटिंग्स हब',
      'account_management': 'खाता प्रबंधन',
      'delete_account': 'खाता हटाएँ',
      'support_faqs': 'सहायता और अक्सर पूछे जाने वाले प्रश्न',
      'app': 'ऐप',
      'app_updates': 'ऐप अपडेट',
      'home': 'होम',
      'doctors': 'डॉक्टर',
      'labs': 'लैब्स',
      'insights': 'इनसाइट्स',
      'appearance': 'दिखावट',
      'theme_presets': 'थीम प्रीसेट',
      'custom_primary': 'कस्टम प्राथमिक रंग',
      'glass_nav': 'ग्लास बॉटम बार',
      'apply': 'थीम लागू करें',
      'hex_code': 'हेक्स कोड',
    },
  };

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
    _language = prefs.getString('user_language') ?? _language;
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
    await prefs.setString('user_language', _language);
  }

  Future<void> syncProfileWithBackend() async {
    try {
      final response = await _dio.get('/api_v1/profile/$_clinicalId');
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
  String get language => _language;
  List<dynamic> get conditions => _conditions;
  bool get isLoadingConditions => _isLoadingConditions;
  
  String get axioId {
    // Prefix
    const String prefix = "AX";
    
    // 1. Join Month (MM) and Year (YY) from _memberSince (e.g., "Oct 2023")
    final Map<String, String> monthMap = {
      'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
      'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
    };
    final List<String> sinceParts = _memberSince.split(' ');
    String joinMonth = '01';
    String joinYearShort = '23';

    if (sinceParts.isNotEmpty) {
      joinMonth = monthMap[sinceParts[0]] ?? '01';
      if (sinceParts.length > 1 && sinceParts[1].length >= 4) {
        joinYearShort = sinceParts[1].substring(2);
      }
    }

    // 2. Initials (FL) from _name (e.g., "Dr. Julian Vance")
    // Remove common titles
    final String cleanName = _name.replaceAll(RegExp(r'^(Dr\.|Mr\.|Mrs\.|Ms\.)\s+'), '');
    final List<String> nameParts = cleanName.trim().split(' ');
    
    String fInitial = 'A';
    String lInitial = 'X';
    
    if (nameParts.isNotEmpty) {
      fInitial = nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : 'A';
      if (nameParts.length > 1) {
        lInitial = nameParts.last.isNotEmpty ? nameParts.last[0].toUpperCase() : 'X';
      }
    }

    // 3. DOB (DDMMYY) from _dob (e.g., "12/05/1992")
    final List<String> dobParts = _dob.split('/');
    String dobDay = '01';
    String dobMonth = '01';
    String dobYearShort = '00';

    if (dobParts.length == 3) {
      dobDay = dobParts[0].padLeft(2, '0');
      dobMonth = dobParts[1].padLeft(2, '0');
      if (dobParts[2].length >= 4) {
        dobYearShort = dobParts[2].substring(2);
      } else if (dobParts[2].length == 2) {
        dobYearShort = dobParts[2];
      }
    }

    return "$prefix$joinMonth$fInitial$lInitial$dobDay$dobMonth$dobYearShort$joinYearShort";
  }


  Future<void> fetchConditions() async {
    _isLoadingConditions = true;
    notifyListeners();
    try {
      final response = await _dio.get('/api_v1/conditions/$_clinicalId');
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
    String? language,
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
    if (language != null) _language = language;
    
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

  void updateLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
    _saveToPrefs();
  }

  String translate(String key) {
    return _translations[_language]?[key] ?? _translations['English (United States)']?[key] ?? key;
  }

  Future<void> _pushToBackend() async {
    try {
      await _dio.put('/api_v1/profile/$_clinicalId', data: {
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
