import 'dart:developer';
import 'dart:ui';

import 'package:age_calculator/age_calculator.dart';
import 'package:bukmd_telemedicine/src/features/prescription/application/prescription_state.dart';
import 'package:bukmd_telemedicine/src/features/prescription/infrastructure/prescription_pdf/prescription_pdf_storage.dart';
import 'package:bukmd_telemedicine/src/features/prescription/presentation/verify_prescription.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../profiling/application/students_firestore_controller.dart';
import '../application/appointment_response_provider.dart';

GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
final _pdf = PrescriptionPdfStorage();

class CreatePrescriptionPage extends ConsumerStatefulWidget {
  const CreatePrescriptionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState
    extends ConsumerState<CreatePrescriptionPage> {
  final drugPrescriptionController = TextEditingController();
  final diagnosisController = TextEditingController();

  @override
  void dispose() {
    drugPrescriptionController.dispose();
    diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientData = ref.watch(prescriptionProvider);
    final data = ref.watch(patientDataProvider(patientData.appointmentId));
    final prescriptionUrl = patientData.appointmentInfo.id! +
        DateFormat('MM-dd-yyyy').format(patientData.appointmentInfo.start!);
    return data.when(
        data: (data) {
          final studentAddress =
              '${data.student.barangay}, ${data.student.city}, ${data.student.province}';
          final studentAge =
              AgeCalculator.age(DateTime.parse(data.student.birthDate!)).years;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Send e-Prescription',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: primaryColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${patientData.appointmentInfo.name}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(patientData.appointmentInfo.start!)}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sex: ${data.student.sex}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${data.student.barangay}, ${data.student.city}, ${data.student.province}',
                      ),
                      const SizedBox(height: 16),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: diagnosisController,
                              decoration: const InputDecoration(
                                hintText: 'Diagnosis',
                              ),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: drugPrescriptionController,
                              decoration: const InputDecoration(
                                hintText: 'Drug prescription',
                              ),
                              minLines: 3,
                              maxLines: 10,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Signature',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      height: 200,
                      width: 400,
                      child: SfSignaturePad(
                        key: _signaturePadKey,
                        minimumStrokeWidth: 2,
                        maximumStrokeWidth: 3,
                        strokeColor: Colors.black,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () async {
                          _signaturePadKey.currentState?.clear();
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: primaryColor),
                        )),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.green),
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
                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentResponsePatientId(
                                    patientData.appointmentId);

                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentDiagnosis(
                                    diagnosisController.text);
                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentResponsePrescriptionUrl(
                                    prescriptionUrl);
                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentAppointmentDate(
                                    patientData.appointmentInfo.start!);
                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentAppointmentDoctor(
                                    'MA. ARLENE C. DIANA, MD');
                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentPatientName(
                                    patientData.appointmentInfo.name!);

                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentResponseConsultationType(
                                    patientData.appointmentInfo.type!);

                            ref
                                .read(appointmentResultProvider.notifier)
                                .setAppointmentResponseCollege(
                                    patientData.appointmentInfo.id!);

                            final image =
                                await _signaturePadKey.currentState?.toImage();

                            final imageSignature = await image?.toByteData(
                                format: ImageByteFormat.png);

                            try {
                              await _pdf.createAndUploadPDF(
                                  age: studentAge.toString(),
                                  name: patientData.appointmentInfo.name!,
                                  sex: data.student.sex!,
                                  address: studentAddress,
                                  prescriptionDescription:
                                      drugPrescriptionController.text,
                                  imageSignature: imageSignature!);
                              if (!mounted) return;
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyPrescription()));
                            } catch (e) {
                              if (!mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          icon:
                              const Icon(Icons.medication, color: Colors.white),
                          label: const Text(
                            'Generate e-Prescription',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.red),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Do you want to cancel?'),
                                      content: SingleChildScrollView(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                            TextButton(
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AuthWrapper()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              },
                                            ),
                                          ])),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.cancel, color: primaryColor),
                            label: const Text('Cancel',
                                style: TextStyle(color: primaryColor))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, st) => const ErrorPage(isNoInternetError: false),
        loading: () => const LoadingScreen());
  }
}
