import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'bluetooth_service.dart';

class BluetoothProvider extends ChangeNotifier {
  final BluetoothService _btService = BluetoothService();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

  // Connection state
  bool _isConnected = false;
  bool _isConnecting = false;
  String _deviceName = '';
  final String _userId = 'VS-99283'; // Fixed for now to match seeded user

  // Vitals State
  int _heartRate = 0;
  int _systolicBP = 0;
  int _diastolicBP = 0;
  int _spo2 = 0;
  int _glucose = 0;

  StreamSubscription? _vitalsSub;
  DateTime? _lastSyncTime;

  BluetoothProvider() {
    _initVitalsListener();
  }

  void _initVitalsListener() {
    _vitalsSub = _btService.vitalsStream.listen((data) {
      bool changed = false;
      if (data.containsKey('heartRate') && _heartRate != data['heartRate']) {
        _heartRate = data['heartRate'];
        changed = true;
      }
      if (data.containsKey('systolicBP') && _systolicBP != data['systolicBP']) {
        _systolicBP = data['systolicBP'];
        changed = true;
      }
      if (data.containsKey('diastolicBP') && _diastolicBP != data['diastolicBP']) {
        _diastolicBP = data['diastolicBP'];
        changed = true;
      }
      if (data.containsKey('spo2') && _spo2 != data['spo2']) {
        _spo2 = data['spo2'];
        changed = true;
      }
      if (data.containsKey('glucose') && _glucose != data['glucose']) {
        _glucose = data['glucose'];
        changed = true;
      }
      
      if (changed) {
        notifyListeners();
        _syncIfThrottled();
      }
    });
  }

  void _syncIfThrottled() {
    final now = DateTime.now();
    if (_lastSyncTime == null || now.difference(_lastSyncTime!).inSeconds >= 5) {
      _lastSyncTime = now;
      _syncVitalsToBackend();
    }
  }

  Future<void> _syncVitalsToBackend() async {
    try {
      await _dio.post('/api/v1/vitals', data: {
        'user_id': _userId,
        'heart_rate': _heartRate > 0 ? _heartRate : null,
        'systolic_bp': _systolicBP > 0 ? _systolicBP : null,
        'diastolic_bp': _diastolicBP > 0 ? _diastolicBP : null,
        'spo2': _spo2 > 0 ? _spo2 : null,
        'glucose': _glucose > 0 ? _glucose : null,
      });
      print('Vitals synced to backend');
    } catch (e) {
      print('Error syncing vitals: $e');
    }
  }

  // Getters
  int get heartRate => _heartRate;
  int get systolicBP => _systolicBP;
  int get diastolicBP => _diastolicBP;
  int get spo2 => _spo2;
  int get glucose => _glucose;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String get deviceName => _deviceName;
  bool get isBluetoothAvailable => _btService.isBluetoothAvailable;

  /// Opens the browser's Bluetooth device picker, then connects.
  Future<bool> scanAndConnect() async {
    _isConnecting = true;
    notifyListeners();

    try {
      final success = await _btService.requestDevice();
      if (!success) {
        _isConnecting = false;
        notifyListeners();
        return false;
      }

      _deviceName = _btService.connectedDeviceName;
      notifyListeners();

      final connected = await _btService.connect();
      _isConnected = connected;
      _isConnecting = false;
      notifyListeners();
      return connected;
    } catch (e) {
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    await _btService.disconnect();
    _isConnected = false;
    _isConnecting = false;
    _deviceName = '';
    _heartRate = 0;
    _systolicBP = 0;
    _diastolicBP = 0;
    _spo2 = 0;
    _glucose = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _vitalsSub?.cancel();
    super.dispose();
  }
}
