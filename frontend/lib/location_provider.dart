import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
  
  Position? _currentPosition;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionSubscription;
  DateTime? _lastSyncTime;
  final String _userId = 'VS-99283'; // Fixed for demo user

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;

  LocationProvider() {
    // Optionally start tracking automatically if permissions allow
    // _startTracking();
  }

  Future<void> updatePositionOnce() async {
    final pos = await _locationService.getCurrentPosition();
    if (pos != null) {
      _currentPosition = pos;
      notifyListeners();
      await _syncLocationToBackend(pos);
    }
  }

  void toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() async {
    final status = await _locationService.checkLocationStatus();
    if (status != 'enabled') return;

    _isTracking = true;
    notifyListeners();

    _positionSubscription = _locationService.locationStream.listen((Position position) {
      _currentPosition = position;
      notifyListeners();
      _throttleSync(position);
    });
  }

  void _stopTracking() {
    _positionSubscription?.cancel();
    _isTracking = false;
    notifyListeners();
  }

  void _throttleSync(Position position) {
    final now = DateTime.now();
    // Sync at most once every 30 seconds to save battery/bandwidth
    if (_lastSyncTime == null || now.difference(_lastSyncTime!).inSeconds >= 30) {
      _lastSyncTime = now;
      _syncLocationToBackend(position);
    }
  }

  Future<void> _syncLocationToBackend(Position position) async {
    try {
      await _dio.post('/api/v1/location', data: {
        'user_id': _userId,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
      print('Location synced to backend: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error syncing location: $e');
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
