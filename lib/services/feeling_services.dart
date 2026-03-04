import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/models/feeling_model.dart';

class FeelingServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST simpan perasaan hari ini
  static Future<bool> saveFeeling(String feeling) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/feelings");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "mood": feeling,
      }),
    );

    print("SAVE FEELING STATUS: ${response.statusCode}");
    print("SAVE FEELING BODY: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// GET perasaan hari ini
  static Future<FeelingModel?> getTodayFeeling() async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/feelings/today");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("GET FEELING STATUS: ${response.statusCode}");
    print("GET FEELING BODY: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      if (data == null) return null;
      return FeelingModel.fromJson(data);
    } else {
      return null;
    }
  }
}
