import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/pages/my_cars.dart';
import 'package:vehicle_tracking_app/services/auth_services.dart';
import 'package:vehicle_tracking_app/services/car_services.dart';
import '../widget/last_added_car.dart';
import '../widget/shimmer/car_list_shimmer.dart';
import '../widget/text/welcome_text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    final carServices = Provider.of<CarServices>(context, listen: false);
    carServices.fetchCars();

    final auth = Provider.of<AuthServices>(context, listen: false);
    auth.loadUserFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final carServices = Provider.of<CarServices>(context);
    final cars = carServices.cars;

    final carsImage = [
      "assets/bmw.png",
      "assets/honda.png",
      "assets/reno.png",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const WelcomeText(),
                  const SizedBox(width: 150),
                  Image.asset("assets/wittycar.png", width: 70, height: 70),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text("Son eklenen araçlar",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 80),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCar(image: carsImage),
                        ),
                      );
                    },
                    child: const Text("Hepsini gör",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 270,
                child: carServices.isLoading
                    ? CarListShimmer()
                    : cars.isEmpty
                        ? const Center(
                            child: Text(
                              "Araç bulunamadı",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        : LastAddedCar(cars: cars),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCar(image: carsImage),
                    ),
                  );
                },
                child: MyCars(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCars extends StatelessWidget {
  const MyCars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 375,
            height: 200,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: const Text(
              "Araçlarım",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4D4D4D)),
            ),
          ),
          Positioned(
            bottom: 100,
            child: Image.asset(
              "assets/mycars.png",
              width: 375,
              height: 390,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
