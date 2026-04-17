import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';
import 'theme.dart';
import 'account_settings_page.dart';
import 'family_hub_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.primaryColor),
        ),
        title: Text(
          userProvider.translate('settings'),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildSectionHeader(userProvider.translate('settings_hub'), theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: userProvider.translate('account'),
                  theme: theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
                    );
                  },
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Financial',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Customization',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.hub_outlined,
                  title: 'Family Hub',
                  theme: theme,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyHubPage()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildSectionHeader(userProvider.translate('account_management'), theme: theme),
              const SizedBox(width: 8),
              _buildNewBadge(),
            ],
          ),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.people_outline,
                  title: 'Manage Parents',
                  subtitle: 'Take care of your parents remotely',
                  trailing: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 1.5),
                    ),
                    child: AxioAvatar(
                      radius: 12,
                      imageUrl: userProvider.avatarUrl,
                      name: userProvider.name,
                    ),
                  ),
                  theme: theme,
                  onTap: () {
                    _showAccountSwitchingDialog(context, userProvider, theme);
                  },
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.delete_outline,
                  title: userProvider.translate('delete_account'),
                  textColor: theme.colorScheme.error,
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(userProvider.translate('support_faqs'), theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Search FAQ',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSettingsItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contact Support',
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(userProvider.translate('app'), theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: _buildSettingsItem(
              icon: Icons.system_update_outlined,
              title: userProvider.translate('app_updates'),
              theme: theme,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required ThemeData theme}) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required ThemeData theme,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: textColor ?? theme.colorScheme.onSurface.withOpacity(0.7), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: textColor ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.2), size: 18),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: theme.dividerColor.withOpacity(0.3),
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE11D48).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white, // Keep white text on red/rose badge for contrast
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAccountSwitchingDialog(BuildContext context, UserProvider userProvider, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Switch Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Take care of your loved ones remotely by switching to their profiles.',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13),
            ),
            const SizedBox(height: 24),
            _buildAccountTile(
              context,
              name: userProvider.name,
              subtitle: 'Current Profile',
              imageUrl: userProvider.avatarUrl,
              isSelected: true,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _buildAccountTile(
              context,
              name: 'Robert Vance (Father)',
              subtitle: 'Remote Care Active',
              imageUrl: 'https://ui-avatars.com/api/?name=Robert+Vance&background=4F46E5&color=fff',
              isSelected: false,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _buildAccountTile(
              context,
              name: 'Sarah Vance (Mother)',
              subtitle: 'Linked Profile',
              imageUrl: 'https://ui-avatars.com/api/?name=Sarah+Vance&background=EC4899&color=fff',
              isSelected: false,
              theme: theme,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Link New Parent Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required String imageUrl,
    required bool isSelected,
    required ThemeData theme,
  }) {
    return AxioCard(
      padding: const EdgeInsets.all(12),
      borderSide: isSelected ? BorderSide(color: theme.primaryColor, width: 2) : null,
      onTap: () {
        if (!isSelected) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to $name'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: theme.primaryColor,
            ),
          );
        }
      },
      child: Row(
        children: [
          AxioAvatar(radius: 20, imageUrl: imageUrl, name: name),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: theme.primaryColor, size: 20),
        ],
      ),
    );
  }
}
