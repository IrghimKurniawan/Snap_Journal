import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_journal/auth/login.dart';
import 'package:snap_journal/auth/verification.dart';

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

  void register() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
  }

  @override
  Widget build(BuildContext context) {
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
                    "Register",
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
                                "Create Account",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Color(0xFFF5F0FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Enter Your Details",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFFF5F0FF).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(0xFFF5F0FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Full Name...",
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xFF9B7EBD),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF5F0FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
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
                        SizedBox(height: 15),
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
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
                        SizedBox(height: 15),
                        Text(
                          "Confirm Password",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(0xFFF5F0FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
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
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder:(context) => VerificationPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF5F0FF),
                              foregroundColor: const Color(0xFF9B7EBD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Register",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                         const SizedBox(height: 5),
            
                        /// REGISTER TEXT
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Already have an account? Login.",
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
}
