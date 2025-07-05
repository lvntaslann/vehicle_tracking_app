import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();

    // Animasyonu başlat
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.3;
      });
    });

    // Giriş yönlendirmesi
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B69FF),
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: 115,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _opacity,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 800),
                scale: _scale,
                curve: Curves.easeInOut,
                child: Image.asset(
                  "assets/splash_logo.png",
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 70,
            left: 80,
            child: Text(
              "Copyright © 2025 tüm hakları saklıdır",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
