import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Checks and requests location permissions.
  /// Returns a status string: 'enabled', 'disabled', 'denied', 'permanently_denied'
  Future<String> checkLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'permanently_denied';
    }

    return 'enabled';
  }

  /// Gets the current position with aggressive optimization.
  Future<Position?> getCurrentPosition() async {
    final status = await checkLocationStatus();
    if (status != 'enabled') return null;

    try {
      // 1. Try to get last known position first (Instantaneous)
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        // If last position is recent (within 1 min), return it immediately
        final diff = DateTime.now().difference(lastPosition.timestamp);
        if (diff.inMinutes < 1) return lastPosition;
      }

      // 2. Otherwise get fresh position with a tight timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Medium is faster than High
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Error getting location: $e');
      // Final attempt with low accuracy if high/medium failed
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 3),
        );
      } catch (_) {
        return null;
      }
    }
  }

  /// Streams real-time location updates.
  Stream<Position> get locationStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }
}
