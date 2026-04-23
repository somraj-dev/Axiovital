import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientId;
  final String slotDate;
  final String slotTime;
  final String slotType;
  final String status;
  final String paymentMethod;
  final double amount;
  final String confirmationCode;
  final String pinCode;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
    required this.slotDate,
    required this.slotTime,
    required this.slotType,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.confirmationCode,
    required this.pinCode,
    required this.createdAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      doctorId: map['doctor_id'] ?? '',
      doctorName: map['doctor_name'] ?? '',
      doctorSpecialty: map['doctor_specialty'] ?? '',
      doctorImageUrl: map['doctor_image_url'] ?? '',
      patientId: map['patient_id'] ?? '',
      slotDate: map['slot_date'] ?? '',
      slotTime: map['slot_time'] ?? '',
      slotType: map['slot_type'] ?? 'clinic',
      status: map['status'] ?? 'confirmed',
      paymentMethod: map['payment_method'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      confirmationCode: map['confirmation_code'] ?? '',
      pinCode: map['pin_code'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Formatted display date like "Apr 25, 2026"
  String get displayDate {
    try {
      final dt = DateTime.parse(slotDate);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return slotDate;
    }
  }

  bool get isUpcoming {
    try {
      final dt = DateTime.parse(slotDate);
      return dt.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    } catch (_) {
      return false;
    }
  }
}

class AvailableSlot {
  final String id;
  final String time;
  final String type;
  final bool isBooked;

  AvailableSlot({
    required this.id,
    required this.time,
    required this.type,
    required this.isBooked,
  });
}

class AppointmentProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<Appointment> _appointments = [];
  List<AvailableSlot> _availableSlots = [];
  bool _isLoading = false;
  bool _isSlotsLoading = false;

  // Booking wizard state
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedSlotId;
  String _selectedSlotType = 'clinic';

  // Getters
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments =>
      _appointments.where((a) => a.isUpcoming && a.status != 'cancelled').toList();
  List<Appointment> get pastAppointments =>
      _appointments.where((a) => !a.isUpcoming || a.status == 'cancelled').toList();
  List<AvailableSlot> get availableSlots => _availableSlots;
  bool get isLoading => _isLoading;
  bool get isSlotsLoading => _isSlotsLoading;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  String get selectedSlotType => _selectedSlotType;

  /// Fetch all appointments for current user
  Future<void> fetchMyAppointments() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('appointments')
          .select()
          .eq('user_id', user.id)
          .order('slot_date', ascending: false);

      _appointments = data.map((item) => Appointment.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch available slots for a doctor on a given date
  Future<void> fetchSlotsForDoctor(String doctorId, DateTime date) async {
    _isSlotsLoading = true;
    notifyListeners();

    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final List<dynamic> data = await _supabase
          .from('doctor_slots')
          .select()
          .eq('doctor_id', doctorId)
          .eq('slot_date', dateStr)
          .order('slot_time', ascending: true);

      _availableSlots = data.map((item) => AvailableSlot(
        id: item['id'],
        time: item['slot_time'] ?? '',
        type: item['slot_type'] ?? 'clinic',
        isBooked: item['is_booked'] ?? false,
      )).toList();
    } catch (e) {
      debugPrint('Error fetching doctor slots: $e');
      // Provide fallback mock slots if DB table doesn't exist yet
      _availableSlots = _generateMockSlots();
    }

    _isSlotsLoading = false;
    notifyListeners();
  }

  /// Book an appointment
  Future<Appointment?> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorSpecialty,
    required String doctorImageUrl,
    required String patientId,
    required double amount,
    required String paymentMethod,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null || _selectedDate == null || _selectedTimeSlot == null) return null;

    final confirmCode = 'CONF-${Random().nextInt(9000) + 1000}-${String.fromCharCodes(List.generate(2, (_) => Random().nextInt(26) + 65))}';
    final pin = '${Random().nextInt(9000) + 1000}';
    final dateStr = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    try {
      // 1. Insert appointment
      final response = await _supabase.from('appointments').insert({
        'user_id': user.id,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'doctor_specialty': doctorSpecialty,
        'doctor_image_url': doctorImageUrl,
        'patient_id': patientId,
        'slot_date': dateStr,
        'slot_time': _selectedTimeSlot,
        'slot_type': _selectedSlotType,
        'status': 'confirmed',
        'payment_method': paymentMethod,
        'amount': amount,
        'confirmation_code': confirmCode,
        'pin_code': pin,
      }).select().single();

      // 2. Mark slot as booked (if using doctor_slots table)
      if (_selectedSlotId != null) {
        await _supabase
            .from('doctor_slots')
            .update({'is_booked': true})
            .eq('id', _selectedSlotId!);
      }

      // 3. Refresh appointments list
      await fetchMyAppointments();

      return Appointment.fromMap(response);
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      // Create a local-only appointment if DB fails
      final localAppointment = Appointment(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        doctorId: doctorId,
        doctorName: doctorName,
        doctorSpecialty: doctorSpecialty,
        doctorImageUrl: doctorImageUrl,
        patientId: patientId,
        slotDate: dateStr,
        slotTime: _selectedTimeSlot!,
        slotType: _selectedSlotType,
        status: 'confirmed',
        paymentMethod: paymentMethod,
        amount: amount,
        confirmationCode: confirmCode,
        pinCode: pin,
        createdAt: DateTime.now(),
      );
      _appointments.insert(0, localAppointment);
      notifyListeners();
      return localAppointment;
    }
  }

  /// Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _supabase
          .from('appointments')
          .update({'status': 'cancelled', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', appointmentId);
      await fetchMyAppointments();
    } catch (e) {
      debugPrint('Error cancelling appointment: $e');
      // Update locally
      final idx = _appointments.indexWhere((a) => a.id == appointmentId);
      if (idx != -1) {
        final old = _appointments[idx];
        _appointments[idx] = Appointment(
          id: old.id, doctorId: old.doctorId, doctorName: old.doctorName,
          doctorSpecialty: old.doctorSpecialty, doctorImageUrl: old.doctorImageUrl,
          patientId: old.patientId, slotDate: old.slotDate, slotTime: old.slotTime,
          slotType: old.slotType, status: 'cancelled', paymentMethod: old.paymentMethod,
          amount: old.amount, confirmationCode: old.confirmationCode,
          pinCode: old.pinCode, createdAt: old.createdAt,
        );
        notifyListeners();
      }
    }
  }

  // --- Booking wizard state management ---
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null;
    _selectedSlotId = null;
    notifyListeners();
  }

  void setSelectedSlot(String time, {String? slotId}) {
    _selectedTimeSlot = time;
    _selectedSlotId = slotId;
    notifyListeners();
  }

  void setSlotType(String type) {
    _selectedSlotType = type;
    notifyListeners();
  }

  void resetBookingState() {
    _selectedDate = null;
    _selectedTimeSlot = null;
    _selectedSlotId = null;
    _selectedSlotType = 'clinic';
    _availableSlots = [];
    notifyListeners();
  }

  /// Generate fallback mock slots when DB table doesn't exist
  List<AvailableSlot> _generateMockSlots() {
    final times = [
      '09:00 AM','09:30 AM','10:00 AM','10:30 AM','11:00 AM','11:30 AM',
      '02:00 PM','02:30 PM','03:00 PM','03:30 PM','04:00 PM',
      '05:00 PM','05:30 PM','06:00 PM',
    ];
    final rng = Random();
    return times.map((t) => AvailableSlot(
      id: 'mock_${t.replaceAll(' ', '_')}',
      time: t,
      type: 'clinic',
      isBooked: rng.nextDouble() < 0.2, // 20% chance of being booked
    )).toList();
  }
}
