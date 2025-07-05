import 'package:flutter/material.dart';
import 'package:vehicle_tracking_app/model/appointment.dart';
import 'package:vehicle_tracking_app/services/appointment_services.dart';

class AddAppointmentDialog extends StatefulWidget {
  final AppointmentService appointmentService;
  final String carId;
  final VoidCallback onAdded;

  const AddAppointmentDialog({
    Key? key,
    required this.appointmentService,
    required this.carId,
    required this.onAdded,
  }) : super(key: key);

  @override
  State<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF5F7FB),
      title: Row(
        children: const [
          Icon(Icons.event, color: Color(0xFF4B69FF)),
          SizedBox(width: 8),
          Text("Yeni Randevu Ekle", style: TextStyle(color: Color(0xFF3A488D))),
        ],
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Başlık",
                  labelStyle: const TextStyle(color: Color(0xFF3A488D)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF4B69FF)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFBFC6E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B69FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate == null
                        ? "Tarih Seç"
                        : "Seçilen: ${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF4B69FF),
                              onPrimary: Colors.white,
                              onSurface: Color(0xFF3A488D),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        selectedTime = null;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              if (selectedDate != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B69FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime == null
                          ? "Saat Seç"
                          : "Seçilen Saat: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF4B69FF)),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B69FF),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            if (_titleController.text.isNotEmpty &&
                selectedDate != null &&
                selectedTime != null) {
              final combinedDateTime = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute,
              );

              final newAppointment = Appointment(
                id: "",
                title: _titleController.text,
                date: combinedDateTime,
              );

              try {
                await widget.appointmentService
                    .addAppointment(newAppointment, widget.carId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Randevu başarıyla eklendi")),
                );

                Navigator.pop(context);
                widget.onAdded();
              } catch (e) {
                String errorMessage = "Randevu eklenemedi.";
                if (e is Exception) {
                  final msg = e.toString().toLowerCase();
                  if (msg.contains("zaten bir randevu mevcut") ||
                      msg.contains("conflict") ||
                      msg.contains("duplicate")) {
                    errorMessage = "Seçilen tarih ve saatte başka bir randevu zaten var.";
                  } else {
                    errorMessage = e.toString();
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Lütfen başlık, tarih ve saat seçiniz.")),
              );
            }
          },
          child: const Text("Kaydet"),
        ),
      ],
    );
  }
}
