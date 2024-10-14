import 'package:task1/core/models/file_model.dart';
import 'package:task1/core/network/network_manager.dart';
import 'package:flutter/material.dart';

class FileListViewModel with ChangeNotifier {
  final NetworkManager _networkManager = NetworkManager();
  List<File> _files = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<File> get files => _files;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchFiles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final filesData = await _networkManager.getFiles();
      _files = filesData; 
    } catch (e) {
      _errorMessage = 'Ürünler alınamadı.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}