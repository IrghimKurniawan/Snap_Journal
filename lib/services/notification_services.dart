import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/models/notification_model.dart';

class NotificationServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// GET semua notifikasi
  static Future<List<NotificationModel>?> getNotifications() async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/notifications");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("GET NOTIFICATIONS STATUS: ${response.statusCode}");
    print("GET NOTIFICATIONS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  /// PATCH tandai satu notifikasi sebagai sudah dibaca
  static Future<bool> markAsRead(String notificationId) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/notifications/$notificationId/read");

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("MARK READ STATUS: ${response.statusCode}");
    print("MARK READ BODY: ${response.body}");

    return response.statusCode == 200;
  }

  /// DELETE hapus satu notifikasi
  static Future<bool> deleteNotification(String notificationId) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/notifications/$notificationId");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE NOTIF STATUS: ${response.statusCode}");
    print("DELETE NOTIF BODY: ${response.body}");

    return response.statusCode == 200;
  }

  /// DELETE hapus semua notifikasi (tombol "Clear")
  static Future<bool> clearAllNotifications() async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/notifications");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("CLEAR ALL STATUS: ${response.statusCode}");
    print("CLEAR ALL BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
