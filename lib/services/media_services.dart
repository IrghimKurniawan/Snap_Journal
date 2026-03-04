import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/models/media_model.dart';

class MediaServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST upload gambar
  /// Field name: "image"
  static Future<MediaModel?> uploadImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/media/editor-image");

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = "Bearer $token";

    final fileName = imageFile.path.split('/').last;
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // ← field name
        imageFile.path,
        filename: fileName,
      ),
    );

    print("UPLOAD IMAGE: $fileName");

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("UPLOAD STATUS: ${response.statusCode}");
    print("UPLOAD BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final data = body['data'] ?? body;
      return MediaModel.fromJson(data);
    } else {
      return null;
    }
  }

  /// DELETE hapus gambar berdasarkan URL
  static Future<bool> deleteMedia(String fileUrl) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/media/editor-image");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "file_url": fileUrl, // ← kirim URL
      }),
    );

    print("DELETE MEDIA STATUS: ${response.statusCode}");
    print("DELETE MEDIA BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
