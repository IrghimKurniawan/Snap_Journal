import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyInsight extends StatefulWidget {
  const DailyInsight({super.key});

  @override
  State<DailyInsight> createState() => _DailyInsightState();
}

class _DailyInsightState extends State<DailyInsight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Color(0xFFF5F0FF), size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF9B7EBD),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Daily Insight",
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
                          child: Icon(Icons.help_outline, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kamu sedang berada di fase yang cukup positif.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xFF9B7EBD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Konsistensi Dalam kesehatan",
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
                "Analysis",
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
                  "Dalam beberapa hari terakhir\n Mood kamu cenderung stabil dan\n dominan positif",
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
