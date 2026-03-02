import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snap_journal/models/login_request.dart';
import 'package:snap_journal/models/login_response.dart';
import 'package:snap_journal/models/register_model.dart';
import 'package:snap_journal/models/verify_request.dart';
import 'package:snap_journal/models/verify_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  /// REGISTER
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<VerifyResponseModel?> verifyEmail(
    VerifyRequestModel request,
  ) async {
    final url = Uri.parse(
      "$baseUrl/api/v1/auth/email/verify",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VerifyResponseModel.fromJson(data);
    } else {
      print("Verify Error: ${response.body}");
      return null;
    }
  }

  static Future<LoginResponseModel?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // 🔥 ambil bagian data
      final data = body['data'];

      return LoginResponseModel.fromJson(data);
    } else {
      print("Login Error: ${response.body}");
      return null;
    }
  }
  static Future<bool> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  if (token == null) return false;

  final url = Uri.parse(
    "https://api-znp6gyu5hq-et.a.run.app/api/v1/auth/logout",
  );

  final response = await http.delete(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", 
    },
  );

  print("LOGOUT STATUS: ${response.statusCode}");
  print("LOGOUT BODY: ${response.body}");

  if (response.statusCode == 200) {
    await prefs.clear(); // hapus token lokal
    return true;
  } else {
    return false;
  }
}
}
