import 'dart:async';
import 'dart:js' as js;
import 'dart:typed_data';

/// Web Bluetooth API service using dart:js for broad compatibility.
/// Handles scanning, connecting, and reading health GATT characteristics.
class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  final StreamController<Map<String, dynamic>> _vitalsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get vitalsStream => _vitalsStreamController.stream;

  js.JsObject? _device;
  js.JsObject? _server;
  String _deviceName = '';

  String get connectedDeviceName => _deviceName;
  bool get isConnected => _server != null;

  bool get isBluetoothAvailable {
    try {
      final nav = js.context['navigator'];
      return nav != null && nav['bluetooth'] != null;
    } catch (_) {
      return false;
    }
  }

  /// Requests a device via the browser's Bluetooth picker.
  Future<bool> requestDevice() async {
    try {
      final bluetooth = js.context['navigator']['bluetooth'];
      if (bluetooth == null) return false;

      // Build the options
      final options = js.JsObject.jsify({
        'acceptAllDevices': true,
        'optionalServices': ['heart_rate', 'blood_pressure', '00001822-0000-1000-8000-00805f9b34fb'],
      });

      final promise = bluetooth.callMethod('requestDevice', [options]);
      final device = await _promiseToFuture(promise);
      
      if (device == null) return false;

      _device = device as js.JsObject;
      _deviceName = _device!['name']?.toString() ?? 'Unknown Device';
      return true;
    } catch (e) {
      print('Error requesting device: $e');
      return false;
    }
  }

  /// Connects to the GATT server on the selected device.
  Future<bool> connect() async {
    if (_device == null) return false;

    try {
      final gatt = _device!['gatt'];
      if (gatt == null) return false;

      final promise = gatt.callMethod('connect', []);
      final server = await _promiseToFuture(promise);
      
      if (server == null) return false;

      _server = server as js.JsObject;
      await _subscribeToServices();
      return true;
    } catch (e) {
      print('Error connecting: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      _server?.callMethod('disconnect', []);
    } catch (_) {}
    _server = null;
    _device = null;
    _deviceName = '';
  }

  Future<void> _subscribeToServices() async {
    if (_server == null) return;

    // Try Heart Rate service
    await _trySubscribeService('heart_rate', 'heart_rate_measurement', _parseHeartRate);

    // Try Blood Pressure service
    await _trySubscribeService('blood_pressure', 'blood_pressure_measurement', _parseBloodPressure);

    // Try SpO2 (Pulse Oximeter) service
    await _trySubscribeService(
      '00001822-0000-1000-8000-00805f9b34fb',
      '00002a5e-0000-1000-8000-00805f9b34fb',
      _parseSpO2,
    );
  }

  Future<void> _trySubscribeService(
    String serviceUuid,
    String charUuid,
    void Function(ByteData) parser,
  ) async {
    try {
      final servicePromise = _server!.callMethod('getPrimaryService', [serviceUuid]);
      final service = await _promiseToFuture(servicePromise) as js.JsObject?;
      if (service == null) return;

      final charPromise = service.callMethod('getCharacteristic', [charUuid]);
      final characteristic = await _promiseToFuture(charPromise) as js.JsObject?;
      if (characteristic == null) return;

      // Start notifications
      final notifyPromise = characteristic.callMethod('startNotifications', []);
      await _promiseToFuture(notifyPromise);

      // Listen for value changes
      characteristic.callMethod('addEventListener', [
        'characteristicvaluechanged',
        js.allowInterop((event) {
          try {
            final target = (event as js.JsObject)['target'] as js.JsObject;
            final dataView = target['value'];
            if (dataView != null) {
              // Extract bytes from the DataView
              final byteLength = dataView['byteLength'] as int;
              final bytes = List<int>.generate(byteLength, (i) {
                return dataView.callMethod('getUint8', [i]) as int;
              });
              parser(ByteData.sublistView(Uint8List.fromList(bytes)));
            }
          } catch (e) {
            print('Error processing characteristic value: $e');
          }
        }),
      ]);
    } catch (e) {
      // Service not available on this device — that's fine
      print('Service $serviceUuid not available: $e');
    }
  }

  void _parseHeartRate(ByteData data) {
    try {
      int flags = data.getUint8(0);
      bool is16Bit = (flags & 0x01) != 0;
      int hr = is16Bit ? data.getUint16(1, Endian.little) : data.getUint8(1);
      _vitalsStreamController.add({'heartRate': hr});
    } catch (e) {
      print('Error parsing heart rate: $e');
    }
  }

  void _parseBloodPressure(ByteData data) {
    try {
      if (data.lengthInBytes >= 5) {
        int systolic = data.getUint16(1, Endian.little);
        int diastolic = data.getUint16(3, Endian.little);
        if (systolic > 50 && systolic < 250 && diastolic > 30 && diastolic < 150) {
          _vitalsStreamController.add({
            'systolicBP': systolic,
            'diastolicBP': diastolic,
          });
        }
      }
    } catch (e) {
      print('Error parsing blood pressure: $e');
    }
  }

  void _parseSpO2(ByteData data) {
    try {
      if (data.lengthInBytes >= 3) {
        int spo2 = data.getUint16(1, Endian.little);
        if (spo2 <= 100) {
          _vitalsStreamController.add({'spo2': spo2});
        }
      }
    } catch (e) {
      print('Error parsing SpO2: $e');
    }
  }

  /// Convert a JS Promise to a Dart Future.
  Future<dynamic> _promiseToFuture(dynamic promise) {
    final completer = Completer<dynamic>();
    final jsPromise = promise as js.JsObject;
    
    jsPromise.callMethod('then', [
      js.allowInterop((result) {
        completer.complete(result);
      }),
    ]);
    jsPromise.callMethod('catch', [
      js.allowInterop((error) {
        completer.completeError(error.toString());
      }),
    ]);
    
    return completer.future;
  }
}
