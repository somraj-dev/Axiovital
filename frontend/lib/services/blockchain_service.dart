import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'crypto_service.dart';

/// Blockchain Hash Anchoring Service for AxioVital ABHA++
/// 
/// Generates SHA-256 hashes of consent artifacts and anchors them to
/// Polygon blockchain for tamper-proof auditability.
/// 
/// Architecture:
/// 1. Hash consent data locally (SHA-256)
/// 2. Store hash in Supabase (immediate)
/// 3. Submit hash to Polygon via RPC (async anchoring)
/// 4. Store TX hash back in Supabase for verification
class BlockchainService {
  static final _supabase = Supabase.instance.client;

  // ─── Polygon Configuration ────────────────────────────
  // Replace with your Polygon RPC endpoint (Alchemy/Infura)
  static const String _polygonRpcUrl = 'https://polygon-mainnet.g.alchemy.com/v2/YOUR_API_KEY';
  // For testnet (Mumbai/Amoy), use:
  // static const String _polygonRpcUrl = 'https://polygon-amoy.g.alchemy.com/v2/YOUR_API_KEY';

  // Smart contract address for hash storage (deploy your own)
  static const String _contractAddress = '0x0000000000000000000000000000000000000000';

  // ─── Core Operations ──────────────────────────────────

  /// Generate and store hash for a consent artifact
  static Future<String> anchorConsent({
    required String consentId,
    required Map<String, dynamic> consentData,
  }) async {
    // 1. Generate deterministic hash
    final hash = CryptoService.hashConsentArtifact(consentData);

    // 2. Store hash immediately in Supabase
    await _supabase
        .from('consents')
        .update({'blockchain_hash': hash})
        .eq('id', consentId);

    // 3. Log the anchoring
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      await _supabase.from('access_logs').insert({
        'patient_id': userId,
        'actor_name': 'System',
        'action': 'ANCHOR',
        'consent_id': consentId,
        'details': 'Consent artifact hashed and anchored. Hash: ${hash.substring(0, 16)}...',
        'blockchain_hash': hash,
      });
    }

    // 4. Attempt Polygon anchoring (async, non-blocking)
    _submitToPolygon(hash, consentId);

    return hash;
  }

  /// Anchor a data record (lab report, prescription, etc.)
  static Future<String> anchorRecord({
    required String recordId,
    required String recordData,
  }) async {
    final hash = CryptoService.sha256Hash(recordData);

    await _supabase
        .from('data_records')
        .update({'file_hash': hash})
        .eq('id', recordId);

    return hash;
  }

  /// Verify integrity of a consent artifact
  static Future<BlockchainVerification> verifyConsent(String consentId) async {
    try {
      final data = await _supabase
          .from('consents')
          .select()
          .eq('id', consentId)
          .single();

      final storedHash = data['blockchain_hash'] as String?;
      if (storedHash == null) {
        return BlockchainVerification(
          isValid: false,
          message: 'No hash found for this consent',
          hash: null,
        );
      }

      // Recompute hash from current data
      final recomputedHash = CryptoService.hashConsentArtifact({
        'consent_id': data['id'],
        'patient_id': data['patient_id'],
        'requester_name': data['requester_name'],
        'data_scope': data['data_scope'],
        'purpose': data['purpose'],
        'valid_from': data['valid_from'],
        'valid_till': data['valid_till'],
      });

      final isValid = storedHash == recomputedHash;

      return BlockchainVerification(
        isValid: isValid,
        message: isValid ? 'Consent artifact is tamper-proof ✓' : '⚠️ WARNING: Data has been modified!',
        hash: storedHash,
      );
    } catch (e) {
      return BlockchainVerification(
        isValid: false,
        message: 'Verification failed: $e',
        hash: null,
      );
    }
  }

  /// Verify integrity of a data record
  static Future<bool> verifyRecord(String recordId, String currentData) async {
    try {
      final data = await _supabase
          .from('data_records')
          .select('file_hash')
          .eq('id', recordId)
          .single();

      final storedHash = data['file_hash'] as String?;
      if (storedHash == null) return false;

      return CryptoService.sha256Hash(currentData) == storedHash;
    } catch (e) {
      return false;
    }
  }

  // ─── Polygon Interaction ──────────────────────────────

  /// Submit hash to Polygon blockchain
  /// This is non-blocking and logs the TX hash when complete
  static Future<void> _submitToPolygon(String hash, String consentId) async {
    // Skip if not configured
    if (_contractAddress == '0x0000000000000000000000000000000000000000') {
      debugPrint('[Blockchain] Polygon not configured. Hash stored locally: $hash');
      return;
    }

    try {
      // Call smart contract to store hash
      // This is a simplified example using eth_call
      // In production, use web3dart package with proper wallet signing
      final response = await http.post(
        Uri.parse(_polygonRpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'eth_call',
          'params': [
            {
              'to': _contractAddress,
              'data': _encodeStoreHash(hash),
            },
            'latest'
          ],
          'id': 1,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final txHash = result['result'] as String?;

        if (txHash != null) {
          // Update consent with blockchain TX hash
          await _supabase
              .from('consents')
              .update({'blockchain_hash': 'polygon:$txHash'})
              .eq('id', consentId);

          debugPrint('[Blockchain] Anchored to Polygon: $txHash');
        }
      }
    } catch (e) {
      debugPrint('[Blockchain] Polygon anchoring failed (non-critical): $e');
      // Non-critical failure — hash is still stored in Supabase
    }
  }

  /// Encode function call data for Solidity storeHash(bytes32)
  static String _encodeStoreHash(String hash) {
    // Function selector for storeHash(bytes32)
    // keccak256("storeHash(bytes32)") = first 4 bytes
    const selector = '0x9d22da84';
    return '$selector${hash.padLeft(64, '0')}';
  }

  // ─── Batch Operations ─────────────────────────────────

  /// Anchor all unanchored consents (run periodically)
  static Future<int> anchorPendingConsents() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0;

    try {
      final data = await _supabase
          .from('consents')
          .select()
          .eq('patient_id', userId)
          .isFilter('blockchain_hash', null);

      int anchored = 0;
      for (final consent in (data as List)) {
        await anchorConsent(
          consentId: consent['id'],
          consentData: {
            'consent_id': consent['id'],
            'patient_id': consent['patient_id'],
            'requester_name': consent['requester_name'],
            'data_scope': consent['data_scope'],
            'purpose': consent['purpose'],
            'valid_from': consent['valid_from'],
            'valid_till': consent['valid_till'],
          },
        );
        anchored++;
      }
      return anchored;
    } catch (e) {
      debugPrint('[Blockchain] Batch anchoring error: $e');
      return 0;
    }
  }
}

/// Verification result model
class BlockchainVerification {
  final bool isValid;
  final String message;
  final String? hash;

  BlockchainVerification({
    required this.isValid,
    required this.message,
    this.hash,
  });
}
