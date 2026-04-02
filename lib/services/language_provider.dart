import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = 'English';

  String get language => _language;

  Map<String, String> get text => _language == 'Indonesia' ? _id : _en;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  // ===================== ENGLISH =====================
  static const Map<String, String> _en = {
    // NAVBAR
    'nav_home': 'Home',
    'nav_journal': 'Journal',
    'nav_insight': 'Insight',
    'nav_profile': 'Profile',

    // DASHBOARD
    'how_feeling': 'How Are You Feeling ?',
    'latest_memory': 'Latest Memory',
    'daily_insight': 'Daily Insight',
    'daily_insight_body':
        'Prioritize consistency over strength while training.',
    'mood_happy': 'Happy',
    'mood_calm': 'Calm',
    'mood_sad': 'Sad',
    'mood_neutral': 'Neutral',
    'sample_title': 'Exercise',
    'sample_body': 'Exercised on Monday morning.',

    // JOURNAL
    'my_journal': 'My Journal',
    'draft': 'Draft',
    'favorites': 'Favorites',

    // DRAFT
    'draft_title': 'Draft',

    // NEW JOURNAL
    'new_journal': 'New Journal',
    'title': 'Title',
    'note': 'Note',
    'add_media': 'Add Media',
    'preview': 'Preview',
    'photo': 'Photo',
    'video': 'Video',
    'save': 'Save',
    'save_as_draft': 'Save as Draft',

    // INSIGHT
    'journal_insight': 'Journal Insight',
    'monthly_summary': 'Monthly Summary',
    'top_mood': 'Top Mood',
    'journal_entries': 'Journal Entries',

    // PROFILE
    'profile': 'Profile',
    'general': 'General',
    'account_info': 'Account Info',
    'notification': 'Notification',
    'appearance': 'Appearance & Experience',
    'themes': 'Themes',
    'language_settings': 'Language Settings',
    'data_privacy': 'Data & Privacy',
    'privacy_policy': 'Privacy & Policy',
    'sign_out': 'Sign Out',
    'version': 'Version 0.0.0',

    // ACCOUNT INFO
    'account_info_title': 'Account Info',
    'name': 'Name',
    'bio': 'Bio',
    'email': 'Email',
    'password': 'Password',
    'change_gmail': 'Change Gmail',
    'change_password': 'Change Password',
    'save_changes': 'Save Changes',
    'delete_account': 'Delete Account',
    'delete_confirm_title': 'Delete Account',
    'delete_confirm_body':
        'Are you sure you want to delete your account? This action cannot be undone.',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'changes_saved': 'Changes saved!',

    // PRIVACY POLICY
    'privacy_policy_title': 'Privacy & Policy',
    'privacy_protection': 'Privacy Protection',
    'privacy_protection_body':
        'We take the security of your data seriously.\nYour journal, mood, and activity data is stored safely and only used to improve your app experience.\nWe do not sell or share your personal data with third parties without permission.',
    'data_usage': 'Data Usage & User Rights',
    'data_usage_body':
        'Data is used to display personal insights, store activity history, and develop app features.\nYou have the right to access, modify, or delete your data at any time through the app.',
    'back': 'Back',

    // THEMES
    'themes_title': 'Themes',
    'appearance_label': 'Appearance',
    'dark_mode': 'Dark Mode',
    'color_themes': 'Color Themes',
    'accent_color': 'Accent Color',

    // CHANGE EMAIL
    'change_email_title': 'Change Email',
    'current_email': 'Current Email',
    'new_email': 'New Email',
    'new_email_hint': 'Enter new email',
    'otp': 'OTP',
    'confirm_password': 'Confirm Password',

    // CHANGE PASSWORD
    'change_password_title': 'Change Password',
    'old_password': 'Old Password',
    'new_password': 'New Password',

    // NOTIFICATION
    'notifications': 'Notifications',
    'clear': 'Clear',
    'today': 'Today',
    'yesterday': 'Yesterday',

    // DAILY INSIGHT
    'daily_insight_title': 'Daily Insight',
    'analysis': 'Analysis',
    'insight_positive': 'You are in a fairly positive phase.',
    'insight_consistency': 'Consistency in Health',
    'insight_analysis':
        'In the last few days\n Your mood has been stable and\n predominantly positive',

    // SHARE
    'share': 'Share',
    'share_now': 'Share Now',
    'share_page_title': 'Share',
    'share_open_link_title': 'Open Journal Link',
    'share_open_link_subtitle':
        "Paste your friend's share link to view their journal",
    'share_paste_hint': 'Paste journal link here...',
    'share_open_btn': 'Open Journal',
    'share_opening': 'Opening...',
    'share_my_journal_title': 'Share Your Journal',
    'share_pick_journal': 'Pick Journal',
    'share_pick_journal_hint': 'Select a journal...',
    'share_type': 'Share Type',
    'share_public_label': 'Public',
    'share_public_desc': 'Anyone can access',
    'share_restricted_label': 'Restricted',
    'share_restricted_desc': 'Requires approval',
    'share_expiry': 'Expiry (Optional)',
    'share_no_expiry': 'No expiry',
    'share_create_btn': 'Create Share Link',
    'share_creating': 'Creating link...',
    'share_success': 'Link created successfully!',
    'share_copy_btn': 'Copy Link',
    'share_revoke_btn': 'Revoke Link',
    'share_view_btn': 'View Journal',
    'share_restricted_info':
        'This link is restricted — others need to request access and you must approve it.',
    'share_revoke_title': 'Revoke Share Link',
    'share_revoke_body': 'This link will no longer be accessible. Continue?',
    'share_revoke_confirm': 'Revoke',
    'share_revoked_success': 'Share link revoked successfully',
    'share_copied': 'Link copied to clipboard!',
    'share_no_journal_selected': 'Please select a journal first',
    'share_create_failed': 'Failed to create share link',
    'share_link_empty': 'Please enter a link first',
    'share_link_invalid': 'Invalid link format',
    'share_link_not_found': 'Link not found, expired, or requires approval',
    'share_login_required': 'You need to login to access this link',
    'share_request_access_title': 'Restricted Access',
    'share_request_access_body':
        "This journal requires the owner's approval. Request access?",
    'share_request_access_btn': 'Request Access',
    'share_request_sent': 'Access request sent!',
    'share_request_failed': 'Failed to send request',
    'share_pending': 'Your access request is pending approval',
    'share_denied': 'Your access was denied by the journal owner',

    // VERIFICATION
    'verification': 'Verification',
    'verify_email': 'Verify Your Email',
    'verify_body':
        'We sent a 4-digit code to your email. enter it below open the Journal',
    'resend_code': '00:10 • Resend code',
    'confirm': 'Confirm',

    // LOGIN
    'login': 'Login',
    'welcome': 'Welcome To Diary Journal',
    'login_subtitle': 'Log in To Continue',
    'forgot_password': 'Forgot Password?',
    'no_account': 'New here? Create account to start.',

    // REGISTER
    'register': 'Register',
    'create_account': 'Create Account',
    'enter_details': 'Enter Your Details',
    'full_name': 'Full Name',
    'confirm_password_label': 'Confirm Password',
    'have_account': 'Already have an account? Login.',

    //forgot password email
    'forgot_password_title': 'Forgot Password',
    'enter_email': 'Enter Your Email',
    'send': 'Send',

    //forgot password otp
    'enter_otp': 'OTP has been sent to your email address.',
    'send_otp': 'Enter Otp',

    //enter password
    'reset_password_title': 'Reset Password',
    'enter_new_password': 'Enter New Password',
    'confirm_new_password': 'Confirm New Password',
    'update_password': 'Update Password',

    //selamat
    'good_morning': 'Good Morning',
    'good_afternoon': 'Good Afternoon',
    'good_evening': 'Good Evening'
  };

  // ===================== INDONESIA =====================
  static const Map<String, String> _id = {
    // NAVBAR
    'nav_home': 'Beranda',
    'nav_journal': 'Jurnal',
    'nav_insight': 'Wawasan',
    'nav_profile': 'Profil',

    // DASHBOARD
    'how_feeling': 'Bagaimana Perasaanmu ?',
    'latest_memory': 'Kenangan Terbaru',
    'daily_insight': 'Wawasan Harian',
    'daily_insight_body':
        'Konsisten Berolahraga Setiap Hari, bukan soal kuat tapi soal komitmen.',
    'mood_happy': 'Senang',
    'mood_calm': 'Tenang',
    'mood_sad': 'Sedih',
    'mood_neutral': 'Netral',
    'sample_title': 'Olahraga',
    'sample_body': 'Berolahraga di Senin pagi.',

    // JOURNAL
    'my_journal': 'Jurnalku',
    'draft': 'Draf',
    'favorites': 'Favorit',

    // DRAFT
    'draft_title': 'Draf',

    // NEW JOURNAL
    'new_journal': 'Jurnal Baru',
    'title': 'Judul',
    'note': 'Catatan',
    'add_media': 'Tambah Media',
    'preview': 'Pratinjau',
    'photo': 'Foto',
    'video': 'Video',
    'save': 'Simpan',
    'save_as_draft': 'Simpan sebagai Draf',

    // INSIGHT
    'journal_insight': 'Wawasan Jurnal',
    'monthly_summary': 'Ringkasan Bulanan',
    'top_mood': 'Mood Terbaik',
    'journal_entries': 'Entri Jurnal',

    // PROFILE
    'profile': 'Profil',
    'general': 'Umum',
    'account_info': 'Info Akun',
    'notification': 'Notifikasi',
    'appearance': 'Tampilan & Pengalaman',
    'themes': 'Tema',
    'language_settings': 'Pengaturan Bahasa',
    'data_privacy': 'Data & Privasi',
    'privacy_policy': 'Privasi & Kebijakan',
    'sign_out': 'Keluar',
    'version': 'Versi 0.0.0',

    // ACCOUNT INFO
    'account_info_title': 'Info Akun',
    'name': 'Nama',
    'bio': 'Bio',
    'email': 'Email',
    'password': 'Kata Sandi',
    'change_gmail': 'Ganti Gmail',
    'change_password': 'Ganti Kata Sandi',
    'save_changes': 'Simpan Perubahan',
    'delete_account': 'Hapus Akun',
    'delete_confirm_title': 'Hapus Akun',
    'delete_confirm_body':
        'Apakah kamu yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan.',
    'cancel': 'Batal',
    'delete': 'Hapus',
    'changes_saved': 'Perubahan disimpan!',

    // PRIVACY POLICY
    'privacy_policy_title': 'Privasi & Kebijakan',
    'privacy_protection': 'Perlindungan Privasi',
    'privacy_protection_body':
        'Kami menjaga keamanan data kamu dengan serius.\nData jurnal, mood, dan aktivitas kamu disimpan secara aman dan hanya digunakan untuk meningkatkan pengalaman penggunaan aplikasi.\nKami tidak menjual atau membagikan data pribadi kamu ke pihak ketiga tanpa izin.',
    'data_usage': 'Penggunaan Data & Hak Pengguna',
    'data_usage_body':
        'Data digunakan untuk menampilkan insight personal, menyimpan riwayat aktivitas, dan pengembangan fitur aplikasi.\nKamu memiliki hak untuk mengakses, mengubah, atau menghapus data kamu kapan saja melalui aplikasi.',
    'back': 'Kembali',

    // THEMES
    'themes_title': 'Tema',
    'appearance_label': 'Tampilan',
    'dark_mode': 'Mode Gelap',
    'color_themes': 'Tema Warna',
    'accent_color': 'Warna Aksen',

    // CHANGE EMAIL
    'change_email_title': 'Ganti Email',
    'current_email': 'Email Saat Ini',
    'new_email': 'Email Baru',
    'new_email_hint': 'Masukkan email baru',
    'otp': 'OTP',

    // CHANGE PASSWORD
    'change_password_title': 'Ganti Kata Sandi',
    'old_password': 'Kata Sandi Lama',
    'new_password': 'Kata Sandi Baru',

    // NOTIFICATION
    'notifications': 'Notifikasi',
    'clear': 'Hapus',
    'today': 'Hari Ini',
    'yesterday': 'Kemarin',

    // DAILY INSIGHT
    'daily_insight_title': 'Wawasan Harian',
    'analysis': 'Analisis',
    'insight_positive': 'Kamu sedang berada di fase yang cukup positif.',
    'insight_consistency': 'Konsistensi Dalam Kesehatan',
    'insight_analysis':
        'Dalam beberapa hari terakhir\n Mood kamu cenderung stabil dan\n dominan positif',

    // SHARE
    'share': 'Bagikan',
    'share_now': 'Bagikan Sekarang',
    'share_page_title': 'Share',
    'share_open_link_title': 'Buka Link Jurnal',
    'share_open_link_subtitle':
        'Paste link share dari temanmu untuk melihat jurnalnya',
    'share_paste_hint': 'Paste link jurnal di sini...',
    'share_open_btn': 'Buka Jurnal',
    'share_opening': 'Membuka...',
    'share_my_journal_title': 'Bagikan Jurnalmu',
    'share_pick_journal': 'Pilih Jurnal',
    'share_pick_journal_hint': 'Pilih jurnal...',
    'share_type': 'Tipe Share',
    'share_public_label': 'Public',
    'share_public_desc': 'Siapa saja bisa akses',
    'share_restricted_label': 'Restricted',
    'share_restricted_desc': 'Perlu persetujuan',
    'share_expiry': 'Kadaluarsa (Opsional)',
    'share_no_expiry': 'Tidak ada kadaluarsa',
    'share_create_btn': 'Buat Share Link',
    'share_creating': 'Membuat link...',
    'share_success': 'Link berhasil dibuat!',
    'share_copy_btn': 'Salin Link',
    'share_revoke_btn': 'Cabut Link',
    'share_view_btn': 'Lihat Jurnal',
    'share_restricted_info':
        'Link ini restricted — orang lain perlu meminta akses dan kamu harus menyetujuinya.',
    'share_revoke_title': 'Cabut Share Link',
    'share_revoke_body': 'Link ini tidak bisa diakses lagi. Lanjutkan?',
    'share_revoke_confirm': 'Cabut',
    'share_revoked_success': 'Share link berhasil dicabut',
    'share_copied': 'Link disalin ke clipboard!',
    'share_no_journal_selected': 'Pilih jurnal terlebih dahulu',
    'share_create_failed': 'Gagal membuat share link',
    'share_link_empty': 'Masukkan link terlebih dahulu',
    'share_link_invalid': 'Format link tidak valid',
    'share_link_not_found':
        'Link tidak ditemukan, sudah kadaluarsa, atau perlu persetujuan',
    'share_login_required': 'Kamu perlu login untuk mengakses link ini',
    'share_request_access_title': 'Akses Terbatas',
    'share_request_access_body':
        'Jurnal ini memerlukan persetujuan pemilik. Mau minta akses?',
    'share_request_access_btn': 'Minta Akses',
    'share_request_sent': 'Permintaan akses terkirim!',
    'share_request_failed': 'Gagal mengirim permintaan',
    'share_pending': 'Permintaan akses kamu sedang menunggu persetujuan',
    'share_denied': 'Akses kamu ditolak oleh pemilik jurnal',

    // VERIFICATION
    'verification': 'Verifikasi',
    'verify_email': 'Verifikasi Email Kamu',
    'verify_body':
        'Kami mengirim kode 4 digit ke emailmu. masukkan di bawah untuk membuka Jurnal',
    'resend_code': '00:10 • Kirim ulang kode',
    'confirm': 'Konfirmasi',

    // LOGIN
    'login': 'Masuk',
    'welcome': 'Selamat Datang di Diary Journal',
    'login_subtitle': 'Masuk Untuk Melanjutkan',
    'forgot_password': 'Lupa Kata Sandi?',
    'no_account': 'Baru di sini? Buat akun untuk mulai.',

    // REGISTER
    'register': 'Daftar',
    'create_account': 'Buat Akun',
    'enter_details': 'Masukkan Detail Kamu',
    'full_name': 'Nama Lengkap',
    'confirm_password_label': 'Konfirmasi Kata Sandi',
    'have_account': 'Sudah punya akun? Masuk.',

    //forgot password email
    'forgot_password_title': 'Lupa Kata Sandi',
    'enter_email': 'Masukkan Email',
    'send': 'Kirim',

    //forgot password otp
    'enter_otp': 'Masukan Otp untuk melanjutkan',
    'send_otp': 'Kirim Otp',

    //enter password
    'reset_password_title': 'Atur Ulang Kata Sandi',
    'enter_new_password': 'Masukkan Kata Sandi Baru',
    'confirm_new_password': 'Konfirmasi Kata Sandi Baru',
    'update_password': 'Perbarui Kata Sandi',

    'good_morning': 'Selamat Pagi',
    'good_afternoon': 'Selamat Sore',
    'good_evening': 'Selamat Siang',
  };
}
