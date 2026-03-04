import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/auth/login.dart';
import 'package:snap_journal/services/auth_services.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/package/navigationbar.dart';
import 'package:snap_journal/pages/dashboard.dart';
import 'package:snap_journal/pages/insight.dart';
import 'package:snap_journal/pages/journal.dart';
import 'package:snap_journal/pages/new_journal.dart';
import 'package:snap_journal/pages/account_info.dart';
import 'package:snap_journal/pages/privacy_policy.dart';
import 'package:snap_journal/pages/themes.dart';
import 'package:snap_journal/models/profileuser_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/services/profile_services.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final Future<UserProfileModel?> _profileFuture = ProfileServices.getProfile();
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final t = lang.text;

    return Scaffold(
      backgroundColor: Color(0xFFF5F0FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F0FF),
        automaticallyImplyLeading: false,
        title: Text(
          t['profile']!,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7EBD),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<UserProfileModel?>(
                future: ProfileServices.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("Gagal memuat profile");
                  }

                  final user = snapshot.data!;

                  return Column(
                    children: [
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            image: user.photoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(user.photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: user.photoUrl == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.bio ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GENERAL
                  _sectionTitle(t['general']!),
                  SizedBox(height: 10),
                  _menuBox(
                    children: [
                      _menuItem(
                        icon: Icons.person_outline,
                        label: t['account_info']!,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AccountInfoPage()),
                        ),
                      ),
                      SizedBox(height: 20),
                      _menuItem(
                        icon: Icons.notifications_none,
                        label: t['notification']!,
                        onTap: () => print("Notification"),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // APPEARANCE
                  _sectionTitle(t['appearance']!),
                  SizedBox(height: 10),
                  _menuBox(
                    children: [
                      _menuItem(
                        icon: Icons.brush_outlined,
                        label: t['themes']!,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Themes()),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // LANGUAGE SETTINGS
                  _sectionTitle(t['language_settings']!),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF9B7EBD),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => lang.setLanguage('English'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: lang.language == 'English'
                                    ? Color(0xFF5C3D8F)
                                    : Color(0xFFB89FD8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '🇺🇸  English',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: lang.language == 'English'
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => lang.setLanguage('Indonesia'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: lang.language == 'Indonesia'
                                    ? Color(0xFF5C3D8F)
                                    : Color(0xFFB89FD8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '🇮🇩  Indonesia',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: lang.language == 'Indonesia'
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // DATA & PRIVACY
                  _sectionTitle(t['data_privacy']!),
                  SizedBox(height: 10),
                  _menuBox(
                    children: [
                      _menuItem(
                        icon: Icons.lock_outline,
                        label: t['privacy_policy']!,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivacyPolicyPage(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        final success = await AuthServices.logout();

                        Navigator.of(context, rootNavigator: true).pop();

                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logout gagal")),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.door_back_door_outlined,
                                color: Color(0xFFF5F0FF),
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                t['sign_out']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFF5F0FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      t['version']!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9B7EBD),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
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

  Widget _sectionTitle(String title) => Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9B7EBD),
        ),
      );

  Widget _menuBox({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFF9B7EBD),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(children: children),
      );

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Color(0xFF7B5FA7)),
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}
