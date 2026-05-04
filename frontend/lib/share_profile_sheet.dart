import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_provider.dart';

class ShareProfileSheet extends StatefulWidget {
  const ShareProfileSheet({super.key});

  @override
  State<ShareProfileSheet> createState() => _ShareProfileSheetState();
}

class _ShareProfileSheetState extends State<ShareProfileSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _linkCopied = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getProfileUrl(UserProvider user) {
    return 'https://axiovital.com/profile/${user.axioId}';
  }

  String _getShareText(UserProvider user) {
    return 'Check out ${user.name}\'s health profile on Axiovital! 🩺✨';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareToWhatsApp(UserProvider user) {
    final text = Uri.encodeComponent(
        '${_getShareText(user)}\n${_getProfileUrl(user)}');
    _launchUrl('https://wa.me/?text=$text');
  }

  void _shareToFacebook(UserProvider user) {
    final url = Uri.encodeComponent(_getProfileUrl(user));
    _launchUrl('https://www.facebook.com/sharer/sharer.php?u=$url');
  }

  void _shareToX(UserProvider user) {
    final text = Uri.encodeComponent(_getShareText(user));
    final url = Uri.encodeComponent(_getProfileUrl(user));
    _launchUrl('https://x.com/intent/tweet?text=$text&url=$url');
  }

  void _shareToLinkedIn(UserProvider user) {
    final url = Uri.encodeComponent(_getProfileUrl(user));
    _launchUrl('https://www.linkedin.com/sharing/share-offsite/?url=$url');
  }

  void _shareToInstagram(UserProvider user) {
    _launchUrl('https://www.instagram.com/');
  }

  void _copyLink(UserProvider user) {
    Clipboard.setData(ClipboardData(text: _getProfileUrl(user)));
    setState(() => _linkCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _linkCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    final cardColor = isDark ? const Color(0xFF1E2024) : Colors.white;
    final subtitleColor = isDark ? Colors.white54 : const Color(0xFF8A8A8E);
    final fieldBg = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF5F5F7);
    final fieldBorder = isDark ? Colors.white12 : const Color(0xFFE8E8ED);
    final labelColor = isDark ? Colors.white70 : const Color(0xFF6E6E73);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                    blurRadius: 40,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : const Color(0xFFF0F0F2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: isDark ? Colors.white54 : const Color(0xFF8A8A8E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Link Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF0F0F2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.link_rounded,
                      size: 28,
                      color: isDark ? Colors.white70 : const Color(0xFF3A3A3C),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Share with Friends',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Health is better when you connect with friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Share your link label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'share your link',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Link field with copy button
                  GestureDetector(
                    onTap: () => _copyLink(userProvider),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: _linkCopied
                            ? const Color(0xFF10B981).withValues(alpha: 0.08)
                            : fieldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _linkCopied
                              ? const Color(0xFF10B981).withValues(alpha: 0.4)
                              : fieldBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _linkCopied
                                  ? 'Copied to clipboard!'
                                  : _getProfileUrl(userProvider),
                              style: TextStyle(
                                fontSize: 12,
                                color: _linkCopied
                                    ? const Color(0xFF10B981)
                                    : (isDark ? Colors.white60 : const Color(0xFF6E6E73)),
                                fontWeight: _linkCopied ? FontWeight.w600 : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _linkCopied ? Icons.check_circle_rounded : Icons.content_copy_rounded,
                              key: ValueKey(_linkCopied),
                              size: 18,
                              color: _linkCopied
                                  ? const Color(0xFF10B981)
                                  : (isDark ? Colors.white38 : const Color(0xFFAAAAAF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Share to label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'share to',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Social buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSocialIcon(
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        icon: Icons.facebook_rounded,
                        onTap: () {
                          _shareToFacebook(userProvider);
                          Navigator.pop(context);
                        },
                        isDark: isDark,
                      ),
                      _buildSocialIcon(
                        label: 'X',
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        icon: Icons.tag,
                        onTap: () {
                          _shareToX(userProvider);
                          Navigator.pop(context);
                        },
                        isDark: isDark,
                      ),
                      _buildSocialIcon(
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        icon: Icons.chat_rounded,
                        onTap: () {
                          _shareToWhatsApp(userProvider);
                          Navigator.pop(context);
                        },
                        isDark: isDark,
                      ),
                      _buildSocialIcon(
                        label: 'Instagram',
                        color: const Color(0xFFE4405F),
                        icon: Icons.camera_alt_rounded,
                        onTap: () {
                          _shareToInstagram(userProvider);
                          Navigator.pop(context);
                        },
                        isDark: isDark,
                      ),
                      _buildSocialIcon(
                        label: 'LinkedIn',
                        color: const Color(0xFF0A66C2),
                        icon: Icons.work_rounded,
                        onTap: () {
                          _shareToLinkedIn(userProvider);
                          Navigator.pop(context);
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF6E6E73),
            ),
          ),
        ],
      ),
    );
  }
}
