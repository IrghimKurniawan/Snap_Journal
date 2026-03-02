// ===== account_info.dart =====
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/additional%20pages/change_email.dart';
import 'package:snap_journal/additional%20pages/change_password.dart';
import 'package:snap_journal/package/navigationbar.dart';
import 'package:snap_journal/pages/dashboard.dart';
import 'package:snap_journal/pages/insight.dart';
import 'package:snap_journal/pages/journal.dart';
import 'package:snap_journal/pages/new_journal.dart';
import 'package:snap_journal/pages/profile.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});
  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final nameController = TextEditingController(text: 'Irghi');
  final bioController = TextEditingController(text: 'Life is Happy');
  final emailController = TextEditingController(text: 'Irghi@gmail.com');
  final passwordController = TextEditingController(text: '**********');

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    void saveChanges() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t['changes_saved']!)));
    }

    void deleteAccount() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t['delete_confirm_title']!),
          content: Text(t['delete_confirm_body']!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t['cancel']!),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t['delete']!, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F0FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9B7EBD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t['account_info_title']!,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9B7EBD),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF9B7EBD)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9B7EBD),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EBD),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(t['name']!),
                    const SizedBox(height: 6),
                    _field(controller: nameController),
                    const SizedBox(height: 16),
                    _label(t['bio']!),
                    const SizedBox(height: 6),
                    _field(controller: bioController),
                    const SizedBox(height: 16),
                    _label(t['email']!),
                    const SizedBox(height: 6),
                    _field(
                      controller: emailController,
                      readOnly: true,
                      suffix: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeEmail(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              t['change_gmail']!,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF9B7EBD),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label(t['password']!),
                    const SizedBox(height: 6),
                    _field(
                      controller: passwordController,
                      readOnly: true,
                      obscure: true,
                      suffix: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              t['change_password']!,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF9B7EBD),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: saveChanges,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      t['save_changes']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: deleteAccount,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      t['delete_account']!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
      bottomNavigationBar: CustomBottomNavbar(
        onHomeTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage()),
        ),
        onJournalTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => JournalPage()),
        ),
        onInsightTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InsightPage()),
        ),
        onProfileTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        ),
        onFabTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddJournal()),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    bool readOnly = false,
    bool obscure = false,
    Widget? suffix,
  }) => TextField(
    controller: controller,
    readOnly: readOnly,
    obscureText: obscure,
    style: GoogleFonts.poppins(color: Colors.black),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffix,
    ),
  );
}
