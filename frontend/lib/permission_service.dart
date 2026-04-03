import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Checks and requests location permission with a custom rationale dialog.
  Future<bool> requestLocationPermission(BuildContext context) async {
    // 1. Check if service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool? openSettings = await _showRationaleDialog(
        context,
        title: 'Location Services Disabled',
        message: 'Axiovital needs GPS to help you find nearby doctors and update your clinical address. Please enable it in settings.',
        icon: Icons.location_off,
        buttonText: 'Open Settings',
      );
      if (openSettings == true) {
        await Geolocator.openLocationSettings();
      }
      return false;
    }

    // 2. Check permission status
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;

    // 3. Show rationale if denied once
    if (status.isDenied) {
      bool? proceed = await _showRationaleDialog(
        context,
        title: 'Location Access',
        message: 'Your location is used to provide clinical context for your health data and to automatically populate your address.',
        icon: Icons.location_on,
      );
      if (proceed != true) return false;
    }

    // 4. Request
    status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// Requests notification permissions.
  Future<bool> requestNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;
    if (status.isGranted) return true;

    bool? proceed = await _showRationaleDialog(
      context,
      title: 'Stay Informed',
      message: 'Enable notifications to receive alerts about your health sync status and doctor appointments.',
      icon: Icons.notifications_active,
    );
    
    if (proceed == true) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  /// Requests gallery/storage permission for avatar or reports.
  Future<bool> requestFilePermission(BuildContext context) async {
    var status = await Permission.photos.status; // iOS usage
    if (await Permission.storage.isGranted || status.isGranted) return true;

    bool? proceed = await _showRationaleDialog(
      context,
      title: 'File Access',
      message: 'Axiovital needs access to your files to let you upload health reports and update your profile picture.',
      icon: Icons.folder,
    );
    
    if (proceed == true) {
      if (await Permission.photos.request().isGranted || await Permission.storage.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  Future<bool?> _showRationaleDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    String buttonText = 'Continue',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF2E90FA)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Color(0xFF667085))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Maybe Later', style: TextStyle(color: Color(0xFF667085))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E90FA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
