import 'package:flutter/material.dart';
import 'device_connectivity_page.dart';
import 'vitalsync_dashboard.dart';
import 'update_profile_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    final String userName = userProvider.name;
    final String clinicalId = userProvider.clinicalId;
    final String avatarUrl = userProvider.avatarUrl;
    final String age = userProvider.age;
    final String weight = userProvider.weight;
    final String bloodGroup = userProvider.bloodGroup;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Light greyish background from screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF0F52FF)),
          label: const Text('Back', style: TextStyle(color: Color(0xFF0F52FF), fontSize: 16)),
        ),
        leadingWidth: 100,
        title: const Text(
          'Health Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfilePage()),
              );
            },
            child: const Text('Edit', style: TextStyle(color: Color(0xFF0F52FF), fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0F52FF), width: 3), // Blue ring
                      ),
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: -10,
                    right: 15,
                    left: 15,
                    child: _VerifiedBadge(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Name and ID
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'CLINICAL ID: $clinicalId',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            const SizedBox(height: 32),
            
            // Personal Metrics section header
            _buildSectionHeader('PERSONAL METRICS', hasInfo: true),
            const SizedBox(height: 12),
            
            // Metrics Cards
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard('Age', age, 'Years'),
                  _buildMetricCard('Weight', weight, 'kg'),
                  _buildMetricCard('Blood Group', bloodGroup, ''),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Health Activity Log
            _buildSectionHeader('HEALTH ACTIVITY LOG', suffixText: 'LATEST 12 MONTHS'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consistency Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Daily health check-ins & adherence', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  
                  // Mock Activity grid (GitHub commit style map)
                  _buildActivityGrid(),
                  const SizedBox(height: 16),
                  
                  // Legend and Compliance Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text('LESS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          _GridSquare(color: Color(0xFFF1F5F9)),
                          SizedBox(width: 4),
                          _GridSquare(color: Color(0xFFBBE5CD)),
                          SizedBox(width: 4),
                          _GridSquare(color: Color(0xFF22C55E)),
                          SizedBox(width: 4),
                          _GridSquare(color: Color(0xFF166534)),
                          SizedBox(width: 8),
                          Text('MORE', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.electric_bolt, color: Color(0xFF22C55E), size: 14),
                          SizedBox(width: 4),
                          Text('94% Compliance Rate', style: TextStyle(color: Color(0xFF22C55E), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Medical History
            _buildSectionHeader('MEDICAL HISTORY', suffixAction: '+ Add Record'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5)],
              ),
              child: Column(
                children: [
                  _buildListTile(icon: Icons.monitor_heart, title: 'Hypertension', subtitle: 'Diagnosed Feb 2022 • Stable'),
                  const SizedBox(height: 16),
                  _buildListTile(icon: Icons.air, title: 'Chronic Asthma', subtitle: 'Mild Persistent • Seasonal'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Allergy Alerts
            _buildSectionHeader('ALLERGY ALERTS'),
            const SizedBox(height: 12),
            _buildAlertCard(icon: Icons.warning_amber_rounded, title: 'Penicillin', subtitle: 'Anaphylaxis Risk • High Priority'),
            const SizedBox(height: 12),
            _buildAlertCard(icon: Icons.bug_report, title: 'Peanuts', subtitle: 'Severe reaction reported 2021'),
            
            const SizedBox(height: 32),
            
            // Connected Devices
            _buildSectionHeader('CONNECTED DEVICES'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131A2A), // Dark navy blue section
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VitalSyncDashboard()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.transparent, 
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(color: Color(0xFF1F2937), shape: BoxShape.circle),
                            child: const Icon(Icons.watch, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Smart Watch Series 9', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    const Text('Live sync active', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DeviceConnectivityPage()),
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              color: Colors.transparent,
                              child: const Icon(Icons.settings, color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildDeviceMetric(label: 'HEART RATE', value: '72', unit: 'BPM')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDeviceMetric(label: 'SLEEP SCORE', value: '88', unit: '/100')),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAECF0)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF667085), fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool hasInfo = false, String? suffixText, String? suffixAction}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
        if (hasInfo)
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.info, color: Color(0xFFCBD5E1), size: 16),
          ),
        const Spacer(),
        if (suffixText != null)
          Text(suffixText, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 11)),
        if (suffixAction != null)
          Text(suffixAction, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F52FF), fontSize: 12)),
      ],
    );
  }

  Widget _buildActivityGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          children: [
            Text('MON', style: TextStyle(fontSize: 8, color: Colors.grey)),
            SizedBox(height: 4),
            Text('WED', style: TextStyle(fontSize: 8, color: Colors.grey)),
            SizedBox(height: 4),
            Text('FRI', style: TextStyle(fontSize: 8, color: Colors.grey)),
            SizedBox(height: 4),
            Text('SUN', style: TextStyle(fontSize: 8, color: Colors.grey)),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 22,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemCount: 88, // 22 cols * 4 rows approx simulation
            itemBuilder: (context, index) {
              // Randomize colors to mock the activity map
              final colors = [
                const Color(0xFFF1F5F9), // empty
                const Color(0xFFBBE5CD), // light green
                const Color(0xFF22C55E), // green
                const Color(0xFF166534), // dark green
              ];
              // Make some predictable pattern for visualization
              final colorIntensity = (index * 7 % 4); 
              return _GridSquare(color: colors[colorIntensity]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF475569)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildAlertCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2), spreadRadius: -2)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFFEF4444), width: 4)), // Red left border
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFFEF4444), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceMetric({required String label, required String value, required String unit}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 2),
              Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridSquare extends StatelessWidget {
  final Color color;
  const _GridSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F52FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            'VERIFIED PATIENT',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _EditableMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final VoidCallback onTap;

  const _EditableMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0F52FF)),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
