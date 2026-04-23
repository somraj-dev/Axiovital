import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class LabBooking {
  final String id;
  final String patientId;
  final String packageName;
  final String collectionDate;
  final String collectionSlot;
  final String collectionAddress;
  final String status;
  final String paymentMethod;
  final double amount;
  final String confirmationCode;
  final String? reportUrl;
  final DateTime createdAt;

  LabBooking({
    required this.id,
    required this.patientId,
    required this.packageName,
    required this.collectionDate,
    required this.collectionSlot,
    required this.collectionAddress,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.confirmationCode,
    this.reportUrl,
    required this.createdAt,
  });

  factory LabBooking.fromMap(Map<String, dynamic> map) {
    return LabBooking(
      id: map['id'] ?? '',
      patientId: map['patient_id'] ?? '',
      packageName: map['package_name'] ?? '',
      collectionDate: map['collection_date'] ?? '',
      collectionSlot: map['collection_slot'] ?? '',
      collectionAddress: map['collection_address'] ?? '',
      status: map['status'] ?? 'confirmed',
      paymentMethod: map['payment_method'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      confirmationCode: map['confirmation_code'] ?? '',
      reportUrl: map['report_url'],
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  String get displayDate {
    try {
      final dt = DateTime.parse(collectionDate);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return collectionDate;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'confirmed': return 'Confirmed';
      case 'sample_collected': return 'Sample Collected';
      case 'processing': return 'Processing';
      case 'report_ready': return 'Report Ready';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'confirmed': return const Color(0xFF039855);
      case 'sample_collected': return const Color(0xFF1570EF);
      case 'processing': return const Color(0xFFF79009);
      case 'report_ready': return const Color(0xFF6941C6);
      case 'cancelled': return const Color(0xFFD92D20);
      default: return const Color(0xFF667085);
    }
  }

  bool get isUpcoming {
    try {
      final dt = DateTime.parse(collectionDate);
      return dt.isAfter(DateTime.now().subtract(const Duration(days: 1))) && status != 'cancelled';
    } catch (_) {
      return false;
    }
  }
}

class LabBookingProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<LabBooking> _bookings = [];
  bool _isLoading = false;

  List<LabBooking> get bookings => _bookings;
  List<LabBooking> get upcomingBookings => _bookings.where((b) => b.isUpcoming).toList();
  List<LabBooking> get pastBookings => _bookings.where((b) => !b.isUpcoming).toList();
  bool get isLoading => _isLoading;

  /// Fetch all lab bookings for current user
  Future<void> fetchMyLabBookings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _supabase
          .from('lab_bookings')
          .select()
          .eq('user_id', user.id)
          .order('collection_date', ascending: false);

      _bookings = data.map((item) => LabBooking.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Error fetching lab bookings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Book a lab test
  Future<LabBooking?> bookLabTest({
    required String packageName,
    required double amount,
    required String patientId,
    required String collectionDate,
    required String collectionSlot,
    required String collectionAddress,
    required String paymentMethod,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final confirmCode = 'LAB-${Random().nextInt(9000) + 1000}-${String.fromCharCodes(List.generate(2, (_) => Random().nextInt(26) + 65))}';

    try {
      final response = await _supabase.from('lab_bookings').insert({
        'user_id': user.id,
        'patient_id': patientId,
        'package_name': packageName,
        'collection_date': collectionDate,
        'collection_slot': collectionSlot,
        'collection_address': collectionAddress,
        'status': 'confirmed',
        'payment_method': paymentMethod,
        'amount': amount,
        'confirmation_code': confirmCode,
      }).select().single();

      await fetchMyLabBookings();
      return LabBooking.fromMap(response);
    } catch (e) {
      debugPrint('Error booking lab test: $e');
      // Create local-only booking if DB fails
      final localBooking = LabBooking(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        patientId: patientId,
        packageName: packageName,
        collectionDate: collectionDate,
        collectionSlot: collectionSlot,
        collectionAddress: collectionAddress,
        status: 'confirmed',
        paymentMethod: paymentMethod,
        amount: amount,
        confirmationCode: confirmCode,
        createdAt: DateTime.now(),
      );
      _bookings.insert(0, localBooking);
      notifyListeners();
      return localBooking;
    }
  }

  /// Cancel a lab booking
  Future<void> cancelLabBooking(String bookingId) async {
    try {
      await _supabase
          .from('lab_bookings')
          .update({'status': 'cancelled', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', bookingId);
      await fetchMyLabBookings();
    } catch (e) {
      debugPrint('Error cancelling lab booking: $e');
      final idx = _bookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final old = _bookings[idx];
        _bookings[idx] = LabBooking(
          id: old.id, patientId: old.patientId, packageName: old.packageName,
          collectionDate: old.collectionDate, collectionSlot: old.collectionSlot,
          collectionAddress: old.collectionAddress, status: 'cancelled',
          paymentMethod: old.paymentMethod, amount: old.amount,
          confirmationCode: old.confirmationCode, createdAt: old.createdAt,
        );
        notifyListeners();
      }
    }
  }
}
