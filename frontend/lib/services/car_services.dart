import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_tracking_app/model/car.dart';

class CarServices with ChangeNotifier {
  final String _baseUrl =
      "https://us-central1-vehicle-tracking-app-c0fd9.cloudfunctions.net/api";
  bool _isLoading = false;
  List<Car> _cars = [];
  String _idToken = "";

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _idToken = prefs.getString('idToken') ?? "";
  }

  Future<void> fetchCars() async {
    await loadToken();
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/vehicles/get_vehicles"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Car> loadedCars = [];
        for (var carData in data['vehicles']) {
          loadedCars.add(Car.fromJson(carData, carData['id']));
        }
        _cars = loadedCars;
        notifyListeners();
      } else {
        throw Exception("Araçlar alınamadı");
      }
    } catch (e) {
      debugPrint("Araç listeleme hatası: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCar(Car car) async {
    await loadToken();
    try {
      final body = car.toJson(); // userId backend'den alınacak
      debugPrint("JSON gönderiliyor: ${json.encode(body)}");

      final response = await http.post(
        Uri.parse("$_baseUrl/vehicles/addVehicle"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      debugPrint("Araç ekleme statusCode: ${response.statusCode}");
      debugPrint("Araç ekleme body: ${response.body}");

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final addedCar = Car(
          id: data['vehicleId'],
          brand: car.brand,
          model: car.model,
          licensePlate: car.licensePlate,
          km: car.km,
          year: car.year,
        );
        _cars.add(addedCar);
        notifyListeners();
      } else {
        throw Exception("Araç ekleme başarısız: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Araç ekleme hatası: $e");
    }
  }

  Future<void> deleteCar(String vehicleId) async {
    await loadToken();
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/vehicles/delete_vehicle/$vehicleId"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _cars.removeWhere((car) => car.id == vehicleId);
        notifyListeners();
      } else {
        throw Exception("Araç silme başarısız: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Araç silme hatası: $e");
    }
  }

  Future<void> updateCar(Car car) async {
    await loadToken();
    try {
      final body = car.toJson();
      final response = await http.put(
        Uri.parse("$_baseUrl/vehicles/update_vehicle/${car.id}"),
        headers: {
          'Authorization': 'Bearer $_idToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final index = _cars.indexWhere((c) => c.id == car.id);
        if (index >= 0) {
          _cars[index] = car;
          debugPrint("Güncelleme yapılacak ID: ${car.id}");
          debugPrint("car.id: ${car.id}");
          debugPrint("PUT URL: $_baseUrl/vehicles/update_vehicle/${car.id}");
          debugPrint("Body: ${json.encode(body)}");
          notifyListeners();
        }
      } else {
        debugPrint("Güncelleme yapılacak ID: ${car.id}");
        debugPrint("car.id: ${car.id}");
        debugPrint("PUT URL: $_baseUrl/vehicles/update_vehicle/${car.id}");
        debugPrint("Body: ${json.encode(body)}");
        throw Exception("Araç güncelleme başarısız: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Araç güncelleme hatası: $e");
    }
  }

  void removeCar(Car car) {
    _cars.remove(car);
    notifyListeners();
  }
}
