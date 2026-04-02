import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/services/sharelink_services.dart';
import 'package:snap_journal/services/journal_services.dart';
import 'package:snap_journal/services/theme_extension.dart';
import 'package:snap_journal/pages/view_shared_journal_page.dart';

class SharePage extends StatefulWidget {
  final String? preselectedJournalId;
  final String? preselectedJournalTitle;

  const SharePage({
    super.key,
    this.preselectedJournalId,
    this.preselectedJournalTitle,
  });

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  String _shareType = 'public';
  DateTime? _expiresAt;
  bool _isLoading = false;
  String? _shareToken;
  String? _shareUrl;
  List<dynamic> _journals = [];
  String? _selectedJournalId;
  String? _selectedJournalTitle;
  bool _isLoadingJournals = true;

  final TextEditingController _linkController = TextEditingController();
  bool _isLoadingOtherLink = false;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _loadJournals() async {
    final journals = await JournalServices.getJournals();
    setState(() {
      _journals = journals;
      _isLoadingJournals = false;
      if (widget.preselectedJournalId != null) {
        _selectedJournalId = widget.preselectedJournalId;
        _selectedJournalTitle = widget.preselectedJournalTitle;
      }
    });
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _createShareLink(Map<String, String> t) async {
    if (_selectedJournalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t['share_no_journal_selected']!)));
      return;
    }
    setState(() => _isLoading = true);
    final result = await ShareLinkServices.createShareLink(
      journalId: _selectedJournalId!,
      shareType: _shareType,
      expiresAt: _expiresAt,
    );
    setState(() => _isLoading = false);
    if (result != null) {
      setState(() {
        _shareToken = result['token'];
        _shareUrl = "${ShareLinkServices.baseUrl}/api/v1/l/${result['token']}";
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t['share_create_failed']!)));
      }
    }
  }

  Future<void> _revokeShareLink(Map<String, String> t) async {
    if (_shareToken == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t['share_revoke_title']!),
        content: Text(t['share_revoke_body']!),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t['cancel']!)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t['share_revoke_confirm']!,
                  style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    final success = await ShareLinkServices.revokeShareLink(_shareToken!);
    if (success) {
      setState(() {
        _shareToken = null;
        _shareUrl = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t['share_revoked_success']!)));
      }
    }
  }

  void _copyLink(Map<String, String> t) {
    if (_shareUrl == null) return;
    final browserUrl = "$_shareUrl/view";
    Clipboard.setData(ClipboardData(text: browserUrl));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t['share_copied']!)));
  }

  void _viewMyJournal() {
    if (_shareToken == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewSharedJournalPage(token: _shareToken!),
      ),
    );
  }

  String? _extractToken(String link) {
    try {
      final cleaned = link.trim().replaceAll(RegExp(r'/view$'), '');
      final uri = Uri.parse(cleaned);
      final segments = uri.pathSegments;
      final lIndex = segments.indexOf('l');
      if (lIndex != -1 && lIndex + 1 < segments.length) {
        return segments[lIndex + 1];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _viewOtherLink(Map<String, String> t) async {
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t['share_link_empty']!)));
      return;
    }
    final token = _extractToken(link);
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t['share_link_invalid']!)));
      return;
    }
    setState(() => _isLoadingOtherLink = true);
    final data = await ShareLinkServices.accessLink(token);
    setState(() => _isLoadingOtherLink = false);

    if (data == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t['share_link_not_found']!)));
      }
      return;
    }

    if (data['access'] == false) {
      final reason = data['reason'];
      if (reason == 'login_required') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t['share_login_required']!)));
        }
        return;
      }
      if (reason == 'request_required') {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(t['share_request_access_title']!),
            content: Text(t['share_request_access_body']!),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t['cancel']!)),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t['share_request_access_btn']!)),
            ],
          ),
        );
        if (confirm == true) {
          final success = await ShareLinkServices.requestAccess(token);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(success
                    ? t['share_request_sent']!
                    : t['share_request_failed']!)));
          }
        }
        return;
      }
      if (reason == 'pending') {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(t['share_pending']!)));
        }
        return;
      }
      if (reason == 'denied') {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(t['share_denied']!)));
        }
        return;
      }
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ViewSharedJournalPage(token: token),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;
    final primary = context.watchPrimaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primary,
        elevation: 0,
        centerTitle: false,
        title: Text(t['share_page_title']!,
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      backgroundColor: primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ════════════════════════════════════════
              // SECTION 1: BUKA LINK ORANG LAIN
              // ════════════════════════════════════════
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FF),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, color: primary, size: 20),
                        const SizedBox(width: 8),
                        Text(t['share_open_link_title']!,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t['share_open_link_subtitle']!,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _linkController,
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: t['share_paste_hint'],
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _linkController.clear(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingOtherLink
                            ? null
                            : () => _viewOtherLink(t),
                        icon: _isLoadingOtherLink
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.open_in_new,
                                color: Colors.white, size: 18),
                        label: Text(
                            _isLoadingOtherLink
                                ? t['share_opening']!
                                : t['share_open_btn']!,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ════════════════════════════════════════
              // SECTION 2: BAGIKAN JURNALMU
              // ════════════════════════════════════════
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FF),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.share, color: primary, size: 20),
                        const SizedBox(width: 8),
                        Text(t['share_my_journal_title']!,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primary)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(t['share_pick_journal']!,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primary)),
                    const SizedBox(height: 8),
                    _isLoadingJournals
                        ? Center(
                            child: CircularProgressIndicator(color: primary))
                        : DropdownButtonFormField<String>(
                            value: _selectedJournalId,
                            hint: Text(t['share_pick_journal_hint']!,
                                style: GoogleFonts.poppins(fontSize: 14)),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: primary),
                              ),
                            ),
                            items: _journals.map((j) {
                              return DropdownMenuItem<String>(
                                value: j['id'] as String,
                                child: Text(j['title'] ?? 'Tanpa Judul',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedJournalId = val;
                                _selectedJournalTitle = _journals
                                    .firstWhere((j) => j['id'] == val)['title'];
                                _shareToken = null;
                                _shareUrl = null;
                              });
                            },
                          ),
                    const SizedBox(height: 16),
                    Text(t['share_type']!,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _TypeChip(
                            label: t['share_public_label']!,
                            icon: Icons.public,
                            desc: t['share_public_desc']!,
                            selected: _shareType == 'public',
                            primary: primary,
                            onTap: () => setState(() => _shareType = 'public')),
                        const SizedBox(width: 10),
                        _TypeChip(
                            label: t['share_restricted_label']!,
                            icon: Icons.lock_outline,
                            desc: t['share_restricted_desc']!,
                            selected: _shareType == 'restricted',
                            primary: primary,
                            onTap: () =>
                                setState(() => _shareType = 'restricted')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(t['share_expiry']!,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickExpiryDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: primary),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _expiresAt == null
                                  ? t['share_no_expiry']!
                                  : DateFormat('dd MMM yyyy')
                                      .format(_expiresAt!),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _expiresAt == null
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                            const Spacer(),
                            if (_expiresAt != null)
                              GestureDetector(
                                onTap: () => setState(() => _expiresAt = null),
                                child: const Icon(Icons.close,
                                    size: 16, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ─── TOMBOL BUAT SHARE LINK ───
              if (_shareUrl == null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _createShareLink(t),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.link, color: Colors.white),
                    label: Text(
                        _isLoading
                            ? t['share_creating']!
                            : t['share_create_btn']!,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),

              // ─── HASIL SHARE LINK ───
              if (_shareUrl != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F0FF),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(t['share_success']!,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "$_shareUrl/view",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _copyLink(t),
                              icon: const Icon(Icons.copy,
                                  color: Colors.white, size: 18),
                              label: Text(t['share_copy_btn']!,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _revokeShareLink(t),
                              icon: const Icon(Icons.link_off,
                                  color: Colors.white, size: 18),
                              label: Text(t['share_revoke_btn']!,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _viewMyJournal,
                          icon: const Icon(Icons.visibility,
                              color: Colors.white, size: 18),
                          label: Text(t['share_view_btn']!,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      if (_shareType == 'restricted') ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.orange, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t['share_restricted_info']!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.orange.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String desc;
  final bool selected;
  final Color primary;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.desc,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.15)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected ? primary : Colors.grey.shade300,
                width: selected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? primary : Colors.grey, size: 24),
              const SizedBox(height: 4),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: selected ? primary : Colors.grey)),
              Text(desc,
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: selected ? primary : Colors.grey),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
