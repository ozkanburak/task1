// shared_prefs.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart'; // Point sınıfı için gerekli

class SharedPrefs {
  static const String _signatureKey = 'user_signature';

  static Future<void> saveSignature(List<Point> points) async { 
    final prefs = await SharedPreferences.getInstance();
    final encodedPoints = jsonEncode(points.map((e) => {'x': e.offset.dx, 'y': e.offset.dy}).toList()); // offset üzerinden erişim
    await prefs.setString(_signatureKey, encodedPoints);
  }

  static Future<List<Point>?> getSignature() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPoints = prefs.getString(_signatureKey);
    if (encodedPoints != null) {
      final decodedPoints = jsonDecode(encodedPoints) as List;
      return decodedPoints.map((e) => Point(e['x'], e['y'])).toList(); // x ve y koordinatlarını ayrı ayrı verme
    }
    return null;
  }

  static Future<void> clearSignature() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signatureKey);
  }
}