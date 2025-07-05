import 'package:flutter/material.dart';

class AppointmentsAndServiceRecordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppointmentsAndServiceRecordButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 175,
      left: 24,
      right: 24,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          "Randevular ve Servis Kayıtları",
          style: TextStyle(color: Color(0xFF3A488D), fontSize: 16),
        ),
      ),
    );
  }
}
