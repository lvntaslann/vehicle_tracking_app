import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vehicle_tracking_app/model/car.dart';
import 'package:vehicle_tracking_app/pages/car_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/services/car_services.dart';

import 'dialog/edit_car_dialog.dart';
class CarListItem extends StatelessWidget {
  final Car car;
  final List<String> imageList;

  const CarListItem({super.key, required this.car, required this.imageList});

  @override
  Widget build(BuildContext context) {
    int imageIndex = 0;
    if (car.brand.toUpperCase() == "BMW") {
      imageIndex = 0;
    } else if (car.brand.toUpperCase() == "HONDA") {
      imageIndex = 1;
    } else if (car.brand.toUpperCase() == "RENAULT") {
      imageIndex = 2;
    }

    return Slidable(
      key: ValueKey(car.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => showEditCarDialog(context, car),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
          SlidableAction(
            onPressed: (_) async {
              await Provider.of<CarServices>(context, listen: false).deleteCar(car.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailPage(
                id: car.id,
                image: imageList[imageIndex],
                brand: car.brand,
                model: car.model,
                year: car.year,
                license: car.licensePlate,
                km: car.km,
                tag: car.licensePlate,
              ),
            ),
          );
        },
        child: Container(
          width: 400,
          height: 175,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: car.licensePlate,
                    child: Image.asset(imageList[imageIndex], width: 215, height: 94, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(car.brand.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                      const SizedBox(width: 8),
                      Text(car.model.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                      const SizedBox(width: 8),
                      Text(car.year.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
