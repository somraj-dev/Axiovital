import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bluetooth_provider.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startScan(BuildContext context) async {
    final btProvider = Provider.of<BluetoothProvider>(context, listen: false);

    if (!btProvider.isBluetoothAvailable) {
      setState(() {
        _statusMessage =
            'Bluetooth is not available in this browser.\nTry Chrome or Edge on a desktop with Bluetooth hardware.';
      });
      return;
    }

    setState(() => _statusMessage = 'Opening device picker...');

    final success = await btProvider.scanAndConnect();

    if (success && mounted) {
      Navigator.pop(context); // Go back after successful connection
    } else if (mounted) {
      setState(() {
        _statusMessage = btProvider.deviceName.isNotEmpty
            ? 'Failed to connect to ${btProvider.deviceName}. Try again.'
            : 'No device selected. Tap the button to try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final btProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1721),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pair Device',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Animated Pulse Rings + Bluetooth Icon
              SizedBox(
                height: 220,
                width: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(220, 220),
                          painter: _PulseRingPainter(
                            _pulseController.value,
                            btProvider.isConnecting,
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: btProvider.isConnecting
                            ? const Color(0xFF4B89FF)
                            : const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4B89FF).withOpacity(0.4),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4B89FF).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Icon(
                        btProvider.isConnecting
                            ? Icons.bluetooth_searching
                            : Icons.bluetooth,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Title
              Text(
                btProvider.isConnecting
                    ? 'Connecting...'
                    : 'Connect a Health Device',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Pair your BP monitor, pulse oximeter, smartwatch, or fitness band. '
                  'Your browser will open a device picker — select your device to connect.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Scan Button
              if (!btProvider.isConnecting)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _startScan(context),
                    icon: const Icon(Icons.bluetooth_searching,
                        color: Colors.white, size: 22),
                    label: const Text(
                      'Scan for Devices',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B89FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),

              // Loading spinner while connecting
              if (btProvider.isConnecting) ...[
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Color(0xFF4B89FF),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Connecting to ${btProvider.deviceName}...',
                  style:
                      TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              ],

              // Status message
              if (_statusMessage.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF4B89FF), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 48),

              // Supported devices section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SUPPORTED DEVICE TYPES',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDeviceType(Icons.favorite, 'Heart Rate\nMonitor', const Color(0xFFED4245)),
                  _buildDeviceType(Icons.bloodtype, 'Blood\nPressure', const Color(0xFFF59E0B)),
                  _buildDeviceType(Icons.air, 'Pulse\nOximeter', const Color(0xFF22C55E)),
                  _buildDeviceType(Icons.watch, 'Smart\nWatch', const Color(0xFF4B89FF)),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceType(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PulseRingPainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _PulseRingPainter(this.progress, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      double ringProgress = (progress + (i * 0.33)) % 1.0;
      double radius = maxRadius * ringProgress;
      double opacity = (1.0 - ringProgress) * (isActive ? 0.6 : 0.2);

      final strokePaint = Paint()
        ..color = const Color(0xFF4B89FF).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, strokePaint);

      final fillPaint = Paint()
        ..color = const Color(0xFF4B89FF).withOpacity(opacity * 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingPainter old) =>
      old.progress != progress || old.isActive != isActive;
}
