import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {
  final String baseUrl =
      'https://us-central1-vehicle-tracking-app-c0fd9.cloudfunctions.net/api';

  String uid = "";
  String idToken = "";
  String _userEmail = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get userEmail => _userEmail;

  // Login metodu
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      uid = data['uid'] ?? '';
      idToken = data['idToken'] ?? '';
      _userEmail = data['email'] ?? '';
      debugPrint('Login başarılı: $userEmail');
      notifyListeners();
      // Token ve uid SharedPreferences'a kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      await prefs.setString('idToken', idToken);
      await prefs.setString('userEmail', _userEmail);
      _isLoading = false;
      notifyListeners();

      return data;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  // Register metodu
  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    _isLoading = false;
    notifyListeners();
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      print('Kayıt başarılı: ${responseData}');
    } else {
      _isLoading = false;
      notifyListeners();
      final errorMsg = responseData['error'] ?? 'Unknown error';
      throw Exception('Register failed: $errorMsg');
    }
  }

  // SharedPreferences'tan token ve uid yükleme (uygulama açılırken çağrılabilir)
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? "";
    idToken = prefs.getString('idToken') ?? "";
    _userEmail = prefs.getString('userEmail') ?? "";
    notifyListeners();
  }

  // Çıkış yaparken SharedPreferences'tan verileri silmek için:
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('idToken');

    uid = "";
    idToken = "";
    notifyListeners();
  }
}
