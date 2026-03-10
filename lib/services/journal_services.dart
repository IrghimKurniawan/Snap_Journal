import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST create journal (publish atau draft)
  static Future<bool> createJournal({
    required String title,
    required String note,
    required List<String> imageUrls,
    XFile? videoFile,
    bool isDraft = false,
  }) async {
    final token = await _getToken();
    if (token == null) return false;

    final endpoint =
        isDraft ? "$baseUrl/api/v1/journals/draft" : "$baseUrl/api/v1/journals";

    final url = Uri.parse(endpoint);

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = "Bearer $token";

      request.fields['title'] = title;
      if (note.isNotEmpty) request.fields['note'] = note;

      if (imageUrls.isNotEmpty) {
        request.fields['images'] = jsonEncode(imageUrls);
      }

      if (videoFile != null) {
        final videoBytes = await videoFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'video',
            videoBytes,
            filename: videoFile.name,
            contentType: MediaType('video', 'mp4'),
          ),
        );
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      print("CREATE JOURNAL STATUS: ${response.statusCode}");
      print("CREATE JOURNAL BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("CREATE JOURNAL ERROR: $e");
      return false;
    }
  }

  /// GET semua journal
  static Future<List<dynamic>> getJournals() async {
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/journals"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      print("GET JOURNALS STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("GET JOURNALS ERROR: $e");
      return [];
    }
  }

  /// GET draft journals
  static Future<List<dynamic>> getDraftJournals() async {
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/journals/draft"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      print("GET DRAFTS STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("GET DRAFTS ERROR: $e");
      return [];
    }
  }

  /// GET detail satu journal
  static Future<Map<String, dynamic>?> getJournalById(String id) async {
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/journals/$id"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      print("GET JOURNAL DETAIL STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'];
      }
      return null;
    } catch (e) {
      print("GET JOURNAL DETAIL ERROR: $e");
      return null;
    }
  }

  /// DELETE journal
  static Future<bool> deleteJournal(String id) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/v1/journals/$id"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      print("DELETE JOURNAL STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("DELETE JOURNAL ERROR: $e");
      return false;
    }
  }

  /// PUT update konten journal
  static Future<bool> updateJournal({
    required String id,
    required String title,
    required String note,
    required List<String> imageUrls,
    XFile? videoFile,
  }) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/journals/$id");

    try {
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = "Bearer $token";

      if (title.isNotEmpty) request.fields['title'] = title;
      if (note.isNotEmpty) request.fields['note'] = note;
      if (imageUrls.isNotEmpty) {
        request.fields['images'] = jsonEncode(imageUrls);
      }

      if (videoFile != null) {
        final videoBytes = await videoFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'video',
            videoBytes,
            filename: videoFile.name,
            contentType: MediaType('video', 'mp4'),
          ),
        );
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      print("UPDATE JOURNAL STATUS: ${response.statusCode}");
      print("UPDATE JOURNAL BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE JOURNAL ERROR: $e");
      return false;
    }
  }

  /// PATCH publish draft → jadikan published
  static Future<bool> publishDraft(String id) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/v1/journals/$id/draft"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"is_draft": false}),
          )
          .timeout(const Duration(seconds: 30));

      print("PUBLISH DRAFT STATUS: ${response.statusCode}");
      print("PUBLISH DRAFT BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("PUBLISH DRAFT ERROR: $e");
      return false;
    }
  }

  /// PATCH toggle favorit
  static Future<bool> toggleFavorite(String id, bool newValue) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/v1/journals/$id/favorite"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"is_favorite": newValue}),
          )
          .timeout(const Duration(seconds: 30));

      print("TOGGLE FAVORITE STATUS: ${response.statusCode}");
      print("TOGGLE FAVORITE BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("TOGGLE FAVORITE ERROR: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getLatestJournal() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/latest"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getDailyInsight() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/daily-insight"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getTopMood() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/top-mood"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getPeriodicInsight() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/periodic-insight"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return null;
  }

  static Future<List<dynamic>> getMoodCalendar() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/mood-calendar"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return [];
  }

  static Future<Map<String, dynamic>> searchJournal(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/journals/search?keyword=$keyword"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Language": "id"
      },
    );

    print("STATUS SEARCH: ${response.statusCode}");
    print("BODY SEARCH: ${response.body}");

    return jsonDecode(response.body);
  }
}
