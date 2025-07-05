import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 16,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF3A488D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            "assets/cancel.png",
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
