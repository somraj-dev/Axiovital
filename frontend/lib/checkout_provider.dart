import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final String gender;
  final int age;
  final String imagePath;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.imagePath,
  });
}

class CollectionSlot {
  final DateTime date;
  final String timeRange;
  final double extraFee;

  CollectionSlot({
    required this.date,
    required this.timeRange,
    this.extraFee = 0.0,
  });
}

class CheckoutProvider extends ChangeNotifier {
  final List<Patient> _availablePatients = [
    Patient(
      id: 'p1',
      name: 'Somraj',
      gender: 'Male',
      age: 19,
      imagePath: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    ),
  ];

  final List<String> _selectedPatientIds = ['p1'];
  String _selectedAddressId = 'addr1';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  double _slotExtraFee = 0.0;
  String? _selectedPaymentMethod;

  List<Patient> get availablePatients => _availablePatients;
  List<String> get selectedPatientIds => _selectedPatientIds;
  List<Patient> get selectedPatients =>
      _availablePatients.where((p) => _selectedPatientIds.contains(p.id)).toList();
  
  String get selectedAddressId => _selectedAddressId;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  double get slotExtraFee => _slotExtraFee;
  String? get selectedPaymentMethod => _selectedPaymentMethod;

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

  void addPatient(Patient patient) {
    _availablePatients.add(patient);
    notifyListeners();
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
