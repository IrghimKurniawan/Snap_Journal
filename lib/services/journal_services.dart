import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JournalServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST create journal baru (publish)
  static Future<bool> createJournal({
    required String title,
    required String note,
    required List<String> imageUrls,
    bool isDraft = false,
  }) async {
    final token = await _getToken();
    if (token == null) return false;

    // Pilih endpoint berdasarkan draft atau publish
    final endpoint =
        isDraft ? "$baseUrl/api/v1/journals/draft" : "$baseUrl/api/v1/journals";

    final url = Uri.parse(endpoint);

    // Pakai multipart karena backend pakai form-data
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = "Bearer $token";

    // Tambahkan field text
    request.fields['title'] = title;
    if (note.isNotEmpty) request.fields['note'] = note;

    // Tambahkan array images
    for (int i = 0; i < imageUrls.length; i++) {
      request.fields['images[$i]'] = imageUrls[i];
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("CREATE JOURNAL STATUS: ${response.statusCode}");
    print("CREATE JOURNAL BODY: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
