// lib/services/testing_services.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TestingServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// GET trigger reminder job
  static Future<bool> triggerReminderJob() async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/test/reminder-job"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("TRIGGER REMINDER STATUS: ${response.statusCode}");
    print("TRIGGER REMINDER BODY: ${response.body}");

    return response.statusCode == 200;
  }

  /// GET trigger media cleanup
  static Future<bool> triggerMediaCleanup() async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/test/media-cleanup"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("MEDIA CLEANUP STATUS: ${response.statusCode}");
    print("MEDIA CLEANUP BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
