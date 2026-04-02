import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:snap_journal/services/sharelink_services.dart';
import 'package:snap_journal/services/theme_extension.dart';

class ViewSharedJournalPage extends StatefulWidget {
  final String token;
  const ViewSharedJournalPage({super.key, required this.token});

  @override
  State<ViewSharedJournalPage> createState() => _ViewSharedJournalPageState();
}

class _ViewSharedJournalPageState extends State<ViewSharedJournalPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _journal;
  String? _error;

  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadJournal() async {
    final data = await ShareLinkServices.accessLink(widget.token);

    print("ACCESS LINK RAW DATA: $data");

    setState(() {
      _isLoading = false;
      if (data != null && data['access'] == true) {
        // ✅ FIX: ambil dari data['journal'] karena struktur response:
        // { access: true, journal: { ... } }
        final journal = data['journal'];
        if (journal != null) {
          _journal = Map<String, dynamic>.from(journal);
          print("JOURNAL DATA: $_journal");
          print("MEDIA DATA: ${_journal!['media']}");
          _initVideo();
        } else {
          _error = "Data jurnal tidak ditemukan.";
        }
      } else if (data != null && data['access'] == false) {
        final reason = data['reason'];
        if (reason == 'login_required') {
          _error = "Kamu perlu login untuk mengakses jurnal ini.";
        } else if (reason == 'pending') {
          _error = "Permintaan aksesmu sedang menunggu persetujuan pemilik.";
        } else if (reason == 'denied') {
          _error = "Aksesmu ditolak oleh pemilik jurnal.";
        } else {
          _error = "Kamu tidak memiliki akses ke jurnal ini.";
        }
      } else {
        _error =
            "Gagal memuat jurnal.\nMungkin link sudah kadaluarsa atau dicabut.";
      }
    });
  }

  void _initVideo() {
    if (_journal == null) return;
    final media = _journal!['media'];
    if (media == null || media is! List) return;

    final videoList = media
        .where((m) => m is Map && m['type'] == 'video')
        .toList();

    if (videoList.isNotEmpty) {
      final videoUrl = videoList.first['url'] as String;
      print("VIDEO URL: $videoUrl");
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

  List<dynamic> _getImages() {
    final media = _journal?['media'];
    if (media == null || media is! List) return [];
    return media.where((m) => m is Map && m['type'] == 'image').toList();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.watchPrimaryColor;
    final scaffoldBg = context.scaffoldColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _journal?['title'] ?? "Shared Journal",
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: primary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link_off, color: Colors.grey, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ─── TANGGAL ───
                      Text(
                        _formatDate(_journal!['created_at']),
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),

                      // ─── JUDUL ───
                      Text(
                        _journal!['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary),
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
                                    decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 36),
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
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: CircularProgressIndicator(color: primary)),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ─── FOTO ───
                      Builder(builder: (_) {
                        final images = _getImages();
                        print("IMAGES COUNT: ${images.length}");
                        if (images.isEmpty) return const SizedBox();
                        return Column(
                          children: [
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  final imageUrl =
                                      images[index]['url'] as String?;
                                  print("IMAGE URL $index: $imageUrl");
                                  if (imageUrl == null) return const SizedBox();
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image,
                                                color: Colors.grey),
                                        loadingBuilder:
                                            (_, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child: CircularProgressIndicator(
                                                  color: primary,
                                                  strokeWidth: 2));
                                        },
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
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Text(
                            _journal!['note'],
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}