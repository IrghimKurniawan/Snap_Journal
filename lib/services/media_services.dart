// lib/services/media_services.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/models/media_model.dart';
import 'package:image_picker/image_picker.dart';

class MediaServices {
  static const String baseUrl = "https://api-znp6gyu5hq-et.a.run.app";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// POST upload gambar — support Web & Mobile
  static Future<MediaModel?> uploadImageFromXFile(XFile imageFile) async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/media/editor-image");

    try {
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.name;

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = "Bearer $token";

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print("UPLOAD IMAGE: $fileName");

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
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
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return null;
    }
  }

  /// DELETE hapus gambar berdasarkan URL
  static Future<bool> deleteMedia(String fileUrl) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/media/editor-image");

    try {
      final response = await http
          .delete(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"file_url": fileUrl}),
          )
          .timeout(const Duration(seconds: 30));

      print("DELETE MEDIA STATUS: ${response.statusCode}");
      print("DELETE MEDIA BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("DELETE MEDIA ERROR: $e");
      return false;
    }
  }
}
