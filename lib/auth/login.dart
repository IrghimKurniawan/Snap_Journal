// login.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/auth/register.dart';
import 'package:snap_journal/pages/dashboard.dart';
import 'package:snap_journal/services/auth_services.dart';
import 'package:snap_journal/models/login_request.dart';
import 'package:snap_journal/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFF5F0FF),
                    child: Icon(Icons.dark_mode, color: Color(0xFF9B7EBD)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  t['login']!,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F0FF),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF9B7EBD).withOpacity(0.9),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              t['welcome']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF5F0FF),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              t['login_subtitle']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFFF5F0FF).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t['email']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color(0xFFF5F0FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email@example.com",
                          hintStyle: GoogleFonts.poppins(
                            color: Color(0xFF9B7EBD),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F0FF).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        t['password']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color(0xFFF5F0FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(
                            color: Color(0xFF9B7EBD),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F0FF).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t['forgot_password']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Color(0xFFF5F0FF).withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Email & Password wajib diisi")),
                              );
                              return;
                            }

                            // Loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final result = await AuthService.login(
                              email: email,
                              password: password,
                            );

                            // Close loading dialog
                            Navigator.pop(context);   

                            if (result != null) {
                              // simpan token
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  "token", result.accessToken);
                              await prefs.setString(
                                  "refreshToken", result.refreshToken);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login berhasil")),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DashboardPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login gagal")),
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
                            t['login']!,
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
                              builder: (context) => RegisterPage(),
                            ),
                          ),
                          child: Text(
                            t['no_account']!,
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
    );
  }
}
