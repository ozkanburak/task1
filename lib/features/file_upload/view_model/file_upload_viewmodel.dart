import 'package:flutter/material.dart';
import 'package:task1/core/network/network_manager.dart';

class FileUploadViewModel with ChangeNotifier {
  final NetworkManager _networkManager = NetworkManager();

  Future<void> uploadFileFromUrl(String url) async {
    try {
      await _networkManager.uploadFileFromUrl(url);
      notifyListeners(); // İşlem tamamlandığında arayüzü güncelle
    } catch (e) {
      print('Error uploading file from URL: $e');
      rethrow; // Hatayı tekrar fırlat
    }
  }
}