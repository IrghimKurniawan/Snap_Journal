import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/models/verify_request.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/auth/login.dart';
import 'package:snap_journal/services/auth_services.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFF5F0FF),
                    child: Icon(Icons.dark_mode, color: Color(0xFF9B7EBD)),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  t['verification']!,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F0FF),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              t['verify_email']!,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF5F0FF),
                              ),
                            ),
                            Text(
                              t['verify_body']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFFF5F0FF).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _otpField(otp1),
                          _otpField(otp2),
                          _otpField(otp3),
                          _otpField(otp4),
                        ],
                        // children: List.generate(
                        //   4,
                        //   (index) => SizedBox(
                        //     width: 55,
                        //     height: 55,
                        //     child: TextField(
                        //       keyboardType: TextInputType.number,
                        //       textAlign: TextAlign.center,
                        //       maxLength: 1,
                        //       style: const TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //       decoration: InputDecoration(
                        //         counterText: "",
                        //         filled: true,
                        //         fillColor: Color(0xFFF5F0FF),
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           borderSide: BorderSide.none,
                        //         ),
                        //       ),
                        //       onChanged: (value) {
                        //         if (value.length == 1)
                        //           FocusScope.of(context).nextFocus();
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t['resend_code']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFFF5F0FF),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final otp =
                                  otp1.text + otp2.text + otp3.text + otp4.text;

                              if (otp.length != 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("OTP harus 4 digit")),
                                );
                                return;
                              }

                              final request = VerifyRequestModel(
                                email: widget.email,
                                otp: otp,
                              );

                              final result =
                                  await AuthService.verifyEmail(request);

                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.message)),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Verifikasi gagal")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF5F0FF),
                              foregroundColor: Color(0xFF9B7EBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(t['confirm']!),
                          ),
                        ],
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

  Widget _otpField(TextEditingController controller) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFFF5F0FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
