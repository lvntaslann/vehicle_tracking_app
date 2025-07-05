import 'package:flutter/material.dart';

class CarInformationBox extends StatelessWidget {
  final String km;
  final String license;

  const CarInformationBox({
    Key? key,
    required this.km,
    required this.license,
  }) : super(key: key);

  Widget _buildInfoBox(String asset, String text, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, height: 40),
          const SizedBox(height: 10),
          Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 360,
      left: 24,
      right: 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoBox("assets/speed.png", "$km km", 120, 110),
              _buildInfoBox("assets/people.png", "1-5 kişi", 120, 110),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoBox("assets/plate.png", license, 263, 100),
        ],
      ),
    );
  }
}
