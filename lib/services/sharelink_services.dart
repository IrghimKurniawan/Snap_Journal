// lib/services/sharelink_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShareLinkServices {
  // ✅ FIX: Dijadikan public agar bisa diakses dari share_page.dart
  static const String baseUrl = "http://127.0.0.1:3001";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST buat share link
  /// shareType: 'public' atau 'restricted'
  /// expiresAt: opsional, format ISO8601
  static Future<Map<String, dynamic>?> createShareLink({
    required String journalId,
    required String shareType,
    DateTime? expiresAt,
  }) async {
    final token = await _getToken();
    if (token == null) return null;

    final Map<String, dynamic> body = {
      "journalId": journalId,
      "shareType": shareType,
    };
    if (expiresAt != null) {
      body["expiresAt"] = expiresAt.toIso8601String();
    }

    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/v1/share-links"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      print("CREATE SHARE LINK STATUS: ${response.statusCode}");
      print("CREATE SHARE LINK BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
      return null;
    } catch (e) {
      print("CREATE SHARE LINK ERROR: $e");
      return null;
    }
  }

  /// PATCH cabut/nonaktifkan share link
  static Future<bool> revokeShareLink(String token) async {
    final authToken = await _getToken();
    if (authToken == null) return false;

    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/api/v1/share-links/$token/revoke"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      ).timeout(const Duration(seconds: 30));

      print("REVOKE SHARE LINK STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("REVOKE SHARE LINK ERROR: $e");
      return false;
    }
  }

  /// GET akses jurnal via share link (public langsung dapat data, restricted perlu request dulu)
  static Future<Map<String, dynamic>?> accessLink(String token) async {
    final authToken = await _getToken();

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/l/$token"),
        headers: {
          "Content-Type": "application/json",
          if (authToken != null) "Authorization": "Bearer $authToken",
        },
      ).timeout(const Duration(seconds: 30));

      print("ACCESS LINK STATUS: ${response.statusCode}");
      print("ACCESS LINK BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
      return null;
    } catch (e) {
      print("ACCESS LINK ERROR: $e");
      return null;
    }
  }

  /// POST minta akses ke share link restricted
  static Future<bool> requestAccess(String token) async {
    final authToken = await _getToken();
    if (authToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/l/$token/request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      ).timeout(const Duration(seconds: 30));

      print("REQUEST ACCESS STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("REQUEST ACCESS ERROR: $e");
      return false;
    }
  }

  /// PATCH approve request akses
  static Future<bool> approveAccessRequest(String requestId) async {
    final authToken = await _getToken();
    if (authToken == null) return false;

    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/api/v1/access-requests/$requestId/approve"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      ).timeout(const Duration(seconds: 30));

      print("APPROVE ACCESS STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("APPROVE ACCESS ERROR: $e");
      return false;
    }
  }

  /// PATCH tolak request akses
  static Future<bool> denyAccessRequest(String requestId) async {
    final authToken = await _getToken();
    if (authToken == null) return false;

    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/api/v1/access-requests/$requestId/deny"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      ).timeout(const Duration(seconds: 30));

      print("DENY ACCESS STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("DENY ACCESS ERROR: $e");
      return false;
    }
  }
}
