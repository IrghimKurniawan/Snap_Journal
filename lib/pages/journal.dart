import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/theme_extension.dart';
import 'package:snap_journal/package/navigationbar.dart';
import 'package:snap_journal/pages/dashboard.dart';
import 'package:snap_journal/additional%20pages/search.dart';
import 'package:snap_journal/pages/draft.dart';
import 'package:snap_journal/pages/insight.dart';
import 'package:snap_journal/pages/new_journal.dart';
import 'package:snap_journal/pages/profile.dart';
import 'package:snap_journal/pages/journal_detail.dart';
import 'package:snap_journal/pages/edit_journal.dart';
// ✅ FIX: import dari additional pages karena share.dart ada di sana
import 'package:snap_journal/additional%20pages/share.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<dynamic> _journals = [];
  bool _isLoading = true;
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    setState(() => _isLoading = true);
    final result = await JournalServices.getJournals();
    setState(() {
      _journals = result;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(int index) async {
    final journal = _journals[index];
    final newValue = !(journal['is_favorite'] ?? false);
    final success =
        await JournalServices.toggleFavorite(journal['id'], newValue);
    if (success) {
      setState(() {
        _journals[index]['is_favorite'] = newValue;
      });
    }
  }

  Future<void> _deleteJournal(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Jurnal"),
        content: const Text("Yakin ingin menghapus jurnal ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await JournalServices.deleteJournal(id);
    if (success) {
      setState(() => _journals.removeWhere((j) => j['id'] == id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jurnal berhasil dihapus")),
      );
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM d').format(date);
    } catch (_) {
      return '';
    }
  }

  List<dynamic> get _filteredJournals {
    if (_showFavorites) {
      return _journals.where((j) => j['is_favorite'] == true).toList();
    }
    return _journals;
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final primary = context.watchPrimaryColor;
    final scaffoldBg = context.scaffoldColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: scaffoldBg,
          elevation: 0,
          centerTitle: false,
          title: Text(
            t['my_journal']!,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 10),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SearchPage()),
                  ),
                  icon: Icon(Icons.search, color: primary),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadJournals,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ─── FILTER BUTTONS ───
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DraftPage()),
                      ),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(t['draft']!,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _showFavorites = !_showFavorites),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: _showFavorites ? primary : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(t['favorites']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── JOURNAL GRID 2 KOLOM ───
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: primary))
                    : _filteredJournals.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                const Icon(Icons.book_outlined,
                                    size: 60, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(
                                  _showFavorites
                                      ? "Tidak ada jurnal favorit"
                                      : "Belum ada jurnal",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _filteredJournals.length,
                            itemBuilder: (context, index) {
                              final journal = _filteredJournals[index];
                              final media =
                                  journal['media'] as List<dynamic>? ?? [];
                              final imageUrl = media
                                      .where((m) => m['type'] == 'image')
                                      .isNotEmpty
                                  ? media.firstWhere(
                                      (m) => m['type'] == 'image')['url']
                                  : null;
                              final isFavorite =
                                  journal['is_favorite'] ?? false;

                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JournalDetailPage(
                                        journalId: journal['id']),
                                  ),
                                ).then((_) => _loadJournals()),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey.shade300,
                                    image: imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.2),
                                              BlendMode.darken,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      // ─── POPUP MENU (titik 3) ───
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert,
                                              color: Colors.white),
                                          onSelected: (value) async {
                                            if (value == "delete") {
                                              _deleteJournal(
                                                  journal['id'].toString());
                                            } else if (value == "edit") {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditJournalPage(
                                                          draft: journal),
                                                ),
                                              );
                                              _loadJournals();
                                            } else if (value == "share") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => SharePage(
                                                    preselectedJournalId:
                                                        journal['id']
                                                            .toString(),
                                                    preselectedJournalTitle:
                                                        journal['title'] ?? '',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: "edit",
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  SizedBox(width: 8),
                                                  Text("Edit"),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: "share",
                                              child: Row(
                                                children: [
                                                  Icon(Icons.share,
                                                      color: Colors.green),
                                                  SizedBox(width: 8),
                                                  Text("Share"),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: "delete",
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text("Hapus"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ─── FAVORITE BUTTON ───
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () => _toggleFavorite(index),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // ─── INFO JURNAL ───
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          height: 90,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _formatDate(
                                                    journal['created_at']),
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                journal['title'] ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                journal['note'] ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
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
