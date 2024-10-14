import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:task1/core/constants/app_constants.dart';
import 'package:task1/core/models/user_model.dart';
import 'package:task1/core/models/file_model.dart';
import 'package:http/http.dart' as http;

class NetworkManager {
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/v1/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      // İstek ve yanıt bilgilerini loglayın
      print('Request URL: ${response.request?.url}');
      print('Request Headers: ${response.request?.headers}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final accessToken = jsonData['access_token'] as String;

        final profileResponse = await http.get(
          Uri.parse('${AppConstants.baseUrl}/api/v1/auth/profile'),
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
          },
        );

        print('Profile Response Status Code: ${profileResponse.statusCode}');
        print('Profile Response Body: ${profileResponse.body}');

        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body);
          return User.fromJson(profileData);
        } else {
          throw Exception('Kullanıcı profili alınamadı.');
        }
      } else {
        // Hata durumunda API'den dönen hata mesajını fırlat
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['message'] as String? ?? 'Giriş başarısız.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Giriş başarısız.');
    }
  }

  Future<List<File>> getFiles() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/v1/files'),
      );

      print('Files Response Status Code: ${response.statusCode}');
      print('Files Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> filesData = jsonDecode(response.body) as List<dynamic>;
        return filesData.map((fileJson) => File.fromJson(fileJson)).toList();
      } else {
        // Hata durumunda API'den dönen hata mesajını fırlat
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['message'] as String? ?? 'Dosyalar alınamadı.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error getting files: $e');
      throw Exception('Dosyalar alınamadı.');
    }
  }

  Future<File> getFile(String fileName) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/v1/files/$fileName'),
      );

      print('Get File Response Status Code: ${response.statusCode}');
      print('Get File Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final fileData = jsonDecode(response.body);
        return File.fromJson(fileData);
      } else {
        throw Exception('Dosya alınamadı.');
      }
    } catch (e) {
      print('Error getting file: $e');
      throw Exception('Dosya alınamadı.');
    }
  }

  Future<Map<String, dynamic>> uploadFile(PlatformFile file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/api/v1/files/upload'),
      );

      request.headers['Content-Type'] = 'multipart/form-data';

      if (file.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ));
      } else {
        throw Exception('Dosya verileri boş.');
      }

      var response = await request.send();

      print('Upload File Status Code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      print('Upload File Response Body: $responseBody');

      if (response.statusCode == 201) {
        print('Dosya başarıyla yüklendi');
        return jsonDecode(responseBody);
      } else {
        // Hata durumunda API'den dönen hata mesajını fırlat
        final errorJson = jsonDecode(responseBody);
        final errorMessage = errorJson['message'] as String? ?? 'Dosya yüklenemedi.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Dosya yüklenemedi.');
    }
  }

  Future<void> uploadFileFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AppConstants.baseUrl}/api/v1/files/upload'),
        );

        request.headers['Content-Type'] = 'multipart/form-data';

        // URL'den dosya adını çıkarmaya çalışın
        String fileName = url.split('/').last; 

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            response.bodyBytes,
            filename: fileName,
          ),
        );

        var uploadResponse = await request.send();

        print('Upload File Status Code: ${uploadResponse.statusCode}');
        final responseBody = await uploadResponse.stream.bytesToString();
        print('Upload File Response Body: $responseBody');

        if (uploadResponse.statusCode != 201) {
          final errorJson = jsonDecode(responseBody);
          final errorMessage = errorJson['message'] as String? ?? 'Dosya yüklenemedi.';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Dosya indirilemedi');
      }
    } catch (e) {
      print('Error uploading file from URL: $e');
      throw Exception('Dosya yükleme hatası: $e');
    }
  }
}