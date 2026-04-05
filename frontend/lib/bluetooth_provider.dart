import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BluetoothProvider extends ChangeNotifier {
  bool _isConnected = false;
  bool _isConnecting = false;
  String _deviceName = '';
  
  int _heartRate = 72;
  int _systolicBP = 120;
  int _diastolicBP = 80;
  int _spo2 = 98;
  double _glucose = 95.0;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String get deviceName => _deviceName;
  
  int get heartRate => _heartRate;
  int get systolicBP => _systolicBP;
  int get diastolicBP => _diastolicBP;
  int get spo2 => _spo2;
  double get glucose => _glucose;

  Timer? _vitalsTimer;

  void connectToDevice(String name) async {
    _isConnecting = true;
    _deviceName = name;
    notifyListeners();

    // Mock connection delay
    await Future.delayed(const Duration(seconds: 2));
    
    _isConnected = true;
    _isConnecting = false;
    _startVitalsSimulation();
    notifyListeners();
  }

  void disconnect() {
    _isConnected = false;
    _deviceName = '';
    _vitalsTimer?.cancel();
    notifyListeners();
  }

  void _startVitalsSimulation() {
    _vitalsTimer?.cancel();
    _vitalsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final random = Random();
      _heartRate = 70 + random.nextInt(10);
      _systolicBP = 115 + random.nextInt(10);
      _diastolicBP = 75 + random.nextInt(10);
      _spo2 = 97 + random.nextInt(3);
      _glucose = 90 + random.nextDouble() * 10;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _vitalsTimer?.cancel();
    super.dispose();
  }
}
