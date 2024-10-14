// signature_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:task1/core/utils/local_storage.dart'; 


class SignatureViewModel extends ChangeNotifier {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  SignatureController get controller => _controller;

  Future<void> saveSignature() async {
    final points = _controller.points;
    if (points.isNotEmpty) {
      await SharedPrefs.saveSignature(points);
      notifyListeners(); 
    }
  }

  Future<void> loadSignature() async {
    final points = await SharedPrefs.getSignature(); // Doğrudan Point listesini kullanın
    if (points != null) {
      _controller.points = points;
      notifyListeners();
    }
  }

  Future<void> clearSignature() async {
    _controller.clear();
    await SharedPrefs.clearSignature();
    notifyListeners();
  }
}