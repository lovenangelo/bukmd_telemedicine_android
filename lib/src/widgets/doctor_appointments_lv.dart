import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/patient_information.dart';
import 'package:bukmd_telemedicine/src/features/prescription/application/prescription_state.dart';
import 'package:bukmd_telemedicine/src/features/profiling/infrastructure/controller_firestore_appointment.dart';
import 'package:bukmd_telemedicine/src/features/video_call/call.dart';
import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../features/doctor_dashboard/application/firestore_doctor_appointments_controller.dart';
import '../features/doctor_dashboard/infrastructure/service/firestore_doctor_appointments.dart';
import '../features/prescription/application/appointment_response_provider.dart';

final _appointmentData = DoctorAppointmentsFirestore();
final FirestoreDoctorAppointmentsController _controller =
    FirestoreDoctorAppointmentsController();

class AppointmentsListViewCard extends ConsumerStatefulWidget {
  const AppointmentsListViewCard({
    Key? key,
    required this.data,
    required this.index,
    required this.isAppointmentRequestScreen,
  }) : super(key: key);
  final List<Event> data;
  final int index;
  final bool isAppointmentRequestScreen;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentsListViewCardState();
}

class _AppointmentsListViewCardState
    extends ConsumerState<AppointmentsListViewCard> {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    log(widget.data.toString());
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: 320,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onLongPress: () {
          if (widget.data[widget.index].end!.isBefore(now) &&
              !widget.isAppointmentRequestScreen) return;
          ref
              .read(prescriptionProvider.notifier)
              .setAppointmentInfo(widget.data[widget.index]);
          ref
              .read(prescriptionProvider.notifier)
              .setPrescriptionId(widget.data[widget.index].id.toString());
          widget.isAppointmentRequestScreen
              ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PatientInformationPage(
                      id: widget.data[widget.index].id.toString());
                }))
              : showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      cardAlertDialog(context, widget.data, widget.index, ref));
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, //New
                  blurRadius: 25.0,
                  offset: Offset(0, 25))
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ Text(
                     'Date Requested: ${DateFormat('M/d/y, h:mma')
                          .format(widget.data[widget.index].createdAt!)}'
                         ,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                     const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: widget.isAppointmentRequestScreen ||
                          !widget.data[widget.index].end!.isBefore(now)
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.data[widget.index].type!.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    widget.data[widget.index].end!.isBefore(now) &&
                            !widget.isAppointmentRequestScreen
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return deleteAlertDialog(context,
                                        widget.data, widget.index, ref, false);
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          )
                        : Container(),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Name: ${widget.data[widget.index].name!.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Schedule:  ${DateFormat('EEE, M/d/y').format(widget.data[widget.index].start!)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Time: ${DateFormat("h:mma").format(widget.data[widget.index].start!)} - ${DateFormat("h:mma").format(widget.data[widget.index].end!)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Concern',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                Text(
                  widget.data[widget.index].description!,
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                widget.isAppointmentRequestScreen
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () async {
                                EasyLoading.show(status: 'loading...');

                                await _controller.scheduleAppointment(
                                    widget.data[widget.index]);

                                await _controller.deleteAppointmentRequest(
                                    widget.data[widget.index]);
                                EasyLoading.dismiss();
                                if (mounted) {
                                  //might be not needed anymore
                                  ref.invalidate(appointmentRequestsProvider);
                                  ref.invalidate(appointmentSchedulesProvider);
                                  ref.invalidate(
                                      studentUpcomingAppointmentProvider(
                                          widget.data[widget.index].id!));
                                }
                              },
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              )),
                          const VerticalDivider(
                            color: Color.fromRGBO(214, 214, 214, 1),
                            thickness: 2,
                          ),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return deleteAlertDialog(context,
                                          widget.data, widget.index, ref, true);
                                    });
                              },
                              child: const Text(
                                'Decline',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      )
                    : Center(
                        child: TextButton.icon(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    widget.data[widget.index].end!.isBefore(now)
                                        ? Colors.red
                                        : Colors.green,
                                padding: const EdgeInsets.all(8),
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              if (widget.data[widget.index].end!
                                  .isBefore(now)) {
                                return;
                              }
                              bool isValidTimeRange(
                                  DateTime startTime, DateTime endTime) {
                                DateTime now = DateTime.now();
                                return (now.isAfter(startTime) &&
                                    now.isBefore(endTime));
                              }

                              if (!isValidTimeRange(
                                  widget.data[widget.index].start!,
                                  widget.data[widget.index].end!)) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Current date time is not within the timeframe set for this consultation"),
                                        content: SingleChildScrollView(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'okay',
                                                  style: TextStyle(
                                                      color: primaryColor),
                                                )),
                                          ),
                                        ),
                                      );
                                    });

                                return;
                              }

                              ref
                                  .read(prescriptionProvider.notifier)
                                  .setAppointmentInfo(
                                      widget.data[widget.index]);
                              ref
                                  .read(prescriptionProvider.notifier)
                                  .setPrescriptionId(
                                      widget.data[widget.index].id.toString());
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CallScreen(
                                            isDoctor: true,
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            icon: const Icon(
                              Icons.video_call,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            label: widget.data[widget.index].end!.isBefore(now)
                                ? const Text(
                                    'You missed this consultation',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    'Start online consultation',
                                    style: TextStyle(color: Colors.white),
                                  ) // ,<-- Text
                            ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

cardAlertDialog(
        BuildContext context, List<Event> data, int index, WidgetRef ref) =>
    AlertDialog(
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PatientInformationPage(id: data[index].id.toString());
              }));
            },
            icon: const Icon(Icons.remove_red_eye, color: primaryColor),
            label: const Text(
              'View Student Information',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context,
                    '/create-prescription', (Route<dynamic> route) => false);
              },
              icon: const Icon(
                Icons.medication,
                color: primaryColor,
              ),
              label: const Text(
                'Create e-Prescription',
                style: TextStyle(color: primaryColor),
              )),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              onPressed: () async {
                EasyLoading.show(status: 'loading...');

                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentDiagnosis('None');
                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentResponsePrescriptionUrl(null);
                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentResponsePatientId(data[index].id.toString());
                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentAppointmentDate(data[index].start!);
                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentAppointmentDoctor('MA. ARLENE C. DIANA, MD');
                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentPatientName(data[index].name!);

                ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentResponseConsultationType(data[index].type!);

                await ref
                    .read(appointmentResultProvider.notifier)
                    .setAppointmentResponseCollege(data[index].id!);
                // deleteAppointmentRequest
                _appointmentData
                    .deleteAppointmentRequest(data[index].id.toString());
                // deleteAndUpdateStudentAndDoctorScheduledAppointment
                _appointmentData
                    .deleteAndUpdateStudentAndDoctorScheduledAppointment(
                        data[index].id.toString());
                // addToStudentAppointmentRecord
                _appointmentData.addToStudentAndDoctorAppointmentRecord(
                    ref.read(appointmentResultProvider),
                    data[index].id.toString());
                EasyLoading.dismiss();

                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
              label: const Text(
                'Mark as done',
                style: TextStyle(color: Colors.green),
              )),
        ),
      ],
    );

deleteAlertDialog(BuildContext context, List<Event> data, int index,
        WidgetRef ref, bool forDeleteRequest) =>
    AlertDialog(
      title: const Text(
        'Notice',
      ),
      content: Text(
          'The ${forDeleteRequest ? 'request' : 'schedule'} will be deleted'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            EasyLoading.show(status: 'deleting...');
            Navigator.pop(context);
            if (forDeleteRequest) {
              await _controller.declineAppointmentRequest(data[index]);
              await _controller.deleteAppointmentRequest(data[index]);
            } else {
              await _controller.deleteScheduledAppointment(data[index].id!);
              log('deleted');
            }
            EasyLoading.dismiss();
          },
          child: Text(
            forDeleteRequest ? 'DECLINE' : 'DELETE',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
