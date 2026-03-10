import 'dart:async';
import 'bluetooth_service_stub.dart'
    if (dart.library.js) 'bluetooth_service_web.dart'
    if (dart.library.io) 'bluetooth_service_mobile.dart';

abstract class BluetoothService {
  factory BluetoothService() => instance;

  static BluetoothService? _instance;
  
  static BluetoothService get instance {
    _instance ??= getBluetoothService();
    return _instance!;
  }

  Stream<Map<String, dynamic>> get vitalsStream;
  String get connectedDeviceName;
  bool get isConnected;
  bool get isBluetoothAvailable;

  Future<bool> requestDevice();
  Future<bool> connect();
  Future<void> disconnect();
}
