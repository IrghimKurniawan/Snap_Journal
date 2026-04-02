// lib/services/theme_extension.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/theme_provider.dart';

extension ThemeContext on BuildContext {
  /// Warna utama (misal ungu, hijau, dll sesuai pilihan user)
  Color get primaryColor =>
      Provider.of<ThemeProvider>(this, listen: false).primaryColor;

  /// Versi listen: true — pakai ini di dalam build() agar rebuild saat warna berubah
  Color get watchPrimaryColor => Provider.of<ThemeProvider>(this).primaryColor;

  /// Warna lebih gelap (untuk aksen)
  Color get darkColor =>
      HSLColor.fromColor(Provider.of<ThemeProvider>(this).primaryColor)
          .withLightness(
            (HSLColor.fromColor(Provider.of<ThemeProvider>(this).primaryColor)
                        .lightness -
                    0.1)
                .clamp(0.0, 1.0),
          )
          .toColor();

  /// Warna lebih terang (untuk background ringan)
  Color get lightColor =>
      HSLColor.fromColor(Provider.of<ThemeProvider>(this).primaryColor)
          .withLightness(
            (HSLColor.fromColor(Provider.of<ThemeProvider>(this).primaryColor)
                        .lightness +
                    0.25)
                .clamp(0.0, 1.0),
          )
          .toColor();

  /// Background halaman (putih keunguan / gelap tergantung dark mode)
  Color get scaffoldColor => Provider.of<ThemeProvider>(this).isDark
      ? const Color(0xFF121212)
      : HSLColor.fromColor(Provider.of<ThemeProvider>(this).primaryColor)
          .withLightness(0.97)
          .withSaturation(0.3)
          .toColor();
}
