import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TestingServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST trigger reminder job (untuk testing notif reminder)
  static Future<bool> triggerReminderJob() async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/testing/reminder-job");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("TRIGGER REMINDER STATUS: ${response.statusCode}");
    print("TRIGGER REMINDER BODY: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// GET media testing
  static Future<Map<String, dynamic>?> testMedia() async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/testing/media");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("TEST MEDIA STATUS: ${response.statusCode}");
    print("TEST MEDIA BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
