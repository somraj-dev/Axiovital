import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'bluetooth_provider.dart';
import 'bluetooth_scan_page.dart';

class DeviceConnectivityPage extends StatelessWidget {
  const DeviceConnectivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final btProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1721), // Dark navy background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Device Connectivity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BluetoothScanPage()));
        },
        backgroundColor: const Color(0xFF4B89FF),
        icon: const Icon(Icons.bluetooth_searching, color: Colors.white),
        label: const Text('Scan Devices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model Accuracy Card
            _buildAccuracyCard(),
            const SizedBox(height: 32),

            // Bluetooth Connected Devices
            if (btProvider.isConnected) ...[
              const Text(
                'Connected Health Devices',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildConnectedDeviceCard(btProvider, context),
              const SizedBox(height: 32),
            ],

            // Compatible Platforms
            const Text(
              'Compatible Platforms',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildPlatformCard('Apple Health', 'Last synced: 2m ago', Icons.favorite, const Color(0xFFFF4B4B), true),
                _buildPlatformCard('Google Fit', 'Not connected', Icons.fitness_center, const Color(0xFF4B89FF), false),
                _buildPlatformCard('Fitbit', 'Syncing...', Icons.watch, const Color(0xFF00B294), true, isSyncing: true),
                _buildPlatformCard('Dexcom', 'Last synced: 1h ago', Icons.opacity, const Color(0xFFFF7E3D), true),
              ],
            ),
            const SizedBox(height: 32),

            // Metric Customization
            const Text(
              'Metric Customization',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _buildMetricTile('Heart Rate', Icons.favorite_border, true),
            _buildMetricTile('Sleep Analysis', Icons.nightlight_outlined, true),
            _buildMetricTile('Blood Glucose', Icons.opacity, true),
            _buildMetricTile('Activity & Steps', Icons.directions_run, false),
            
            const SizedBox(height: 40),
            
            // Privacy & Security
            const Text(
              'PRIVACY & SECURITY',
              style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Who can see my data?',
                  style: TextStyle(color: Color(0xFF4B89FF), fontWeight: FontWeight.w600),
                ),
                Icon(Icons.open_in_new, color: Colors.white.withOpacity(0.3), size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Color(0xFF00B294), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All biometric data is end-to-end encrypted and HIPAA compliant.',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.analytics_outlined, color: Color(0xFF4B89FF), size: 32),
              const SizedBox(width: 12),
              const Text(
                '98%',
                style: TextStyle(color: Color(0xFF4B89FF), fontSize: 48, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const Center(
            child: Text(
              'MODEL ACCURACY',
              style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Digital Twin is 98% accurate',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your real-time data integration.',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF00B294), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Signal Strength: Excellent',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B89FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPlatformCard(String name, String status, IconData icon, Color iconColor, bool isConnected, {bool isSyncing = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              CupertinoSwitch(
                value: isConnected,
                onChanged: (v) {},
                activeColor: const Color(0xFF4B89FF),
                trackColor: Colors.white.withOpacity(0.1),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: isSyncing ? const Color(0xFF4B89FF) : Colors.white.withOpacity(0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, IconData icon, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4B89FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4B89FF), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          CupertinoCheckbox(
            value: value,
            onChanged: (v) {},
            activeColor: const Color(0xFF4B89FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedDeviceCard(BluetoothProvider bt, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4B89FF).withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bluetooth_connected, color: Color(0xFF4B89FF)),
                  const SizedBox(width: 8),
                  Text(
                    bt.deviceName.isNotEmpty ? bt.deviceName : 'Unknown Device',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  bt.disconnect();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Disconnect', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('LIVE VITALS', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLiveMetric(Icons.favorite, 'HR', bt.heartRate > 0 ? '${bt.heartRate}' : '--', 'bpm', const Color(0xFFED4245)),
              _buildLiveMetric(Icons.air, 'SpO2', bt.spo2 > 0 ? '${bt.spo2}' : '--', '%', const Color(0xFF22C55E)),
              _buildLiveMetric(Icons.bloodtype, 'BP', (bt.systolicBP > 0 && bt.diastolicBP > 0) ? '${bt.systolicBP}/${bt.diastolicBP}' : '--', 'mmHg', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetric(IconData icon, String label, String val, String unit, Color c) {
    return Column(
      children: [
        Icon(icon, color: c, size: 20),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}
