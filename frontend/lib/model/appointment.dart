class Appointment {
  String id;
  String title;
  DateTime date;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'];

    late DateTime parsedDate;

    if (rawDate is String) {
      // ISO8601 string tarih ve saat parse edilir
      parsedDate = DateTime.parse(rawDate);
    } else if (rawDate is Map && rawDate.containsKey('_seconds')) {
      // Firestore timestamp formatı (_seconds ile)
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate['_seconds'] * 1000);
    } else {
      throw Exception("Geçersiz tarih formatı: $rawDate");
    }

    return Appointment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(), // tarih ve saat ISO formatında gönderilir
    };
  }
}
