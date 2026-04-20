import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/crypto_service.dart';
import 'services/blockchain_service.dart';

// ─── Data Models ────────────────────────────────────────

class ConsentRequest {
  final String id;
  final String requesterName;
  final String? requesterSpecialty;
  final String? requesterAvatar;
  final List<String> dataScope;
  final String purpose;
  final int durationDays;
  final String accessType;
  final String status;
  final String? message;
  final DateTime createdAt;

  ConsentRequest({
    required this.id,
    required this.requesterName,
    this.requesterSpecialty,
    this.requesterAvatar,
    required this.dataScope,
    required this.purpose,
    required this.durationDays,
    required this.accessType,
    required this.status,
    this.message,
    required this.createdAt,
  });

  factory ConsentRequest.fromJson(Map<String, dynamic> json) {
    return ConsentRequest(
      id: json['id'],
      requesterName: json['requester_name'],
      requesterSpecialty: json['requester_specialty'],
      requesterAvatar: json['requester_avatar'],
      dataScope: List<String>.from(json['data_scope'] ?? []),
      purpose: json['purpose'],
      durationDays: json['duration_days'] ?? 7,
      accessType: json['access_type'] ?? 'view_only',
      status: json['status'] ?? 'pending',
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Consent {
  final String id;
  final String requesterName;
  final String? requesterSpecialty;
  final List<String> dataScope;
  final String purpose;
  final String accessType;
  final DateTime validFrom;
  final DateTime validTill;
  final String status;
  final DateTime createdAt;

  Consent({
    required this.id,
    required this.requesterName,
    this.requesterSpecialty,
    required this.dataScope,
    required this.purpose,
    required this.accessType,
    required this.validFrom,
    required this.validTill,
    required this.status,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(validTill);
  bool get isActive => status == 'approved' && !isExpired;

  Duration get remainingTime => validTill.difference(DateTime.now());
  String get remainingLabel {
    final d = remainingTime;
    if (d.isNegative) return 'Expired';
    if (d.inDays > 0) return '${d.inDays}d remaining';
    if (d.inHours > 0) return '${d.inHours}h remaining';
    return '${d.inMinutes}m remaining';
  }

  factory Consent.fromJson(Map<String, dynamic> json) {
    return Consent(
      id: json['id'],
      requesterName: json['requester_name'],
      requesterSpecialty: json['requester_specialty'],
      dataScope: List<String>.from(json['data_scope'] ?? []),
      purpose: json['purpose'],
      accessType: json['access_type'] ?? 'view_only',
      validFrom: DateTime.parse(json['valid_from']),
      validTill: DateTime.parse(json['valid_till']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AccessLog {
  final String id;
  final String actorName;
  final String action;
  final String? recordType;
  final String? details;
  final String? blockchainHash;
  final DateTime createdAt;

  AccessLog({
    required this.id,
    required this.actorName,
    required this.action,
    this.recordType,
    this.details,
    this.blockchainHash,
    required this.createdAt,
  });

  factory AccessLog.fromJson(Map<String, dynamic> json) {
    return AccessLog(
      id: json['id'],
      actorName: json['actor_name'],
      action: json['action'],
      recordType: json['record_type'],
      details: json['details'],
      blockchainHash: json['blockchain_hash'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// ─── Provider ───────────────────────────────────────────

class ConsentProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _requestSubscription;

  List<ConsentRequest> _pendingRequests = [];
  List<Consent> _activeConsents = [];
  List<AccessLog> _accessLogs = [];
  int _totalRecords = 0;
  bool _isLoading = false;

  List<ConsentRequest> get pendingRequests => _pendingRequests;
  List<Consent> get activeConsents => _activeConsents;
  List<AccessLog> get accessLogs => _accessLogs;
  int get totalRecords => _totalRecords;
  int get activeShareCount => _activeConsents.where((c) => c.isActive).length;
  bool get isLoading => _isLoading;

  String? get _userId => _supabase.auth.currentUser?.id;

  ConsentProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await refreshAll();
    _setupRealtime();
  }

  void _setupRealtime() {
    _requestSubscription = _supabase
        .channel('consent_requests_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'consent_requests',
          callback: (payload) {
            final newReq = ConsentRequest.fromJson(payload.newRecord);
            if (newReq.status == 'pending') {
              _pendingRequests.insert(0, newReq);
              notifyListeners();
            }
          },
        )
        .subscribe();
  }

  Future<void> refreshAll() async {
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchPendingRequests(),
      fetchActiveConsents(),
      fetchAccessLogs(),
      fetchRecordCount(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // ─── Fetch Operations ─────────────────────────────────

  Future<void> fetchPendingRequests() async {
    if (_userId == null) return;
    try {
      final data = await _supabase
          .from('consent_requests')
          .select()
          .eq('patient_id', _userId!)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      _pendingRequests = (data as List).map((j) => ConsentRequest.fromJson(j)).toList();
    } catch (e) {
      debugPrint('Error fetching consent requests: $e');
    }
  }

  Future<void> fetchActiveConsents() async {
    if (_userId == null) return;
    try {
      final data = await _supabase
          .from('consents')
          .select()
          .eq('patient_id', _userId!)
          .eq('status', 'approved')
          .order('created_at', ascending: false);

      _activeConsents = (data as List).map((j) => Consent.fromJson(j)).toList();
      
      // Auto-expire stale consents
      for (final consent in _activeConsents) {
        if (consent.isExpired) {
          await _supabase
              .from('consents')
              .update({'status': 'expired'})
              .eq('id', consent.id);
        }
      }
      _activeConsents.removeWhere((c) => c.isExpired);
    } catch (e) {
      debugPrint('Error fetching consents: $e');
    }
  }

  Future<void> fetchAccessLogs() async {
    if (_userId == null) return;
    try {
      final data = await _supabase
          .from('access_logs')
          .select()
          .eq('patient_id', _userId!)
          .order('created_at', ascending: false)
          .limit(50);

      _accessLogs = (data as List).map((j) => AccessLog.fromJson(j)).toList();
    } catch (e) {
      debugPrint('Error fetching access logs: $e');
    }
  }

  Future<void> fetchRecordCount() async {
    if (_userId == null) return;
    try {
      final data = await _supabase
          .from('data_records')
          .select('id')
          .eq('user_id', _userId!);
      _totalRecords = (data as List).length;
    } catch (e) {
      debugPrint('Error fetching record count: $e');
    }
  }

  // ─── Consent Actions ──────────────────────────────────

  Future<void> approveRequest(String requestId, {List<String>? customScope, int? customDurationDays}) async {
    if (_userId == null) return;
    try {
      // 1. Find the request
      final request = _pendingRequests.firstWhere((r) => r.id == requestId);
      final scope = customScope ?? request.dataScope;
      final duration = customDurationDays ?? request.durationDays;
      final validTill = DateTime.now().add(Duration(days: duration));

      // 2. Create consent artifact
      final consentInsert = {
        'request_id': requestId,
        'patient_id': _userId,
        'requester_name': request.requesterName,
        'requester_specialty': request.requesterSpecialty,
        'data_scope': scope,
        'purpose': request.purpose,
        'access_type': request.accessType,
        'valid_till': validTill.toIso8601String(),
      };
      final insertResult = await _supabase.from('consents').insert(consentInsert).select('id').single();
      final consentId = insertResult['id'] as String;

      // 3. Blockchain: Hash and anchor the consent artifact
      await BlockchainService.anchorConsent(
        consentId: consentId,
        consentData: {
          'consent_id': consentId,
          'patient_id': _userId,
          'requester_name': request.requesterName,
          'data_scope': scope,
          'purpose': request.purpose,
          'valid_from': DateTime.now().toIso8601String(),
          'valid_till': validTill.toIso8601String(),
        },
      );

      // 4. Update request status
      await _supabase
          .from('consent_requests')
          .update({'status': 'approved', 'responded_at': DateTime.now().toIso8601String()})
          .eq('id', requestId);

      // 5. Log the action
      await _logAction(
        action: 'GRANT',
        actorName: 'You',
        details: 'Granted ${request.requesterName} access to ${scope.join(", ")} for $duration days [Hash Anchored ✓]',
        recordType: scope.first,
      );

      await refreshAll();
    } catch (e) {
      debugPrint('Error approving request: $e');
    }
  }

  Future<void> denyRequest(String requestId) async {
    if (_userId == null) return;
    try {
      final request = _pendingRequests.firstWhere((r) => r.id == requestId);

      await _supabase
          .from('consent_requests')
          .update({'status': 'denied', 'responded_at': DateTime.now().toIso8601String()})
          .eq('id', requestId);

      await _logAction(
        action: 'DENY',
        actorName: 'You',
        details: 'Denied ${request.requesterName} access to ${request.dataScope.join(", ")}',
      );

      await refreshAll();
    } catch (e) {
      debugPrint('Error denying request: $e');
    }
  }

  Future<void> revokeConsent(String consentId) async {
    if (_userId == null) return;
    try {
      final consent = _activeConsents.firstWhere((c) => c.id == consentId);

      await _supabase
          .from('consents')
          .update({'status': 'revoked', 'revoked_at': DateTime.now().toIso8601String()})
          .eq('id', consentId);

      await _logAction(
        action: 'REVOKE',
        actorName: 'You',
        details: 'Revoked ${consent.requesterName}\'s access to ${consent.dataScope.join(", ")}',
      );

      await refreshAll();
    } catch (e) {
      debugPrint('Error revoking consent: $e');
    }
  }

  // ─── Audit Logging ────────────────────────────────────

  Future<void> _logAction({
    required String action,
    required String actorName,
    String? details,
    String? recordType,
    String? consentId,
    String? recordId,
  }) async {
    if (_userId == null) return;
    try {
      await _supabase.from('access_logs').insert({
        'patient_id': _userId,
        'actor_name': actorName,
        'action': action,
        'record_type': recordType,
        'details': details,
        'consent_id': consentId,
        if (recordId != null) 'record_id': recordId,
      });
    } catch (e) {
      debugPrint('Error logging action: $e');
    }
  }

  // ─── Data Records ─────────────────────────────────────

  Future<void> uploadRecord({
    required String recordType,
    required String title,
    String? description,
    String? fileUrl,
    Map<String, dynamic>? metadata,
  }) async {
    if (_userId == null) return;
    try {
      // 1. Initialize user encryption keys
      final keys = await CryptoService.initializeUserKeys();

      // 2. Encrypt metadata if provided
      String? encryptedMetadata;
      if (metadata != null) {
        encryptedMetadata = CryptoService.encryptJson(metadata, keys['key']!, keys['iv']!);
      }

      // 3. Generate integrity hash
      final integrityData = '$title|$recordType|${fileUrl ?? ''}|${DateTime.now().toIso8601String()}';
      final fileHash = CryptoService.sha256Hash(integrityData);

      // 4. Insert encrypted record
      final insertResult = await _supabase.from('data_records').insert({
        'user_id': _userId,
        'record_type': recordType,
        'title': title,
        'description': description,
        'file_url': fileUrl,
        'file_hash': fileHash,
        'metadata': encryptedMetadata != null ? {'encrypted': encryptedMetadata} : metadata,
      }).select('id').single();

      // 5. Anchor record hash on blockchain
      await BlockchainService.anchorRecord(
        recordId: insertResult['id'],
        recordData: integrityData,
      );

      // 6. Log the upload
      await _logAction(
        action: 'UPLOAD',
        actorName: 'You',
        details: 'Uploaded $title ($recordType) [Encrypted ✓] [Hash: ${fileHash.substring(0, 12)}...]',
        recordType: recordType,
      );

      await fetchRecordCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error uploading record: $e');
    }
  }

  // ─── Consent Validation (for HIU access) ──────────────

  Future<bool> validateConsent(String consentId) async {
    try {
      final data = await _supabase
          .from('consents')
          .select()
          .eq('id', consentId)
          .eq('status', 'approved')
          .single();

      final validTill = DateTime.parse(data['valid_till']);
      return DateTime.now().isBefore(validTill);
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _requestSubscription?.unsubscribe();
    super.dispose();
  }
}
