import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:math';

class ScanDurationSheet extends StatefulWidget {
  final String? sourceDevice;
  final String? destinationDevice;
  final String fileTypes;

  const ScanDurationSheet({
    super.key,
    this.sourceDevice,
    this.destinationDevice,
    this.fileTypes = "Health Profile, Emergency Contacts",
  });

  @override
  State<ScanDurationSheet> createState() => _ScanDurationSheetState();
}

class _ScanDurationSheetState extends State<ScanDurationSheet> {
  double _progress = 0.0;
  bool _isPaused = false;
  Timer? _timer;
  
  late String _currentSourceDevice;
  late IconData _currentSourceIcon;
  late String _currentDestDevice;
  late IconData _currentDestIcon;

  @override
  void initState() {
    super.initState();
    _resolveDevices();
    _startSimulatedTransfer();
  }

  void _resolveDevices() {
    // Dynamically identify the local OS
    if (widget.sourceDevice != null) {
      _currentSourceDevice = widget.sourceDevice!;
      _currentSourceIcon = Icons.smartphone;
    } else {
      if (kIsWeb) {
        _currentSourceDevice = "Web Browser";
        _currentSourceIcon = Icons.language;
      } else if (Platform.isAndroid) {
        _currentSourceDevice = "Android Phone";
        _currentSourceIcon = Icons.smartphone;
      } else if (Platform.isIOS) {
        _currentSourceDevice = "iPhone";
        _currentSourceIcon = Icons.phone_iphone;
      } else if (Platform.isMacOS) {
        _currentSourceDevice = "MacBook";
        _currentSourceIcon = Icons.laptop_mac;
      } else if (Platform.isWindows) {
        _currentSourceDevice = "Windows PC";
        _currentSourceIcon = Icons.desktop_windows;
      } else {
        _currentSourceDevice = "Your Device";
        _currentSourceIcon = Icons.smartphone;
      }
    }

    // Dynamically mock the destination scanner device to simulate identifying who scanned it
    if (widget.destinationDevice != null) {
      _currentDestDevice = widget.destinationDevice!;
      _currentDestIcon = Icons.laptop_mac;
    } else {
      final mockScanners = [
        {"name": "Dr. Sarah's iPad", "icon": Icons.tablet_mac},
        {"name": "ER Triage Desktop", "icon": Icons.desktop_windows},
        {"name": "Clinic MacBook Pro", "icon": Icons.laptop_mac},
        {"name": "Paramedic's Tablet", "icon": Icons.tablet_android},
      ];
      final randomScanner = mockScanners[Random().nextInt(mockScanners.length)];
      _currentDestDevice = randomScanner["name"] as String;
      _currentDestIcon = randomScanner["icon"] as IconData;
    }
  }

  void _startSimulatedTransfer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.05; // 0.05 * 20 ticks = 1.0 (2 seconds total)
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          // Auto-dismiss immediately on success
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile synced via QR scan.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
              );
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int percentage = (_progress * 100).toInt();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header
          const Text(
            'Smart      Transfer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 32),
          
          // Device Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDeviceColumn(_currentSourceIcon, _currentSourceDevice, "Sending from"),
              const SizedBox(width: 16),
              const Text('• • •', style: TextStyle(color: Colors.grey, fontSize: 18, letterSpacing: 4)),
              const SizedBox(width: 16),
              _buildDeviceColumn(_currentDestIcon, _currentDestDevice, "Sending to"),
            ],
          ),
          const SizedBox(height: 32),
          
          // Progress Section
          const Text(
            'Transfer progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your file transfer is $percentage% completed',
            style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          
          // Transfer Details Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.info_outline, size: 16, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Transfer Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Estimated Time Remaining', '12mins, 54Secs'), // Mocked static just like reference
                const SizedBox(height: 8),
                _buildDetailRow('Transfer Rate (Speed)', '20mb/Sec'),
                const SizedBox(height: 8),
                _buildDetailRow('File types', widget.fileTypes),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transfer Cancelled', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      if (_isPaused) {
                        _isPaused = false;
                        _startSimulatedTransfer();
                      } else {
                        _isPaused = true;
                        _timer?.cancel();
                      }
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _isPaused ? Colors.blueAccent : const Color(0xFF1E1E1E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(_isPaused ? 'Resume' : 'Pause', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shield_outlined, size: 16, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                'Your transfer is encrypted and secure',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceColumn(IconData icon, String deviceName, String actionLabel) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Colors.black45),
        const SizedBox(height: 12),
        Text(actionLabel, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        Text(deviceName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
