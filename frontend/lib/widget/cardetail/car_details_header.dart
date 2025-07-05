import 'package:flutter/material.dart';

class CarDetailsHeader extends StatelessWidget {
  final String brand;
  final String model;
  final String year;

  const CarDetailsHeader({
    Key? key,
    required this.brand,
    required this.model,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 275,
      left: 50,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(brand.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(model,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text(year,
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }
}
