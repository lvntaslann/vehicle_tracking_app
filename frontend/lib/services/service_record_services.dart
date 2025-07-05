// service_record_services.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/service_record.dart';

class ServiceRecordService with ChangeNotifier {
  final String _baseUrl =
      "https://us-central1-vehicle-tracking-app-c0fd9.cloudfunctions.net/api";

  List<ServiceRecord> _records = [];
  String _idToken = "";

  List<ServiceRecord> get records => _records;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _idToken = prefs.getString('idToken') ?? "";
  }

  Future<List<ServiceRecord>> fetchRecords(String vehicleId) async {
    await loadToken();
    setLoading(true);
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/vehicles/$vehicleId/serviceRecords"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _records = (data['serviceRecords'] as List).map((e) {
          // Firestore döküman id'yi ayrıca ekle
          final map = Map<String, dynamic>.from(e);
          map['id'] = e['id'] ?? e['recordId'] ?? null;
          return ServiceRecord.fromJson(map);
        }).toList();
        setLoading(false);
        notifyListeners();
        return _records;
      } else {
        throw Exception("Servis kayıtları alınamadı");
      }
    } catch (e) {
      debugPrint("Servis kayıt listeleme hatası: $e");
      return [];
    }
  }

  Future<void> addRecord(ServiceRecord record, String vehicleId) async {
    await loadToken();
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/vehicles/$vehicleId/serviceRecords"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(record.toJson()),
      );

      if (response.statusCode == 201) {
        // Backend yeni kayıt id'sini döner
        final data = json.decode(response.body);
        final newRecord = ServiceRecord(
          id: data['recordId'], // Backend'den gelen id
          description: record.description,
          date: record.date,
        );
        _records.add(newRecord);
        notifyListeners();
      } else {
        throw Exception("Servis kaydı ekleme başarısız");
      }
    } catch (e) {
      debugPrint("Servis kaydı ekleme hatası: $e");
    }
  }
}
