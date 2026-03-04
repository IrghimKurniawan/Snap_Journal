// lib/additional pages/notification.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/services/language_provider.dart';
import 'package:snap_journal/models/notification_model.dart';
import 'package:snap_journal/services/notification_services.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final result = await NotificationServices.getNotifications();
    setState(() {
      _notifications = result ?? [];
      _isLoading = false;
    });
  }

  Future<void> _markAsRead(NotificationModel notif) async {
    if (notif.isRead) return;
    final success = await NotificationServices.markAsRead(notif.id);
    if (success) await _loadNotifications();
  }

  Future<void> _deleteNotification(String id) async {
    final success = await NotificationServices.deleteNotification(id);
    if (success) {
      setState(() => _notifications.removeWhere((n) => n.id == id));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus notifikasi")),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Semua Notifikasi"),
        content: const Text("Yakin ingin menghapus semua notifikasi?"),
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

    final success = await NotificationServices.clearAllNotifications();
    if (success) {
      setState(() => _notifications = []);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus semua notifikasi")),
      );
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).text;

    final todayNotifs =
        _notifications.where((n) => _isToday(n.createdAt)).toList();
    final olderNotifs =
        _notifications.where((n) => !_isToday(n.createdAt)).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF9B7EBD),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        t['notifications']!,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _clearAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t['clear']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF9B7EBD),
                          fontWeight: FontWeight.bold,
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
      backgroundColor: const Color(0xFF9B7EBD),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off,
                            color: Colors.white54, size: 60),
                        const SizedBox(height: 12),
                        Text(
                          "Tidak ada notifikasi",
                          style: GoogleFonts.poppins(
                              color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotifications,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todayNotifs.isNotEmpty) ...[
                            Text(
                              t['today']!,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            ...todayNotifs
                                .map((n) => _buildNotifCard(n, dimmed: false)),
                            const SizedBox(height: 16),
                          ],
                          if (olderNotifs.isNotEmpty) ...[
                            Text(
                              t['yesterday']!,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            ...olderNotifs
                                .map((n) => _buildNotifCard(n, dimmed: true)),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildNotifCard(NotificationModel notif, {required bool dimmed}) {
    return Opacity(
      opacity: dimmed || notif.isRead ? 0.6 : 1.0,
      child: Dismissible(
        key: Key(notif.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => _deleteNotification(notif.id),
        child: GestureDetector(
          onTap: () => _markAsRead(notif),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notif.isRead
                  ? const Color(0xFFEDEDED)
                  : const Color(0xFFF5F0FF),
              borderRadius: BorderRadius.circular(20),
              border: notif.isRead
                  ? null
                  : Border.all(color: const Color(0xFF9B7EBD), width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    notif.isRead
                        ? Icons.notifications
                        : Icons.notifications_active,
                    color: const Color(0xFF9B7EBD),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notif.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: const Color(0xFF7B5FA7),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _deleteNotification(notif.id),
                            child: const Icon(Icons.close,
                                size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.message,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9B7EBD)),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(notif.createdAt),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
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
