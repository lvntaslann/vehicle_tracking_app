import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/services/car_services.dart';
import '../widget/car_list_item.dart';
import '../widget/dialog/add_car_dialog.dart';
import '../widget/shimmer/shimmer_placeholder.dart';

class MyCar extends StatelessWidget {
  const MyCar({super.key, required this.image});
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    final carService = Provider.of<CarServices>(context);
    final cars = carService.cars;
    final isLoading = carService.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4B69FF),
        onPressed: () => showAddCarDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            const Text(
              "Araçlarım",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4D4D4D)),
            ),
            Expanded(
              child: isLoading
                  ? const ShimmerPlaceholder()
                  : cars.isEmpty
                      ? const Center(child: Text("Henüz araç eklenmedi"))
                      : ListView.separated(
                          itemCount: cars.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return CarListItem(
                                car: cars[index], imageList: image);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
