// lib/pages/dashboard.dart
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/models/profileuser_model.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/additional%20pages/daily_insight.dart';
import 'package:snap_journal/package/navigationbar.dart';
import 'package:snap_journal/pages/insight.dart';
import 'package:snap_journal/pages/journal.dart';
import 'package:snap_journal/additional%20pages/notification.dart';
import 'package:snap_journal/pages/new_journal.dart';
import 'package:snap_journal/pages/profile.dart';
import 'package:snap_journal/services/feeling_services.dart';
import 'package:snap_journal/services/profile_services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _latestJournal;
  Map<String, dynamic>? _dailyInsight;
  bool _loading = true;

  int selectedIndex = -1;
  bool _isSavingFeeling = false;

  // Nilai yang dikirim ke API — huruf kapital sesuai backend
  final List<String> _feelingValues = ['Happy', 'Calm', 'Sad', 'Neutral'];
  final List<String> _emojis = ["😍", "😄", "😢", "🙂"];

  @override
  UserProfileModel? user;
  String? profileImageUrl;
  void initState() {
    super.initState();
    _loadTodayFeeling();
    _loadDashboard();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final userData = await ProfileServices.getProfile();

    setState(() {
      user = userData;
    });
  }

  String? _getImageUrl() {
    if (_latestJournal == null) return null;

    final media = _latestJournal!['media'] as List<dynamic>? ?? [];

    final image = media.firstWhere(
      (m) => m['type'] == 'image',
      orElse: () => null,
    );

    return image != null ? image['url'] : null;
  }

  Future<void> _loadDashboard() async {
    final latest = await JournalServices.getLatestJournal();
    final insight = await JournalServices.getDailyInsight();

    setState(() {
      _latestJournal = latest;
      _dailyInsight = insight;
      _loading = false;
    });
  }

  Future<void> _loadTodayFeeling() async {
    final feeling = await FeelingServices.getTodayFeeling();
    if (feeling != null && mounted) {
      final idx = _feelingValues.indexOf(feeling.feeling);
      if (idx != -1) {
        setState(() => selectedIndex = idx);
      }
    }
  }

  Future<void> _onFeelingTap(int index) async {
    if (_isSavingFeeling) return;

    setState(() {
      selectedIndex = index;
      _isSavingFeeling = true;
    });

    final success = await FeelingServices.saveFeeling(_feelingValues[index]);

    setState(() => _isSavingFeeling = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? "Perasaan disimpan!" : "Gagal menyimpan perasaan"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String getGreetingKey() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'good_morning';
    } else if (hour > 15) {
      return 'good_afternoon';
    } else {
      return 'good_evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final moodLabels = [
      t['mood_happy']!,
      t['mood_calm']!,
      t['mood_sad']!,
      t['mood_neutral']!,
    ];

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color(0xFFF5F0FF),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                          image:
                              user?.picture != null && user!.picture!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(user!.picture!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: user?.picture == null || user!.picture!.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t[getGreetingKey()]!,
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            user?.name ?? "User",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationPage()),
                      ),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF9B7EBD).withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Color(0xFF7B5FA7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t['how_feeling']!,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7B5FA7),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(4, (index) {
                          return GestureDetector(
                            onTap: () => _onFeelingTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedIndex == index
                                    ? const Color(0xFF7B5FA7).withOpacity(0.2)
                                    : Colors.grey.shade200,
                              ),
                              child: Center(
                                child: Text(
                                  _emojis[index],
                                  style: TextStyle(
                                    fontSize: selectedIndex == index ? 36 : 28,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      if (_isSavingFeeling)
                        const CircularProgressIndicator(
                            color: Color(0xFF7B5FA7)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(4, (index) {
                      return Text(
                        moodLabels[index],
                        style: GoogleFonts.poppins(
                          color: selectedIndex == index
                              ? const Color(0xFF7B5FA7)
                              : Colors.grey,
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t['latest_memory']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7B5FA7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300.withOpacity(0.5),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300,
                        image: _getImageUrl() != null
                            ? DecorationImage(
                                image: NetworkImage(_getImageUrl()!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.25),
                                  BlendMode.darken,
                                ),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getImageUrl() != null
                                  ? Icons.photo
                                  : Icons.notes,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              t['photo']!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF9B7EBD),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _latestJournal?['created_at'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _latestJournal?['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _latestJournal?['note'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyInsight()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF9B7EBD),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.help, color: Color(0xFF7B5FA7)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dailyInsight?['title'] ?? 'Daily Insight',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dailyInsight?['content'] ?? '',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white70),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        onHomeTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        ),
        onJournalTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JournalPage()),
        ),
        onInsightTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InsightPage()),
        ),
        onProfileTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        ),
        onFabTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddJournal()),
        ),
      ),
    );
  }
}
