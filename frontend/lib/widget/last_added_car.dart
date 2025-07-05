import 'package:flutter/material.dart';

import '../model/car.dart';
import '../pages/car_detail_page.dart';

class LastAddedCar extends StatelessWidget {
  const LastAddedCar({
    super.key,
    required this.cars,
  });

  final List<Car> cars;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          final carsImage = [
            "assets/bmw.png",
            "assets/honda.png",
            "assets/reno.png",
          ];
    
          int imageIndex = 0;
          if (car.brand.toUpperCase() == "BMW") {
            imageIndex = 0;
          } else if (car.brand.toUpperCase() == "HONDA") {
            imageIndex = 1;
          } else if (car.brand.toUpperCase() == "RENAULT") {
            imageIndex = 2;
          }
          return Padding(
            padding:
                EdgeInsets.only(left: index == 0 ? 0 : 16),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: car.licensePlate,
                    child: Image.asset(
                      carsImage[imageIndex],
                      width: 220,
                      height: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    car.brand,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    car.model,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    car.year,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CarDetailPage(
                            id: car.id,
                            image: carsImage[imageIndex],
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
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}