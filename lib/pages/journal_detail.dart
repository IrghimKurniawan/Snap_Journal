import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class JournalDetailPage extends StatefulWidget {
  final String journalId;
  const JournalDetailPage({super.key, required this.journalId});

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  Map<String, dynamic>? _journal;
  bool _isLoading = true;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    final result = await JournalServices.getJournalById(widget.journalId);
    if (result != null) {
      setState(() {
        _journal = result;
        _isLoading = false;
      });
      _initVideo();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _initVideo() {
    final media = _journal?['media'] as List<dynamic>? ?? [];
    final videoMedia = media.where((m) => m['type'] == 'video').toList();
    if (videoMedia.isNotEmpty) {
      final videoUrl = videoMedia.first['url'] as String;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void _togglePlay() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('EEEE, MMM d yyyy • HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9B7EBD)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_journal != null)
            IconButton(
              icon: Icon(
                _journal!['is_favorite'] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _journal!['is_favorite'] == true
                    ? Colors.red
                    : const Color(0xFF9B7EBD),
              ),
              onPressed: () async {
                final success =
                    await JournalServices.toggleFavorite(_journal!['id']);
                if (success) {
                  setState(() {
                    _journal!['is_favorite'] =
                        !(_journal!['is_favorite'] ?? false);
                  });
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF9B7EBD)))
          : _journal == null
              ? const Center(child: Text("Jurnal tidak ditemukan"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ─── TANGGAL ───
                      Text(
                        _formatDate(_journal!['created_at']),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ─── JUDUL ───
                      Text(
                        _journal!['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7B5FA7),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ─── VIDEO ───
                      if (_videoController != null &&
                          _videoController!.value.isInitialized) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(_videoController!),
                                GestureDetector(
                                  onTap: _togglePlay,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else if ((_journal!['media'] as List<dynamic>?)
                              ?.any((m) => m['type'] == 'video') ==
                          true) ...[
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF9B7EBD)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ─── FOTO ───
                      Builder(builder: (_) {
                        final media =
                            _journal!['media'] as List<dynamic>? ?? [];
                        final images =
                            media.where((m) => m['type'] == 'image').toList();
                        if (images.isEmpty) return const SizedBox();
                        return Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(images[index]['url']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),

                      // ─── NOTE ───
                      if (_journal!['note'] != null &&
                          _journal!['note'].toString().isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _journal!['note'],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
