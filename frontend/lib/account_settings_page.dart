import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'theme_provider.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Dynamic user data
    final String userName = userProvider.name;
    final String axioId = userProvider.axioId;
    final String avatarUrl = userProvider.avatarUrl;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: 18, color: theme.colorScheme.onSurface),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Profile Header Card
          AxioCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AxioAvatar(
                  radius: 36,
                  imageUrl: avatarUrl,
                  name: userName,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Axio-ID: $axioId',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader('Account', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.account_circle_outlined,
                  title: 'Manage Profile',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Password & Security',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  trailing: Text(
                    'English',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preferences Section
          _buildSectionHeader('Preferences', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.list_alt_rounded,
                  title: 'About Us',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.track_changes_outlined,
                  title: 'Theme',
                  trailing: Text(
                    themeProvider.isDarkMode ? 'Dark' : 'Light',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.calendar_month_outlined,
                  title: 'Appointments',
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Support Section
          _buildSectionHeader('Support', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: _buildSettingsItem(
              icon: Icons.help_outline_rounded,
              title: 'Help Center',
              theme: theme,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required ThemeData theme,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.8), size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3), size: 16),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      endIndent: 16,
      color: theme.dividerColor.withOpacity(0.3),
    );
  }
}
