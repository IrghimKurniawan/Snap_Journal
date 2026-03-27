import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:snap_journal/pages/journal_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  List<dynamic> _journals = [];
  bool _isLoading = false;

  List<String> recentSearch = ["Berolahraga", "Menangis", "Jalan Jalan"];

  Future<void> _searchJournal() async {
    if (searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final result = await JournalServices.searchJournal(searchController.text);

    setState(() {
      _journals = result;
      _isLoading = false;

      if (!recentSearch.contains(searchController.text)) {
        recentSearch.insert(0, searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9B7EBD),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9B7EBD),
                Color(0xFFF3ECF8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    /// BACK BUTTON
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF7B5FA7),
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// SEARCH FIELD
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFF7B5FA7)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onSubmitted: (value) {
                                  _searchJournal();
                                },
                                decoration: InputDecoration(
                                  hintText: "Search Journal...",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9B7EBD),
                          ),
                        )
                      : _journals.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: _journals.length,
                              itemBuilder: (context, index) {
                                final journal = _journals[index];

                                final media =
                                    journal['media'] as List<dynamic>? ?? [];

                                final imageUrl = media
                                        .where((m) => m['type'] == 'image')
                                        .isNotEmpty
                                    ? media.firstWhere(
                                        (m) => m['type'] == 'image')['url']
                                    : null;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>  JournalDetailPage( 
                                          journalId: journal['id'],
                                        ),
                                      ),
                                    );
                                  },
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
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF9B7EBD),
                                          borderRadius: BorderRadius.only(
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
                                  ),
                                );
                              },
                            )

                          /// RECENT SEARCH
                          : ListView(
                              children: [
                                Text(
                                  "Recent Search",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...recentSearch.map((text) {
                                  return Container(
                                    height: 42,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.history,
                                            color: Colors.grey),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            text,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              recentSearch.remove(text);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 30),
                                Column(
                                  children: [
                                    const Icon(Icons.search,
                                        color: Colors.white54, size: 40),
                                    const SizedBox(height: 10),
                                    Text(
                                      "No More Results",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
