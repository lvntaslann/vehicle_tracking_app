import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/model/car.dart';
import 'package:vehicle_tracking_app/services/car_services.dart';

void showEditCarDialog(BuildContext context, Car car) {
  final brandController = TextEditingController(text: car.brand);
  final modelController = TextEditingController(text: car.model);
  final plateController = TextEditingController(text: car.licensePlate);
  final kmController = TextEditingController(text: car.km);
  final yearController = TextEditingController(text: car.year);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Araç Düzenle",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B69FF),
                ),
              ),
              const SizedBox(height: 18),
              _buildStyledTextField(brandController, "Marka", Icons.directions_car_filled),
              const SizedBox(height: 12),
              _buildStyledTextField(modelController, "Model", Icons.drive_eta),
              const SizedBox(height: 12),
              _buildStyledTextField(plateController, "Plaka", Icons.format_list_numbered),
              const SizedBox(height: 12),
              _buildStyledTextField(kmController, "KM", Icons.speed, TextInputType.number),
              const SizedBox(height: 12),
              _buildStyledTextField(yearController, "Yıl", Icons.calendar_today, TextInputType.number),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("İptal", style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedCar = Car(
                        id: car.id,
                        brand: brandController.text,
                        model: modelController.text,
                        licensePlate: plateController.text,
                        km: kmController.text,
                        year: yearController.text,
                      );
                      await Provider.of<CarServices>(context, listen: false).updateCar(updatedCar);
                      Navigator.pop(context);
                    },
                    child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B69FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget _buildStyledTextField(TextEditingController controller, String label, IconData icon, [TextInputType type = TextInputType.text]) {
  return TextField(
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF4B69FF)),
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF3F6FF),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E7FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4B69FF), width: 2),
      ),
    ),
  );
}
