import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  Color _primaryColor = const Color(0xFF9B7EBD);

  bool get isDark => _isDark;
  Color get primaryColor => _primaryColor;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> toggleDark(bool value) async {
    _isDark = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", _isDark);

    notifyListeners();
  }

  Future<void> changeColor(Color color) async {
    _primaryColor = color;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("primaryColor", color.value);

    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDark = prefs.getBool("darkMode") ?? false;

    int colorValue =
        prefs.getInt("primaryColor") ?? const Color(0xFF9B7EBD).value;

    _primaryColor = Color(colorValue);

    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      brightness: _isDark ? Brightness.dark : Brightness.light,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor:
          _isDark ? const Color(0xFF121212) : const Color(0xFFF5F0FF),

      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0,
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: _isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }
}