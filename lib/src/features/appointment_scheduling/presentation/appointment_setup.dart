import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/appointment_calendar_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/event_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_screen/appointments_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_screen/student_request_appointment_status_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_setup/dropdown_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/infrastructure/student_appointment_requests_controller.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/remove_screen_keyboard.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../profiling/application/students_firestore_controller.dart';

class AppointmentSetup extends ConsumerStatefulWidget {
  const AppointmentSetup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentSetupState();
}

class _AppointmentSetupState extends ConsumerState<AppointmentSetup> {
  final _requestFormKey = GlobalKey<FormState>();

  bool clinicalVisit = false;
  bool onlineConsultation = false;

  @override
  void initState() {
    super.initState();
    ref.read(eventProvider.notifier).setAppointmentDescription(null);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventProvider);
    final date = DateFormat.yMMMEd().format(event.start!);
    final startTime = DateFormat("h:mma").format(event.start!);
    final endTime = DateFormat("h:mma").format(event.end!);

    final storeStudentAppointmentRequests =
        StudentAppointmentRequestsFirestore();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Schedule',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: $startTime - $endTime',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Form(
                key: _requestFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type of consultation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    activeColor: primaryColor,
                                    value: clinicalVisit,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          onlineConsultation = clinicalVisit;
                                          clinicalVisit = !clinicalVisit;
                                        }
                                      });
                                    },
                                    title: const Text('Clinical Visit'),
                                  ),
                                ),
                                Expanded(
                                  child: CheckboxListTile(
                                    activeColor: primaryColor,
                                    value: onlineConsultation,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          onlineConsultation =
                                              !onlineConsultation;
                                          clinicalVisit = !onlineConsultation;
                                        }
                                      });
                                    },
                                    title: const Text('Online Consultation'),
                                  ),
                                ),
                              ],
                            ),
                            field.errorText != null
                                ? Text(
                                    field.errorText!,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                      validator: (value) {
                        return !clinicalVisit && !onlineConsultation
                            ? 'Please select the type of consultation'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            hintText: 'Concern (Max: 100 characters)',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            if (value.length > 50) {
                              return 'Keep it short';
                            }
                            return null;
                          },
                          onChanged: (value) => ref
                              .read(eventProvider.notifier)
                              .setAppointmentDescription(value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_requestFormKey.currentState!.validate()) {
                            EasyLoading.show(status: 'sending request...');
                            removeKeyboard();
                            final studentData =
                                await StudentsFirestoreController()
                                    .readStudentData();

                            if (clinicalVisit) {
                              ref
                                  .read(eventProvider.notifier)
                                  .setAppointmentType('clinical visit');
                            }

                            if (onlineConsultation) {
                              ref
                                  .read(eventProvider.notifier)
                                  .setAppointmentType('online consultation');
                            }

                            ref
                                .read(eventProvider.notifier)
                                .setAppointmentName('${studentData?.fullName}');
                            ref
                                .read(eventProvider.notifier)
                                .setAppointmentStatus('pending');

                            ref
                                .read(eventProvider.notifier)
                                .setAppointmentColor('#F44336');
                            
                            ref
                                .read(eventProvider.notifier)
                                .setAppointmentRequestDate();

                            try {
                              await storeStudentAppointmentRequests
                                  .setNewRequest(event);
                              ref.read(studentAppointmentRequestUpdateProvider(
                                  true));
                              EasyLoading.dismiss();
                              if (mounted) {
                                ref.invalidate(
                                    currentAppointmentRequestProvider);
                                ref.invalidate(
                                    studentHasAppointmentRequestProvider);
                                // ref.invalidate(
                                //     getScheduledAppointmentsProvider);
                                ref.invalidate(appointmentCalendarProvider);
                              }
                              if (!mounted) return;
                              snackBar(
                                  context,
                                  'Appointment request sent',
                                  primaryColor,
                                  const Icon(Icons.check, color: Colors.white));
                              Navigator.pop(context);
                            } catch (e) {
                              EasyLoading.dismiss();
                              log(e.toString());
                              return;
                            }
                          }
                        },
                        child: const Text(
                          'SEND REQUEST',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
