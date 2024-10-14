import 'package:task1/core/models/user_model.dart';
import 'package:task1/core/network/network_manager.dart';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  final NetworkManager _networkManager = NetworkManager();
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _networkManager.login(email, password);
    } catch (e) {
      _errorMessage = 'Giriş başarısız.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}