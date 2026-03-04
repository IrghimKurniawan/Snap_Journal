import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/auth/login.dart';
import 'package:snap_journal/auth/verification.dart';
import 'package:snap_journal/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F0FF),
              Color(0xFF9B7EBD),
              Color(0xFFF5F0FF),
              Color(0xFF9B7EBD),
            ],
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.dark_mode, color: Color(0xFF9B7EBD)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t['register']!,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Color(0xFFF5F0FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF9B7EBD).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
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
                                t['create_account']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Color(0xFFF5F0FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                t['enter_details']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFFF5F0FF).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        _label(t['name']!),
                        _field(
                          controller: nameController,
                          hint: t['full_name']!,
                        ),
                        SizedBox(height: 15),
                        _label(t['email']!),
                        _field(
                          controller: emailController,
                          hint: "Email@example.com",
                        ),
                        SizedBox(height: 15),
                        _label(t['password']!),
                        SizedBox(height: 5),
                        _field(
                          controller: passwordController,
                          hint: "Password",
                          obscure: true,
                        ),
                        SizedBox(height: 15),
                        _label(t['confirm_password_label']!),
                        SizedBox(height: 5),
                        _field(
                          controller: confirmPasswordController,
                          hint: t['confirm_password_label']!,
                          obscure: true,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirmPassword =
                                  confirmPasswordController.text.trim();

                              // VALIDASI
                              if (name.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Semua field wajib diisi")),
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Password tidak sama")),
                                );
                                return;
                              }

                              // LOADING (optional tapi bagus)
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                    child: CircularProgressIndicator()),
                              );

                              final success = await AuthServices.register(
                                name: name,
                                email: email,
                                password: password,
                              );

                              Navigator.of(context, rootNavigator: true).pop();

                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VerificationPage(email: email),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Register gagal")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF5F0FF),
                              foregroundColor: const Color(0xFF9B7EBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              t['register']!,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            ),
                            child: Text(
                              t['have_account']!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Color(0xFFF5F0FF).withOpacity(0.8),
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
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Color(0xFFF5F0FF),
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) =>
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Color(0xFF9B7EBD)),
          filled: true,
          fillColor: Color(0xFFF5F0FF).withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              obscure ? Icon(Icons.visibility_off, color: Colors.grey) : null,
        ),
      );
}
