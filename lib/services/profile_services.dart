import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snap_journal/models/profileuser_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<UserProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("Token tidak ditemukan");
      return null;
    }

    final url = Uri.parse("$baseUrl/api/v1/user/profile");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("PROFILE STATUS: ${response.statusCode}");
    print("PROFILE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'];

      return UserProfileModel.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required String name,
    required String bio,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/api/v1/user/profile");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "bio": bio,
      }),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
