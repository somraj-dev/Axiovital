import 'dart:async';
import 'bluetooth_service.dart';

BluetoothService getBluetoothService() => BluetoothServiceMobile();

class BluetoothServiceMobile implements BluetoothService {
  final StreamController<Map<String, dynamic>> _vitalsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
      
  @override
  Stream<Map<String, dynamic>> get vitalsStream => _vitalsStreamController.stream;

  @override
  String get connectedDeviceName => '';

  @override
  bool get isConnected => false;

  @override
  bool get isBluetoothAvailable => false;

  @override
  Future<bool> requestDevice() async {
    // Stub for now to fix build. 
    // Real mobile implementation would use flutter_blue_plus.
    return false;
  }

  @override
  Future<bool> connect() async => false;

  @override
  Future<void> disconnect() async {}
}
