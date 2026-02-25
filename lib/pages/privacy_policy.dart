import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F0FF),
        automaticallyImplyLeading: false,
        title: Text(
          'Privacy & Policy',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ← diganti jadi bisa scroll
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy & Policy',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9B7EBD),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Privacy Protection',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9B7EBD),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EBD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Kami menjaga keamanan data kamu dengan serius.\nData jurnal, mood, dan aktivitas kamu disimpan secara aman dan hanya digunakan untuk meningkatkan pengalaman penggunaan aplikasi.\nKami tidak menjual atau membagikan data pribadi kamu ke pihak ketiga tanpa izin.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Data Usage & User Rights',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9B7EBD),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EBD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Data digunakan untuk menampilkan insight personal, menyimpan riwayat aktivitas, dan pengembangan fitur aplikasi.\nKamu memiliki hak untuk mengakses, mengubah, atau menghapus data kamu kapan saja melalui aplikasi.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // BACK BUTTON
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
