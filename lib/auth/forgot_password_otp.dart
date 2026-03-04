import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/auth/enter_new_password.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/auth_services.dart';
import 'package:snap_journal/auth/enter_new_password.dart';

class ForgotPasswordOtp extends StatefulWidget {
  final String email;

  const ForgotPasswordOtp({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordOtp> createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verify() async {
    final otp = _otpController.text.trim();

    if (otp.length != 4) {
      _showSnack("OTP harus 4 digit");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await AuthServices.verifyOtp(
        widget.email,
        otp,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPassword(
            email: widget.email,
            otp: otp, // kirim OTP
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9B7EBD),
              Color(0xFFF5F0FF),
              Color(0xFF9B7EBD),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFFF5F0FF),
                    child: Icon(Icons.dark_mode, color: Color(0xFF9B7EBD)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  t['forgot_password_title']!,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5F0FF),
                  ),
                ),
                const SizedBox(height: 30),

                /// CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7EBD).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        t['enter_otp'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFFF5F0FF),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// OTP FIELD
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '----',
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xFF9B7EBD),
                            letterSpacing: 8,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F0FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F0FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF9B7EBD),
                                  ),
                                )
                              : Text(
                                  t['send_otp']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF9B7EBD),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
