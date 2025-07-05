import 'package:flutter/material.dart';
import 'package:vehicle_tracking_app/model/service_record.dart';
import 'package:vehicle_tracking_app/services/service_record_services.dart';

class AddServiceDialog extends StatefulWidget {
  final ServiceRecordService serviceRecordService;
  final String carId;
  final VoidCallback onAdded;

  const AddServiceDialog({
    Key? key,
    required this.serviceRecordService,
    required this.carId,
    required this.onAdded,
  }) : super(key: key);

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF5F7FB),
      title: Row(
        children: const [
          Icon(Icons.build, color: Color(0xFF4B69FF)),
          SizedBox(width: 8),
          Text("Yeni Servis Kaydı Ekle", style: TextStyle(color: Color(0xFF3A488D))),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Açıklama",
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
                  });
                }
              },
            ),
          ),
        ],
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
            if (_descriptionController.text.isNotEmpty && selectedDate != null) {
              final newRecord = ServiceRecord(
                id: "",
                description: _descriptionController.text,
                date: selectedDate!,
              );

              try {
                await widget.serviceRecordService
                    .addRecord(newRecord, widget.carId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Servis kaydı başarıyla eklendi")),
                );

                Navigator.pop(context);
                widget.onAdded();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Servis kaydı eklenemedi: $e")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lütfen açıklama ve tarih seçiniz.")),
              );
            }
          },
          child: const Text("Kaydet"),
        ),
      ],
    );
  }
}
