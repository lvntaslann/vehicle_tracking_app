// service_record.dart
class ServiceRecord {
  final String? id;
  final String description;
  final DateTime date;

  ServiceRecord({
    this.id,
    required this.description,
    required this.date,
  });

  factory ServiceRecord.fromJson(Map<String, dynamic> json) {
    return ServiceRecord(
      id: json['id'],
      description: json['description'] ?? '',
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : (json['date'] is Map && json['date']['_seconds'] != null)
              ? DateTime.fromMillisecondsSinceEpoch(json['date']['_seconds'] * 1000)
              : DateTime.now(), // fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
