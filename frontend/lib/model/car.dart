class Car {
  final String id;
  final String brand;
  final String model;
  final String licensePlate;
  final String km;
  final String year;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.km,
    required this.year,
  });

  factory Car.fromJson(Map<String, dynamic> json, String id) {
    return Car(
      id: id,
      brand: json['brand'],
      model: json['model'],
      licensePlate: json['plate'],
      km: json['km'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'plate': licensePlate,
      'km': km,
      'year': year,
    };
  }
}
    