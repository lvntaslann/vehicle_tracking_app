import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/pages/splash_screen.dart';
import 'pages/auth/login.dart';
import 'pages/auth/signup.dart';
import 'pages/homepage.dart';
import 'services/appointment_services.dart';
import 'services/auth_services.dart';
import 'services/car_services.dart';
import 'services/service_record_services.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => CarServices()),
        ChangeNotifierProvider(create: (_) => AppointmentService()),
        ChangeNotifierProvider(create: (_) => ServiceRecordService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => Signup(),
        '/login': (context) => Login(),
        '/home': (context) => Homepage(),
      },
      home:const SplashScreen(),
    );
  }
}
