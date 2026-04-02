import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/theme_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Themes extends StatefulWidget {
  const Themes({super.key});

  @override
  State<Themes> createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primary = themeProvider.primaryColor;

    selectedColor ??= primary;

    // Warna kontras untuk AppBar agar selalu terlihat
    // Gunakan putih jika warna primary gelap, hitam jika terang
    final luminance = primary.computeLuminance();
    final appBarTextColor = luminance > 0.4 ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          t['themes_title']!,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t['appearance_label']!,
                  style: GoogleFonts.poppins(fontSize: 16, color: primary)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.dark_mode),
                    ),
                    const SizedBox(width: 10),
                    Text(t['dark_mode']!,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const Spacer(),
                    ToggleSwitch(
                      minWidth: 60,
                      cornerRadius: 20,
                      initialLabelIndex: themeProvider.isDark ? 1 : 0,
                      totalSwitches: 2,
                      labels: const ['Light', 'Dark'],
                      onToggle: (index) {
                        themeProvider.toggleDark(index == 1);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(t['color_themes']!,
                  style: GoogleFonts.poppins(fontSize: 16, color: primary)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(10)),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _colorCircle(const Color(0xFF9B7EBD)),
                    _colorCircle(const Color(0xFF34C759)),
                    _colorCircle(const Color(0xFF008080)),
                    _colorCircle(const Color(0xFFFFC0CB)),
                    _colorCircle(const Color(0xFF4B0082)),
                    _colorCircle(const Color(0xFFEC221F)),
                    _colorCircle(const Color(0xFF000000)),
                    _colorCircle(const Color(0xFF0000FF)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (selectedColor != null) {
                      themeProvider.changeColor(selectedColor!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Theme updated"),
                            duration: Duration(seconds: 2)),
                      );
                    }
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(t['save_changes']!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorCircle(Color color, {bool small = false}) {
    double size = small ? 25 : 45;
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
