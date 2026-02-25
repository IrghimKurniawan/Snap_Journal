import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController currentEmailController = TextEditingController(
    text: "user@gmail.com",
  );

  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  final Color primaryColor = const Color(0xFF9B7EBD);
  final Color backgroundColor = const Color(0xFFF5F0FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Change Email',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CURRENT EMAIL
            _buildLabel("Current Email"),
            const SizedBox(height: 6),
            TextField(
              controller: currentEmailController,
              readOnly: true,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// NEW EMAIL
            _buildLabel("New Email"),
            const SizedBox(height: 6),
            TextField(
              controller: newEmailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter new email",
                hintStyle: GoogleFonts.poppins(fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildLabel("OTP"),
            const SizedBox(height: 6),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 6, // biar renggang kayak OTP
              ),
              decoration: InputDecoration(
                counterText: "", // hilangin 0/6
                filled: true,
                fillColor: Colors.white,
                hintText: "------",
                hintStyle: GoogleFonts.poppins(fontSize: 18, letterSpacing: 6),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF9B7EBD), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF9B7EBD), width: 2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// PASSWORD CONFIRMATION
            _buildLabel("Confirm Password"),
            const SizedBox(height: 6),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  print("Save Email Clicked");
                },
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }
}
