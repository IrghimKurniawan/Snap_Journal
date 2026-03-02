// daily_insight.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';

class DailyInsight extends StatefulWidget {
  const DailyInsight({super.key});
  @override
  State<DailyInsight> createState() => _DailyInsightState();
}

class _DailyInsightState extends State<DailyInsight> {
  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Color(0xFFF5F0FF), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF9B7EBD),
        elevation: 0,
        title: Text(
          t['daily_insight_title']!,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF5F0FF),
          ),
        ),
      ),
      backgroundColor: Color(0xFF9B7EBD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFF5F0FF),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF9B7EBD),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      t['insight_positive']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xFF9B7EBD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      t['insight_consistency']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF9B7EBD),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                t['analysis']!,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Color(0xFFF5F0FF),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFF5F0FF),
                ),
                child: Text(
                  t['insight_analysis']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFF9B7EBD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
