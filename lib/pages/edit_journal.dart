// lib/pages/edit_journal.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/theme_extension.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_journal/services/media_services.dart';
import 'package:snap_journal/services/journal_services.dart';

class EditJournalPage extends StatefulWidget {
  final Map<String, dynamic> draft;
  const EditJournalPage({super.key, required this.draft});

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController titleController;
  late TextEditingController noteController;

  List<String> _existingImageUrls = [];
  List<String> _newUploadedImageUrls = [];
  List<Uint8List> _newImageBytes = [];
  XFile? _selectedVideo;
  bool _isUploadingImage = false;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.draft['title'] ?? '');
    noteController = TextEditingController(text: widget.draft['note'] ?? '');
    final media = widget.draft['media'] as List<dynamic>? ?? [];
    _existingImageUrls = media
        .where((m) => m['type'] == 'image')
        .map<String>((m) => m['url'] as String)
        .toList();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final totalImages =
        _existingImageUrls.length + _newUploadedImageUrls.length;
    if (totalImages >= 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Maksimal 3 foto")));
      return;
    }
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    setState(() => _isUploadingImage = true);
    final result = await MediaServices.uploadImageFromXFile(picked);
    if (result != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _newUploadedImageUrls.add(result.url);
        _newImageBytes.add(bytes);
      });
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto berhasil diupload!")));
    } else {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Gagal upload foto")));
    }
    setState(() => _isUploadingImage = false);
  }

  Future<void> _removeExistingImage(int index) async {
    final url = _existingImageUrls[index];
    await MediaServices.deleteMedia(url);
    setState(() => _existingImageUrls.removeAt(index));
  }

  Future<void> _removeNewImage(int index) async {
    final url = _newUploadedImageUrls[index];
    await MediaServices.deleteMedia(url);
    setState(() {
      _newUploadedImageUrls.removeAt(index);
      _newImageBytes.removeAt(index);
    });
  }

  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 5));
    if (picked == null) return;
    setState(() => _selectedVideo = picked);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Video dipilih: ${picked.name}")));
  }

  void _removeVideo() => setState(() => _selectedVideo = null);

  List<String> get _allImageUrls =>
      [..._existingImageUrls, ..._newUploadedImageUrls];

  bool get _hasExistingVideo {
    final media = widget.draft['media'] as List<dynamic>? ?? [];
    return media.any((m) => m['type'] == 'video');
  }

  Future<void> _saveDraft() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Judul wajib diisi!")));
      return;
    }
    setState(() => _isSaving = true);
    final success = await JournalServices.updateJournal(
      id: widget.draft['id'],
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      imageUrls: _allImageUrls,
      videoFile: _selectedVideo,
    );
    setState(() => _isSaving = false);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Draft berhasil diupdate!")));
        Navigator.pop(context, true);
      }
    } else {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mengupdate draft")));
    }
  }

  Future<void> _publishJournal() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Judul wajib diisi!")));
      return;
    }
    if (!_hasExistingVideo && _selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Video wajib diisi untuk publish jurnal!")));
      return;
    }
    setState(() => _isSaving = true);
    await JournalServices.updateJournal(
      id: widget.draft['id'],
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      imageUrls: _allImageUrls,
      videoFile: _selectedVideo,
    );
    final success = await JournalServices.publishDraft(widget.draft['id']);
    setState(() => _isSaving = false);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Jurnal berhasil dipublish!")));
        Navigator.pop(context, true);
      }
    } else {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mempublish jurnal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final primary = context.watchPrimaryColor;
    final totalImages =
        _existingImageUrls.length + _newUploadedImageUrls.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldColor,
        leading: IconButton(
            icon: Icon(Icons.close, color: primary),
            onPressed: () => Navigator.pop(context)),
        title: Text("Edit Draft",
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // ─── TITLE & NOTE ───
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 28,
                        decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.calendar_month,
                              size: 14, color: Colors.black87),
                          const SizedBox(width: 4),
                          Text(
                              "Today, ${DateFormat('MMM d').format(DateTime.now())}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87)),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Text(t['title']!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFF5F0FF))),
                      const SizedBox(height: 8),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "${t['title']}...",
                            hintStyle: GoogleFonts.poppins(
                                color: primary, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(t['note']!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFF5F0FF))),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F0FF),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: noteController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "${t['note']}...",
                            hintStyle: GoogleFonts.poppins(
                                color: primary, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── FOTO ───
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['add_media']!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFF5F0FF))),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _isUploadingImage ? null : _pickAndUploadImage,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white, width: 1.5)),
                          child: _isUploadingImage
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      const Icon(Icons.photo,
                                          color: Colors.white, size: 28),
                                      const SizedBox(height: 8),
                                      Text("${t['photo']} ($totalImages/3)",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_existingImageUrls.isNotEmpty) ...[
                        Text("Foto sekarang",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _existingImageUrls.length,
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              _existingImageUrls[index]),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeExistingImage(index),
                                      child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.close,
                                              size: 14, color: Colors.white)),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_newImageBytes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text("Foto baru",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _newImageBytes.length,
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: MemoryImage(
                                              _newImageBytes[index]),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeNewImage(index),
                                      child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.close,
                                              size: 14, color: Colors.white)),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── VIDEO ───
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text("Video",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFF5F0FF))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text("Wajib untuk Publish",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      if (_hasExistingVideo && _selectedVideo == null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green)),
                          child: const Row(children: [
                            Icon(Icons.check_circle,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text("Video sudah ada",
                                style: TextStyle(color: Colors.white)),
                          ]),
                        ),
                        const SizedBox(height: 8),
                      ],
                      GestureDetector(
                        onTap: _pickVideo,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: _selectedVideo != null
                                ? Colors.green.withOpacity(0.3)
                                : primary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _selectedVideo != null
                                    ? Colors.green
                                    : Colors.white,
                                width: 1.5),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    _selectedVideo != null
                                        ? Icons.check_circle
                                        : Icons.videocam,
                                    color: Colors.white,
                                    size: 28),
                                const SizedBox(height: 8),
                                Text(
                                    _selectedVideo != null
                                        ? _selectedVideo!.name
                                        : "Ganti Video",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis),
                              ]),
                        ),
                      ),
                      if (_selectedVideo != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _removeVideo,
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline,
                                    color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Text("Hapus Video",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ]),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // ─── TOMBOL PUBLISH ───
                GestureDetector(
                  onTap: _isSaving ? null : _publishJournal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: _isSaving ? Colors.grey : Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Icon(Icons.publish,
                                        color: Color(0xFFF5F0FF), size: 28),
                                    const SizedBox(width: 10),
                                    Text("Publish Jurnal",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFF5F0FF))),
                                  ])),
                  ),
                ),
                const SizedBox(height: 5),

                // ─── TOMBOL SIMPAN DRAFT ───
                GestureDetector(
                  onTap: _isSaving ? null : _saveDraft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: primary, width: 1.5)),
                    child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.save, color: primary, size: 28),
                          const SizedBox(width: 10),
                          Text("Simpan Draft",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: primary)),
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
