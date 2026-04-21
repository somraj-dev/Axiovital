import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'user_provider.dart';
import 'widgets/axio_card.dart';
import 'update_profile_page.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, size: 24),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildSectionHeader('YOUR DETAILS', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildClickableItem(
                  icon: Icons.person_outline,
                  title: 'Personal details',
                  theme: theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UpdateProfilePage()),
                    );
                  },
                ),
                _buildDivider(theme),
                _buildActionItem(
                  icon: Icons.people_outline,
                  title: 'Nominees',
                  subtitle: 'Not added yet',
                  actionText: 'Add nominees',
                  theme: theme,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nominee feature coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('AXIO DETAILS', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildCopyableItem(
                  title: 'Axio-ID',
                  content: userProvider.axioId,
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildClickableItem(
                  title: 'Segments',
                  subtitle: 'Clinical, Labs, Pharmacy, E-Consults',
                  theme: theme,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('DEMAT DETAILS', theme: theme),
          const SizedBox(height: 12),
          AxioCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildCopyableItem(
                  title: 'Demat Acc Number / BOID',
                  content: '1208870468495974', // Mock data
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildCopyableItem(
                  title: 'DP ID',
                  content: '12088704', // Mock data
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildCopyableItem(
                  title: 'Depository Participant (DP)',
                  content: 'Axiovital Health Tech Pvt. Ltd.',
                  theme: theme,
                ),
                _buildDivider(theme),
                _buildSimpleItem(
                  title: 'Depository Name',
                  content: 'AXIO-NSDL',
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required ThemeData theme}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildClickableItem({
    IconData? icon,
    required String title,
    String? subtitle,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: icon != null
          ? Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6), size: 24)
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3), size: 20),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required ThemeData theme,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.6), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF102A22), // Matching the dark green in image
              foregroundColor: const Color(0xFF1DB954), // Matching the light green text
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              actionText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableItem({
    required String title,
    required String content,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: content));
        // We can't use ScaffoldMessenger here easily without a context, 
        // but since this is a stateless widget method, context is passed to build.
        // Actually, let's just make it a method inside build or pass context.
      },
      child: Builder(
        builder: (context) => ListTile(
          onTap: () {
            Clipboard.setData(ClipboardData(text: content));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title copied to clipboard'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                width: 200,
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.copy_outlined, color: theme.colorScheme.onSurface.withOpacity(0.3), size: 20),
        ),
      ),
    );
  }

  Widget _buildSimpleItem({
    required String title,
    required String content,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: theme.dividerColor.withOpacity(0.1),
    );
  }
}
