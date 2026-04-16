import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'axio_card.dart';

class AppearancePopup extends StatefulWidget {
  const AppearancePopup({super.key});

  @override
  State<AppearancePopup> createState() => _AppearancePopupState();
}

class _AppearancePopupState extends State<AppearancePopup> {
  late String _selectedPreset;
  late Color _customColor;
  late bool _isTransparent;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _selectedPreset = themeProvider.presetName;
    _customColor = themeProvider.primaryColor;
    _isTransparent = themeProvider.isBottomBarTransparent;
    _hexController = TextEditingController(text: _colorToHex(_customColor));
  }

  String _colorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
  }

  void _onColorChanged(String hex) {
    if (hex.length == 6) {
      setState(() {
        _customColor = Color(int.parse("FF$hex", radix: 16));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141416), // Dark background as per screenshot
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appearance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Interface theme',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Customize your workspace theme',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildThemeCard('Orange Mechanic', const Color(0xFFF97316), 'Orange Mechanic')),
              const SizedBox(width: 12),
              Expanded(child: _buildThemeCard('Purple Disco', const Color(0xFF8B5CF6), 'Purple Disco')),
              const SizedBox(width: 12),
              Expanded(child: _buildThemeCard('Blue Powder', const Color(0xFF3B82F6), 'Blue Powder')),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Customize primary color',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Customize the look of your workspace. Feeling adventurous?',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildColorSelectionRow(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Transparent Bottom Bar',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Add a transparency layer to your navigation bar',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              Switch(
                value: _isTransparent,
                onChanged: (val) => setState(() => _isTransparent = val),
                activeColor: _customColor,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    themeProvider.updateAppearance(
                      preset: _selectedPreset,
                      primary: _customColor,
                      transparent: _isTransparent,
                      mode: ThemeMode.dark, // Presets are dark-themed
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _customColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save preferences', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String title, Color accent, String value) {
    bool isSelected = _selectedPreset == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPreset = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8, left: 8,
                    child: Container(width: 12, height: 4, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
                  ),
                  Positioned(
                    top: 16, left: 8,
                    child: Container(width: 30, height: 3, color: Colors.white10),
                  ),
                  Positioned(
                    top: 22, left: 8,
                    child: Container(width: 20, height: 3, color: Colors.white10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  size: 14,
                  color: isSelected ? accent : Colors.white24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelectionRow() {
    return Column(
      children: [
        // The "Graph" (Palette Grid)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildColorChip(const Color(0xFFE11D48)), // Axio Red
            _buildColorChip(const Color(0xFF0D8ABC)), // Sky Blue
            _buildColorChip(const Color(0xFF10B981)), // Emerald Green
            _buildColorChip(const Color(0xFF8B5CF6)), // Violet
            _buildColorChip(const Color(0xFFF97316)), // Orange
            _buildColorChip(const Color(0xFFF43F5E)), // Rose
            _buildColorChip(const Color(0xFFB2F96F)), // The one in screenshot
            _buildColorChip(const Color(0xFFEC4899)), // Pink
          ],
        ),
        const SizedBox(height: 20),
        // Hex Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('#', style: TextStyle(color: Colors.white54, fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _hexController,
                  onChanged: _onColorChanged,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'HEX CODE',
                    hintStyle: TextStyle(color: Colors.white24),
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _customColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorChip(Color color) {
    bool isSelected = _customColor.value == color.value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _customColor = color;
          _hexController.text = _colorToHex(color);
        });
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              )
          ],
        ),
      ),
    );
  }
}
