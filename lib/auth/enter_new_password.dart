import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/auth_services.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  ResetPassword({super.key, required this.email, required this.otp});
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool isLoading = false;

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
                const SizedBox(height: 40),
                Text(
                  t['reset_password_title'] ?? 'Reset Password',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5F0FF),
                  ),
                ),
                const SizedBox(height: 40),
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
                      /// NEW PASSWORD
                      TextField(
                        controller: newPasswordController,
                        obscureText: obscure1,
                        decoration: InputDecoration(
                          hintText: t['enter_new_password'] ?? '',
                          hintStyle: GoogleFonts.poppins(
                            color: Color(0xFF9B7EBD),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F0FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF9B7EBD),
                            ),
                            onPressed: () {
                              setState(() {
                                obscure1 = !obscure1;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CONFIRM PASSWORD
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscure2,
                        decoration: InputDecoration(
                          hintText: t['confirm_new_password'] ?? '',
                          hintStyle: GoogleFonts.poppins(
                            color: Color(0xFF9B7EBD),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F0FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF9B7EBD),
                            ),
                            onPressed: () {
                              setState(() {
                                obscure2 = !obscure2;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F0FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (newPasswordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('All fields are required')),
                              );
                              return;
                            }

                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Password does not match')),
                              );
                              return;
                            }

                            setState(() => isLoading = true);

                            try {
                              await AuthServices.resetPassword(
                                widget.email,
                                widget.otp,
                                newPasswordController.text,
                                confirmPasswordController.text,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Password updated successfully')),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }

                            setState(() => isLoading = false);
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF9B7EBD),
                                )
                              : Text(
                                  t['update_password'] ?? 'Update Password',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
