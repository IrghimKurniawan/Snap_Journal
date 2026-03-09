import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:snap_journal/models/profileuser_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_journal/services/auth_services.dart';
import 'dart:io';

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

  static Future<bool> uploadProfilePicture(File image) async {
    try {
      final token = await AuthServices.getToken();

      var dio = Dio();

      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        "picture": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      await dio.patch(
        "$baseUrl/api/v1/user/profile/picture",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deleteProfilePicture() async {
    try {
      final token = await AuthServices.getToken();

      var dio = Dio();

      await dio.delete(
        "$baseUrl/api/v1/user/profile/picture",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
