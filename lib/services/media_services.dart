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
  /// Terima File dari image_picker, kirim sebagai multipart
  static Future<MediaModel?> uploadImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/v1/media/upload");

    // Buat request multipart (untuk upload file)
    final request = http.MultipartRequest('POST', url);

    // Tambahkan header Authorization
    request.headers['Authorization'] = 'Bearer $token';

    // Tambahkan file gambar ke request
    final fileName = imageFile.path.split('/').last;
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // nama field yang diminta backend (tanya BE developer jika beda)
        imageFile.path,
        filename: fileName,
      ),
    );

    print("UPLOAD IMAGE to: $url");

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("UPLOAD IMAGE STATUS: ${response.statusCode}");
    print("UPLOAD IMAGE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final data = body['data'];
      return MediaModel.fromJson(data);
    } else {
      return null;
    }
  }

  /// DELETE hapus gambar berdasarkan id
  static Future<bool> deleteMedia(String mediaId) async {
    final token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/v1/media/$mediaId");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE MEDIA STATUS: ${response.statusCode}");
    print("DELETE MEDIA BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
