import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscureOld = true, obscureNew = true, obscureConfirm = true;

  final Color primaryColor = const Color(0xFF9B7EBD);
  final Color backgroundColor = const Color(0xFFF5F0FF);

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          t['change_password_title']!,
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
            _buildLabel(t['old_password']!),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: oldPasswordController,
              obscure: obscureOld,
              onToggle: () => setState(() => obscureOld = !obscureOld),
            ),
            const SizedBox(height: 20),
            _buildLabel(t['new_password']!),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: newPasswordController,
              obscure: obscureNew,
              onToggle: () => setState(() => obscureNew = !obscureNew),
            ),
            const SizedBox(height: 20),
            _buildLabel(t['confirm_password']!),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: confirmPasswordController,
              obscure: obscureConfirm,
              onToggle: () => setState(() => obscureConfirm = !obscureConfirm),
            ),
            const Spacer(),
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
                onPressed: () {},
                child: Text(
                  t['save_changes']!,
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

  Widget _buildLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: primaryColor,
    ),
  );

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    style: GoogleFonts.poppins(),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: primaryColor,
        ),
        onPressed: onToggle,
      ),
    ),
  );
}
