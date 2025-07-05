import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/services/appointment_services.dart';
import 'package:vehicle_tracking_app/services/service_record_services.dart';
import 'package:shimmer/shimmer.dart';

class RecordListDialog extends StatelessWidget {
  const RecordListDialog({Key? key}) : super(key: key);

  Widget _buildShimmerTitle(String text) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 120,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Text("Kayıtlar"),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Consumer2<AppointmentService, ServiceRecordService>(
            builder: (context, appointmentService, recordService, child) {
              final isLoading =
                  appointmentService.isLoading || recordService.isLoading;

              if (isLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerTitle("Randevular"),
                    ...List.generate(2, (_) => _buildShimmerTile()),
                    const SizedBox(height: 16),
                    _buildShimmerTitle("Servis Kayıtları"),
                    ...List.generate(2, (_) => _buildShimmerTile()),
                  ],
                );
              }

              final appointments = appointmentService.appointments;
              final records = recordService.records;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Randevular",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A488D),
                    ),
                  ),
                  if (appointments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Randevu bulunmamaktadır.",
                        style: TextStyle(color: Color(0xFFBFC6E0)),
                      ),
                    ),
                  ...appointments.map(
                    (a) => Card(
                      color: const Color.fromARGB(231, 255, 254, 254),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading:
                            const Icon(Icons.event, color: Color(0xFF4B69FF)),
                        title: Text(
                          a.title,
                          style: const TextStyle(
                            color: Color(0xFF3A488D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "${a.date.day}.${a.date.month}.${a.date.year}  Saat ${a.date.hour.toString().padLeft(2, '0')}:${a.date.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Color(0xFF4B69FF)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Servis Kayıtları",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A488D),
                    ),
                  ),
                  if (records.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Servis kaydı bulunmamaktadır.",
                        style: TextStyle(color: Color.fromARGB(255, 184, 192, 224)),
                      ),
                    ),
                  ...records.map(
                    (r) => Card(
                      color: const Color.fromARGB(231, 255, 254, 254),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading:
                            const Icon(Icons.build, color: Color(0xFF4B69FF)),
                        title: Text(
                          r.description,
                          style: const TextStyle(
                            color: Color(0xFF3A488D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "${r.date.day}.${r.date.month}.${r.date.year}",
                          style: const TextStyle(color: Color(0xFF4B69FF)),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF4B69FF),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Kapat",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
