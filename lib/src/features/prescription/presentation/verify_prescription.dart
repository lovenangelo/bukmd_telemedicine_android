import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/infrastructure/service/firestore_doctor_appointments.dart';
import 'package:bukmd_telemedicine/src/features/prescription/application/appointment_response_provider.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../wrappers/auth_wrapper.dart';
import '../application/prescription_state.dart';
import '../infrastructure/prescription_pdf/prescription_pdf_storage.dart';

final tempPdfProvider =
    FutureProvider<String?>((ref) => PrescriptionPdfStorage().getTempPDF());

class VerifyPrescription extends ConsumerStatefulWidget {
  const VerifyPrescription({Key? key, a}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyPrescriptionState();
}

class _VerifyPrescriptionState extends ConsumerState<VerifyPrescription> {
  final _appointmentData = DoctorAppointmentsFirestore();
  final _pdf = PrescriptionPdfStorage();
  @override
  Widget build(BuildContext context) {
    final patientData = ref.watch(prescriptionProvider);
    final id = patientData.appointmentInfo.id;
    final appointmentResult = ref.read(appointmentResultProvider);
    return ref.watch(tempPdfProvider).when(
        data: (data) {
          return Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white));
              }),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'Verify Prescription',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: primaryColor,
            ),
            body: Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.topEnd,
              children: [
                SfPdfViewer.network(data!),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton.icon(
                        onPressed: () async {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Sending...',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator()),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                padding: const EdgeInsets.all(16),
                              ))
                              .close;

                          try {
                            log(patientData.appointmentInfo.start.toString());
                            await _pdf.saveToFirebaseStorage(
                                patientData.appointmentId,
                                patientData.appointmentInfo.start!);
                            // deleteAppointmentRequest
                            _appointmentData.deleteAppointmentRequest(id!);
                            // deleteAndUpdateStudentAndDoctorScheduledAppointment
                            _appointmentData
                                .deleteAndUpdateStudentAndDoctorScheduledAppointment(
                                    id);
                            // addToStudentAppointmentRecord
                            _appointmentData
                                .addToStudentAndDoctorAppointmentRecord(
                                    appointmentResult, id);
                          } catch (e) {
                            print(e.toString());
                          }
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthWrapper()),
                              (Route<dynamic> route) => false);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Prescription Sent',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                padding: const EdgeInsets.all(16),
                              ))
                              .close;
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Send Prescription')),
                  ),
                )
              ],
            ),
          );
        },
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const LoadingScreen());
  }
}
