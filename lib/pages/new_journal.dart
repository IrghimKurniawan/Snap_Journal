// lib/pages/new_journal.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_journal/services/media_services.dart';
import 'package:snap_journal/services/journal_services.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({super.key});
  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  List<String> _uploadedImageUrls = []; // URL hasil upload
  List<File> _selectedImages = []; // File lokal untuk preview
  bool _isUploadingImage = false;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  // Pilih dan upload foto
  Future<void> _pickAndUploadImage() async {
    if (_uploadedImageUrls.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maksimal 3 foto")),
      );
      return;
    }

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    final file = File(picked.path);

    setState(() => _isUploadingImage = true);

    final result = await MediaServices.uploadImage(file);

    setState(() => _isUploadingImage = false);

    if (result != null) {
      setState(() {
        _uploadedImageUrls.add(result.url);
        _selectedImages.add(file);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto berhasil diupload!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal upload foto")),
      );
    }
  }

  // Hapus foto
  Future<void> _removeImage(int index) async {
    final url = _uploadedImageUrls[index];
    await MediaServices.deleteMedia(url);
    setState(() {
      _uploadedImageUrls.removeAt(index);
      _selectedImages.removeAt(index);
    });
  }

  // Save journal
  Future<void> _saveJournal({bool isDraft = false}) async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul wajib diisi!")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await JournalServices.createJournal(
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      imageUrls: _uploadedImageUrls,
      isDraft: isDraft,
    );

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDraft
              ? "Jurnal disimpan sebagai draft!"
              : "Jurnal berhasil disimpan!"),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan jurnal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F0FF),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF9B7EBD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t['new_journal']!,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9B7EBD),
          ),
        ),
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
                    color: const Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tanggal
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month,
                                size: 14, color: Colors.black87),
                            const SizedBox(width: 4),
                            Text(
                              "Today, ${DateFormat('MMM d').format(DateTime.now())}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        t['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF5F0FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "${t['title']}...",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF9B7EBD),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Note
                      Text(
                        t['note']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF5F0FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: noteController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "${t['note']}...",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF9B7EBD),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── MEDIA ───
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7EBD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['add_media']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF5F0FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tombol pilih foto
                      GestureDetector(
                        onTap: _isUploadingImage ? null : _pickAndUploadImage,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9B7EBD),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: _isUploadingImage
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 28),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${t['photo']} (${_uploadedImageUrls.length}/3)",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Preview foto yang sudah diupload
                      if (_selectedImages.isNotEmpty) ...[
                        Text(
                          t['preview']!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFF5F0FF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            FileImage(_selectedImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Tombol hapus foto
                                  Positioned(
                                    top: 0,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // ─── TOMBOL SAVE ───
                GestureDetector(
                  onTap: _isSaving ? null : () => _saveJournal(isDraft: false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isSaving ? Colors.grey : Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save,
                                    color: Color(0xFFF5F0FF), size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  t['save']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFF5F0FF),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // ─── TOMBOL SAVE AS DRAFT ───
                GestureDetector(
                  onTap: _isSaving ? null : () => _saveJournal(isDraft: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color(0xFF9B7EBD), width: 1.5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.drafts,
                              color: Color(0xFF9B7EBD), size: 28),
                          const SizedBox(width: 10),
                          Text(
                            t['save_as_draft']!,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9B7EBD),
                            ),
                          ),
                        ],
                      ),
                    ),
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
