import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Themes extends StatefulWidget {
  const Themes({super.key});
  @override
  State<Themes> createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      backgroundColor: Color(0xFFF5F0FF),
      appBar: AppBar(
        title: Text(
          t['themes_title']!,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7EBD),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF9B7EBD)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t['appearance_label']!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF9B7EBD),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF9B7EBD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.dark_mode, color: Color(0xFF7B5FA7)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      t['dark_mode']!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    ToggleSwitch(
                      minWidth: 60.0,
                      cornerRadius: 20.0,
                      activeBgColors: [
                        [Color(0xFF9B7EBD)],
                        [Color(0xFF9B7EBD)],
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Color(0xFF9B7EBD),
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: 1,
                      totalSwitches: 2,
                      labels: ['', ''],
                      radiusStyle: true,
                      onToggle: (index) {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                t['color_themes']!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF9B7EBD),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF9B7EBD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _colorCircle(Color(0xFF9B7EBD), border: true),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFF121212)),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFFE5E5E5)),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFFCFCFCF)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          ['Default', 'Midnight', 'Light Gray', 'Soft Silver']
                              .map(
                                (s) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    s,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _colorCircle(Color(0xFF34C759)),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFF008080)),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFFFFC0CB)),
                        SizedBox(width: 10),
                        _colorCircle(Color(0xFF4B0082)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ['Green', 'Teal', 'Pink', 'Indigo']
                          .map(
                            (s) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                s,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.white, thickness: 1.5),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        t['accent_color']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          [
                                Color(0xFF7B5FA7),
                                Color(0xFFEC221F),
                                Color(0xFF000000),
                                Color(0xFFFFFFFF),
                                Color(0xFF0000FF),
                                Colors.white,
                              ]
                              .map(
                                (c) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: _colorCircle(
                                    c,
                                    small: true,
                                    border: c == Color(0xFF7B5FA7),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          ['Default', 'Red', 'Black', 'White', 'Blue', 'Custom']
                              .map(
                                (s) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  child: Text(
                                    s,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      t['save_changes']!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _colorCircle(Color color, {bool border = false, bool small = false}) {
    double size = small ? 20 : 45;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border ? Border.all(color: Colors.white, width: 2) : null,
      ),
    );
  }
}
