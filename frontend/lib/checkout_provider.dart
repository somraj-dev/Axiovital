import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Patient {
  final String id;
  final String name;
  final String gender;
  final int age;
  final String imagePath;
  final String relation;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.imagePath,
    this.relation = 'Me',
  });
}

class CheckoutProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Patient> _availablePatients = [];
  List<String> _selectedPatientIds = [];
  String _selectedAddressId = 'addr1';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  double _slotExtraFee = 0.0;
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  List<Patient> get availablePatients => _availablePatients;
  List<String> get selectedPatientIds => _selectedPatientIds;
  List<Patient> get selectedPatients =>
      _availablePatients.where((p) => _selectedPatientIds.contains(p.id)).toList();
  
  String get selectedAddressId => _selectedAddressId;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  double get slotExtraFee => _slotExtraFee;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isLoading => _isLoading;

  CheckoutProvider() {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('patients')
          .select()
          .eq('user_id', user.id);

      _availablePatients = data.map((json) => Patient(
        id: json['id'],
        name: json['name'],
        gender: json['gender'] ?? 'Not specified',
        age: json['age'] ?? 0,
        imagePath: json['image_path'] ?? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        relation: json['relation'] ?? 'Me',
      )).toList();

      if (_selectedPatientIds.isEmpty && _availablePatients.isNotEmpty) {
        _selectedPatientIds = [_availablePatients.first.id];
      }
    } catch (e) {
      debugPrint('Error fetching patients: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void togglePatientSelection(String patientId) {
    if (_selectedPatientIds.contains(patientId)) {
      if (_selectedPatientIds.length > 1) {
        _selectedPatientIds.remove(patientId);
      }
    } else {
      _selectedPatientIds.add(patientId);
    }
    notifyListeners();
  }

  Future<void> addPatient(String name, String relation, int age, String gender) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('patients').insert({
        'user_id': user.id,
        'name': name,
        'relation': relation,
        'age': age,
        'gender': gender,
        'image_path': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      });
      await fetchPatients();
    } catch (e) {
      debugPrint('Error adding patient: $e');
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedSlot(String slot, double fee) {
    _selectedTimeSlot = slot;
    _slotExtraFee = fee;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
