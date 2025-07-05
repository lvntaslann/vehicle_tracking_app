import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_tracking_app/model/appointment.dart';

class AppointmentService with ChangeNotifier {
  final String _baseUrl =
      "https://us-central1-vehicle-tracking-app-c0fd9.cloudfunctions.net/api";

  List<Appointment> _appointments = [];
  String _idToken = "";

  List<Appointment> get appointments => _appointments;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _idToken = prefs.getString('idToken') ?? "";
  }

  Future<List<Appointment>> fetchAppointments(String vehicleId) async {
    await loadToken();
    setLoading(true);
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/vehicles/$vehicleId/get_appointments"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _appointments = (data['appointments'] as List)
            .map((e) => Appointment.fromJson(e))
            .toList();
      } else {
        throw Exception("Randevular alınamadı");
      }
    } catch (e) {
      debugPrint("Randevu listeleme hatası: $e");
    } finally {
      setLoading(false);
    }
    return _appointments;
  }

  Future<void> addAppointment(Appointment appointment, String vehicleId) async {
  await loadToken();
  try {
    final response = await http.post(
      Uri.parse("$_baseUrl/vehicles/$vehicleId/add_appointments"),
      headers: {
        'Authorization': 'Bearer $_idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(appointment.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      debugPrint(data.toString());
      //appointment.id = data['appointmentId'];
      _appointments.add(appointment);
      notifyListeners();
    } else {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? "Randevu ekleme başarısız");
    }
  } catch (e) {
    debugPrint("Randevu ekleme hatası: $e");
    rethrow;
  }
}

  Future<void> deleteAppointment(String vehicleId, String appointmentId) async {
    await loadToken();
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/vehicles/$vehicleId/appointments/$appointmentId"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _appointments.removeWhere((a) => a.id == appointmentId);
        notifyListeners();
      } else {
        throw Exception("Randevu silme başarısız");
      }
    } catch (e) {
      debugPrint("Randevu silme hatası: $e");
    }
  }
}
