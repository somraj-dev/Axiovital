import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeModeKey = "theme_mode";
  static const String _presetKey = "theme_preset";
  static const String _primaryColorKey = "primary_color";
  static const String _transparencyKey = "bottom_bar_transparent";

  ThemeMode _themeMode = ThemeMode.light;
  String _presetName = 'Default';
  Color _primaryColor = const Color(0xFFE11D48); // Default Axio Red
  bool _isBottomBarTransparent = false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get presetName => _presetName;
  Color get primaryColor => _primaryColor;
  bool get isBottomBarTransparent => _isBottomBarTransparent;
  bool get isDarkMode => _themeMode == ThemeMode.dark || _presetName != 'Default' && _presetName != 'Light';

  ThemeProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt(_themeModeKey);
    if (themeIndex != null) _themeMode = ThemeMode.values[themeIndex];
    
    _presetName = prefs.getString(_presetKey) ?? 'Default';
    
    final colorValue = prefs.getInt(_primaryColorKey);
    if (colorValue != null) _primaryColor = Color(colorValue);
    
    _isBottomBarTransparent = prefs.getBool(_transparencyKey) ?? false;
    
    notifyListeners();
  }

  void updateAppearance({
    ThemeMode? mode,
    String? preset,
    Color? primary,
    bool? transparent,
  }) async {
    if (mode != null) _themeMode = mode;
    if (preset != null) _presetName = preset;
    if (primary != null) _primaryColor = primary;
    if (transparent != null) _isBottomBarTransparent = transparent;

    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    if (mode != null) await prefs.setInt(_themeModeKey, mode.index);
    if (preset != null) await prefs.setString(_presetKey, preset);
    if (primary != null) await prefs.setInt(_primaryColorKey, primary.value);
    if (transparent != null) await prefs.setBool(_transparencyKey, transparent);
  }

  void toggleTheme() {
    updateAppearance(
      mode: _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      preset: 'Default',
    );
  }
}
