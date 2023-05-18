import 'dart:async';
import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/appointment_report/application/prescription_link.dart';
import 'package:bukmd_telemedicine/src/features/appointment_report/infrastructure/file_download.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/features/prescription/infrastructure/prescription_pdf/prescription_pdf_storage.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../doctor_dashboard/screens/consultation_history.dart';
import '../../doctor_dashboard/screens/patient_information.dart';
import '../../doctor_dashboard/screens/patient_medical_record/personal_social_history_information.dart';

class AppointmentReportPage extends ConsumerStatefulWidget {
  const AppointmentReportPage(
      {Key? key, required this.data, required this.isForDoctorReport})
      : super(key: key);

  final bool isForDoctorReport;
  final AppointmentResult data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentReportPageState();
}

class _AppointmentReportPageState extends ConsumerState<AppointmentReportPage> {
  ConnectivityResult? _connectivityResult;
  late StreamSubscription connection;

  @override
  initState() {
    // The order here is important
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });

    super.initState();
  }

  @override
  dispose() {
    connection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionUrl = ref.watch(prescriptionLinkProvider);
    final PrescriptionPdfStorage pdf = PrescriptionPdfStorage();
    final userId = widget.data.patientId;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Appointment Record',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info('DATE',
                    DateFormat.yMd().add_jm().format(widget.data.date!)),
                const SizedBox(height: 16),
                widget.isForDoctorReport
                    ? info('NAME', widget.data.name!)
                    : Container(),
                info('CONSULTATION TYPE',
                    widget.data.consultationType ?? 'unrecorded'),
                const SizedBox(height: 16),
                info('DIAGNOSIS', widget.data.diagnosis ?? 'None'),
                const SizedBox(height: 16),
                // widget.isForDoctorReport
                //     ? Center(
                //         child: TextButton(
                //             onPressed: () {
                //               Navigator.push(context,
                //                   MaterialPageRoute(builder: (context) {
                //                 return PatientInformationPage(id: userId!);
                //               }));
                //             },
                //             child: const Text(
                //                 'Tap to view more student information')),
                //       )
                //     : Container(),
                widget.data.prescriptionUrl != null
                    ? TextButton.icon(
                        onPressed: () async {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 4,
                                  ),
                                );
                              });
                          if (_connectivityResult == ConnectivityResult.none) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            Navigator.pop(context);
                            return snackBar(
                                context,
                                'Cannot retrieve pdf at this moment.',
                                Colors.red);
                          }
                          try {
                            final url = await pdf.getPdf(
                                userId: userId!,
                                prescriptionId: widget.data.prescriptionUrl!);
                            ref
                                .read(prescriptionLinkProvider.notifier)
                                .updateLink(url!);

                            if (!mounted) return;
                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: const Icon(Icons.file_open),
                        label: const Text('View e-Prescription'),
                      )
                    : Container(),
                prescriptionUrl != null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                                height: 600,
                                child: SfPdfViewer.network(prescriptionUrl)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                  onPressed: () async {
                                    try {
                                      log(prescriptionUrl);
                                      await PrescriptionFileDownload
                                          .downloadFile(
                                              userId: userId!,
                                              prescriptionId:
                                                  widget.data.prescriptionUrl!);
                                      if (await Permission.storage.isGranted) {
                                        if (!mounted) return;
                                        snackBar(
                                            context,
                                            'Downloaded successfully!',
                                            Colors.green,
                                            const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ));
                                      }
                                    } on FirebaseException catch (e) {
                                      print(e);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.file_download,
                                  ),
                                  label: const Text('Download PDF')),
                              TextButton(
                                  onPressed: () {
                                    ref
                                        .refresh(
                                            prescriptionLinkProvider.notifier)
                                        .reset();
                                  },
                                  child: const Text('Close')),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          horizontalDivider,
          PersonalSocialHistoryInformation(id: widget.data.patientId!),
          horizontalDivider,
          ConsultationHistory(
            name: widget.data.name!,
            inAppointmentRecordItem: true,
          )
        ],
      ),
    );
  }
}

Widget info(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        decoration: highlight,
        child: Text(
          value,
        ),
      ),
    ],
  );
}
