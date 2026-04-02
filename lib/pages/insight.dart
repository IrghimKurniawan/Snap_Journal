import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/theme_extension.dart';
import 'package:snap_journal/additional pages/share.dart';
import 'package:snap_journal/package/navigationbar.dart';
import 'package:snap_journal/pages/dashboard.dart';
import 'package:snap_journal/pages/journal.dart';
import 'package:snap_journal/pages/new_journal.dart';
import 'package:snap_journal/pages/profile.dart';
import 'package:snap_journal/package/calendar_realtime.dart';
import 'package:snap_journal/services/feeling_services.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});
  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  String? _topMood;
  String? _topEmoji;
  Map<String, dynamic>? _periodicInsight;
  List<dynamic> _moodCalendar = [];
  bool _isLoading = true;
  bool _loading = true;

  static const Map<String, String> moodEmoji = {
    'Happy': '😍',
    'Calm': '😄',
    'Sad': '😢',
    'Tired': '😴',
    'Angry': '😠',
    'Neutral': '🙂',
  };

  @override
  void initState() {
    super.initState();
    _loadTopMood();
    _loadInsight();
  }

  Future<void> _loadTopMood() async {
    final history = await FeelingServices.getFeelingHistory();
    if (history.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    final Map<String, int> moodCount = {};
    for (final item in history) {
      final mood = item['mood'] as String?;
      if (mood != null) moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }
    final topMood =
        moodCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    setState(() {
      _topMood = topMood;
      _topEmoji = moodEmoji[topMood];
      _isLoading = false;
    });
  }

  Future<void> _loadInsight() async {
    final periodic = await JournalServices.getPeriodicInsight();
    final calendar = await JournalServices.getMoodCalendar();
    setState(() {
      _periodicInsight = periodic;
      _moodCalendar = calendar;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final primary = context.watchPrimaryColor;
    final scaffoldBg = context.scaffoldColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: false,
        title: Text(t['journal_insight']!,
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SharePage())),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: primary.withOpacity(0.15)),
                child: Icon(Icons.share_outlined, color: primary),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RealTimeCalendar(moods: _moodCalendar),
                const SizedBox(height: 15),
                Text(t['monthly_summary']!,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(_topMood ?? t['top_mood']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFF5F0FF))),
                            const SizedBox(height: 8),
                            _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : _topMood == null
                                    ? Text("—",
                                        style: GoogleFonts.poppins(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFF5F0FF)))
                                    : Column(
                                        children: [
                                          Text(_topEmoji ?? '',
                                              style: const TextStyle(
                                                  fontSize: 30)),
                                          const SizedBox(height: 4),
                                          Text(_topMood!,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFFF5F0FF))),
                                        ],
                                      ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(t['journal_entries']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFF5F0FF))),
                            const SizedBox(height: 8),
                            Text("${_periodicInsight?['total_entries'] ?? 0}",
                                style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFF5F0FF))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 105,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: primary),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Icon(Icons.help, color: primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                _periodicInsight?['title'] ??
                                    t['daily_insight']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(
                                _periodicInsight?['content'] ??
                                    t['daily_insight_body']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.white70),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis),
                          ],
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
      bottomNavigationBar: CustomBottomNavbar(
        onHomeTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => DashboardPage())),
        onJournalTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => JournalPage())),
        onInsightTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => InsightPage())),
        onProfileTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => ProfilePage())),
        onFabTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddJournal())),
      ),
    );
  }
}
