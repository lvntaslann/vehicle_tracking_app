import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widget/button/appo_and_services_record_button.dart';
import '../widget/button/back_button.dart';
import '../widget/cardetail/car_details_header.dart';
import '../widget/cardetail/car_image.dart';
import '../widget/cardetail/car_information_box.dart';
import '../widget/dialog/add_appointments_dialog.dart';
import '../widget/dialog/add_service_dialog.dart';
import '../widget/dialog/record_list_dialog.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_tracking_app/services/appointment_services.dart';
import 'package:vehicle_tracking_app/services/service_record_services.dart';

class CarDetailPage extends StatefulWidget {
  final String id;
  final String brand;
  final String image;
  final String tag;
  final String km;
  final String license;
  final String model;
  final String year;

  const CarDetailPage({
    Key? key,
    required this.id,
    required this.brand,
    required this.image,
    required this.tag,
    required this.km,
    required this.license,
    required this.model,
    required this.year,
  }) : super(key: key);

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  late AppointmentService _appointmentService;
  late ServiceRecordService _serviceRecordService;

  @override
  void initState() {
    super.initState();
    _appointmentService = Provider.of<AppointmentService>(context, listen: false);
    _serviceRecordService = Provider.of<ServiceRecordService>(context, listen: false);
    _loadData();
  }

  Future<void> _loadData() async {
    await _appointmentService.fetchAppointments(widget.id);
    await _serviceRecordService.fetchRecords(widget.id);
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAppointmentDialog(
        appointmentService: _appointmentService,
        carId: widget.id,
        onAdded: _loadData,
      ),
    );
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AddServiceDialog(
        serviceRecordService: _serviceRecordService,
        carId: widget.id,
        onAdded: _loadData,
      ),
    );
  }

  void _showRecordListDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.blue.withOpacity(0.2),
      builder: (context) => const RecordListDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B69FF),
      body: Stack(
        children: [
          //araç görseli
          CarImageWidget(
            brand: widget.brand,
            image: widget.image,
            tag: widget.tag,
          ),
          //back button
          BackButtonWidget(onPressed: () => Navigator.of(context).pop()),
          //randevu ve servis kayıtları butonu
          AppointmentsAndServiceRecordButton(onPressed: _showRecordListDialog),
          // Araç km ve plaka bilgileri
          CarInformationBox(km: widget.km, license: widget.license),
          // Araç model,marka, yıl bilgileri
          CarDetailsHeader(
            brand: widget.brand,
            model: widget.model,
            year: widget.year,
          ),
        ],
      ),
            floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4B69FF),
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 8,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.event),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF4B69FF),
            label: 'Randevu Ekle',
            onTap: _showAddAppointmentDialog,
          ),
          SpeedDialChild(
            child: const Icon(Icons.build),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF4B69FF),
            label: 'Servis Ekle',
            onTap: _showAddServiceDialog,
          ),
        ],
      ),
    );
  }
}
