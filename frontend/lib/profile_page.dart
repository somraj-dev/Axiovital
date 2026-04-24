import 'package:flutter/material.dart';
import 'upload_report_page.dart';
import 'device_connectivity_page.dart';
import 'vitalsync_dashboard.dart';
import 'update_profile_page.dart';
import 'medical_history_form_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'bluetooth_scan_page.dart';
import 'location_provider.dart';
import 'permission_service.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';
import 'widgets/axio_button.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'choose_address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  IconData _getIconData(String iconType) {
    switch (iconType) {
      case 'monitor_heart': return Icons.monitor_heart;
      case 'air': return Icons.air;
      case 'water_drop': return Icons.water_drop;
      case 'medical_services': return Icons.medical_services;
      default: return Icons.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final String userName = userProvider.name;
    final String clinicalId = userProvider.clinicalId;
    final String avatarUrl = userProvider.avatarUrl;
    final String age = userProvider.age;
    final String weight = userProvider.weight;
    final String bloodGroup = userProvider.bloodGroup;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.primaryColor),
              )
            : null,
        title: Text(
          'Profile Settings',
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfilePage()),
              );
            },
            icon: Icon(Icons.edit_outlined, color: theme.primaryColor),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(theme.brightness == Brightness.light ? 0.04 : 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.primaryColor, width: 3),
                      ),
                      child: AxioAvatar(
                        radius: 56,
                        imageUrl: avatarUrl,
                        name: userName,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 15,
                    left: 15,
                    child: _VerifiedBadge(theme: theme),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Name and ID
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                ),
                child: Text(
                  'AXIO-ID: ${userProvider.axioId}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // THEME SETTINGS (Requirement: User can only choose dark theme from the settings page)
            _buildSectionHeader('APP APPEARANCE', theme: theme),
            const SizedBox(height: 12),
            AxioCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: theme.primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                  ),
                  Switch.adaptive(
                    value: themeProvider.isDarkMode,
                    activeColor: theme.primaryColor,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Personal Metrics
            _buildSectionHeader('PERSONAL METRICS', hasInfo: true, theme: theme),
            const SizedBox(height: 12),
            AxioCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard('Age', age, 'Years', theme: theme),
                  _buildMetricCard('Weight', weight, 'kg', theme: theme),
                  _buildMetricCard('Blood Group', bloodGroup, '', theme: theme),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Health Activity Log
            _buildSectionHeader('HEALTH ACTIVITY LOG', suffixText: 'LATEST 12 MONTHS', theme: theme),
            const SizedBox(height: 12),
            AxioCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consistency Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 4),
                  Text('Daily health check-ins & adherence', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                  const SizedBox(height: 16),
                  _buildActivityGrid(theme: theme),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('LESS', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          _GridSquare(color: theme.colorScheme.surfaceVariant),
                          const SizedBox(width: 4),
                          _GridSquare(color: AppTheme.successColor.withOpacity(0.3)),
                          const SizedBox(width: 4),
                          _GridSquare(color: AppTheme.successColor.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          _GridSquare(color: AppTheme.successColor),
                          const SizedBox(width: 8),
                          Text('MORE', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.electric_bolt, color: AppTheme.successColor, size: 14),
                          const SizedBox(width: 4),
                          Text('94% Compliance', style: TextStyle(color: AppTheme.successColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Saved Addresses
            _buildSectionHeader('SAVED ADDRESSES', theme: theme),
            const SizedBox(height: 12),
            AxioCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChooseAddressPage()),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.location_on_outlined, color: theme.primaryColor, size: 20),
                ),
                title: Text('Manage Delivery Addresses', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                subtitle: Text('Home, Office, and other locations', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Medical History
            _buildSectionHeader(
              'MEDICAL HISTORY', 
              suffixAction: '+ Add Record',
              theme: theme,
              onSuffixTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MedicalHistoryFormPage()),
                );
                if (result == true) {
                  userProvider.fetchConditions();
                }
              }
            ),
            const SizedBox(height: 12),
            AxioCard(
              padding: const EdgeInsets.all(16),
              child: userProvider.isLoadingConditions 
                ? const Center(child: CircularProgressIndicator())
                : userProvider.conditions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('No medical history records found.', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)))),
                    )
                  : Column(
                      children: List.generate(userProvider.conditions.length, (index) {
                        final condition = userProvider.conditions[index];
                        return Column(
                          children: [
                            _buildListTile(
                              icon: _getIconData(condition['icon_type']), 
                              title: condition['title'], 
                              subtitle: condition['subtitle'] ?? '',
                              theme: theme,
                            ),
                            if (index < userProvider.conditions.length - 1)
                              Divider(color: theme.dividerColor, height: 24),
                          ],
                        );
                      }),
                    ),
            ),
            
            const SizedBox(height: 32),
            
            // Allergy Alerts
            _buildSectionHeader('ALLERGY ALERTS', theme: theme),
            const SizedBox(height: 12),
            _buildAlertCard(icon: Icons.warning_amber_rounded, title: 'Penicillin', subtitle: 'Anaphylaxis Risk • High Priority', theme: theme),
            const SizedBox(height: 12),
            _buildAlertCard(icon: Icons.bug_report, title: 'Peanuts', subtitle: 'Severe reaction reported 2021', theme: theme),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, {required ThemeData theme}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  unit,
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool hasInfo = false, String? suffixText, String? suffixAction, VoidCallback? onSuffixTap, required ThemeData theme}) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12, letterSpacing: 0.5)),
        if (hasInfo)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.info_outline, color: theme.colorScheme.onSurface.withOpacity(0.2), size: 16),
          ),
        const Spacer(),
        if (suffixText != null)
          Text(suffixText, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 11)),
        if (suffixAction != null)
          GestureDetector(
             onTap: onSuffixTap,
             child: Text(suffixAction, style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildActivityGrid({required ThemeData theme}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text('MON', style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurface.withOpacity(0.4))),
            const SizedBox(height: 4),
            Text('WED', style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurface.withOpacity(0.4))),
            const SizedBox(height: 4),
            Text('FRI', style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurface.withOpacity(0.4))),
            const SizedBox(height: 4),
            Text('SUN', style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurface.withOpacity(0.4))),
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
            itemCount: 88,
            itemBuilder: (context, index) {
              final colors = [
                theme.colorScheme.surfaceVariant,
                AppTheme.successColor.withOpacity(0.3),
                AppTheme.successColor.withOpacity(0.6),
                AppTheme.successColor,
              ];
              final colorIntensity = (index * 7 % 4); 
              return _GridSquare(color: colors[colorIntensity]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required String subtitle, required ThemeData theme}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildAlertCard({required IconData icon, required String title, required String subtitle, required ThemeData theme}) {
    return AxioCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: theme.primaryColor, width: 4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: theme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          ],
        ),
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
  final ThemeData theme;
  const _VerifiedBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surface, width: 2),
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
