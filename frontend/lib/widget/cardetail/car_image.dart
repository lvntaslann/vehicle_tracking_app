import 'package:flutter/material.dart';

class CarImageWidget extends StatelessWidget {
  final String brand;
  final String image;
  final String tag;

  const CarImageWidget({
    Key? key,
    required this.brand,
    required this.image,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double top = brand.toUpperCase() == "RENAULT" ? 50 : 100;
    double height = brand.toUpperCase() == "BMW"
        ? 150
        : brand.toUpperCase() == "RENAULT"
            ? 325
            : 200;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Center(
        child: Hero(
          tag: tag,
          child: Image.asset(
            image,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
