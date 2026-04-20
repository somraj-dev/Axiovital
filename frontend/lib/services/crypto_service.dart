import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AES-256-CBC Encryption Service for AxioVital ABHA++
/// Handles: key generation, encrypt/decrypt, SHA-256 integrity hashing
class CryptoService {
  static const String _keyPrefKey = 'axio_user_encryption_key';
  static const String _ivPrefKey = 'axio_user_encryption_iv';

  /// Generate a cryptographically secure 256-bit (32 byte) key
  static Uint8List generateKey() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
  }

  /// Generate a random 128-bit (16 byte) IV
  static Uint8List generateIV() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(16, (_) => random.nextInt(256)));
  }

  /// Store encryption key securely in device preferences
  /// In production, use flutter_secure_storage instead
  static Future<void> storeUserKey(Uint8List key, Uint8List iv) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPrefKey, base64Encode(key));
    await prefs.setString(_ivPrefKey, base64Encode(iv));
  }

  /// Retrieve stored encryption key
  static Future<Map<String, Uint8List>?> getUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    final keyStr = prefs.getString(_keyPrefKey);
    final ivStr = prefs.getString(_ivPrefKey);
    if (keyStr == null || ivStr == null) return null;
    return {
      'key': base64Decode(keyStr),
      'iv': base64Decode(ivStr),
    };
  }

  /// Initialize user keys (generate if not exists)
  static Future<Map<String, Uint8List>> initializeUserKeys() async {
    final existing = await getUserKey();
    if (existing != null) return existing;

    final key = generateKey();
    final iv = generateIV();
    await storeUserKey(key, iv);
    return {'key': key, 'iv': iv};
  }

  /// Encrypt plaintext using AES-256-CBC
  static String encryptData(String plaintext, Uint8List keyBytes, Uint8List ivBytes) {
    try {
      final key = encrypt.Key(keyBytes);
      final iv = encrypt.IV(ivBytes);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final encrypted = encrypter.encrypt(plaintext, iv: iv);
      return encrypted.base64;
    } catch (e) {
      debugPrint('Encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt ciphertext using AES-256-CBC
  static String decryptData(String ciphertext, Uint8List keyBytes, Uint8List ivBytes) {
    try {
      final key = encrypt.Key(keyBytes);
      final iv = encrypt.IV(ivBytes);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final decrypted = encrypter.decrypt64(ciphertext, iv: iv);
      return decrypted;
    } catch (e) {
      debugPrint('Decryption error: $e');
      rethrow;
    }
  }

  /// Encrypt a JSON map (for consent artifacts, health records, etc.)
  static String encryptJson(Map<String, dynamic> data, Uint8List keyBytes, Uint8List ivBytes) {
    final jsonString = jsonEncode(data);
    return encryptData(jsonString, keyBytes, ivBytes);
  }

  /// Decrypt back to a JSON map
  static Map<String, dynamic> decryptJson(String ciphertext, Uint8List keyBytes, Uint8List ivBytes) {
    final jsonString = decryptData(ciphertext, keyBytes, ivBytes);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Generate SHA-256 hash for integrity verification
  static String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hash a consent artifact for blockchain anchoring
  static String hashConsentArtifact(Map<String, dynamic> artifact) {
    // Canonical JSON serialization (sorted keys for deterministic hashing)
    final sortedKeys = artifact.keys.toList()..sort();
    final canonicalMap = {for (var k in sortedKeys) k: artifact[k]};
    final canonicalJson = jsonEncode(canonicalMap);
    return sha256Hash(canonicalJson);
  }

  /// Verify data integrity by comparing hash
  static bool verifyIntegrity(String data, String expectedHash) {
    return sha256Hash(data) == expectedHash;
  }
}
