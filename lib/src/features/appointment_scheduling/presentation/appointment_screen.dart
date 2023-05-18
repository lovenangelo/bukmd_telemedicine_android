import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/appointment_calendar_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/presentation/remake/appoinment_calendar2.dart';
import 'package:bukmd_telemedicine/src/features/video_call/call.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../theme/theme.dart';
import '../../../widgets/loading_screen.dart';

import '../../../widgets/snackbar.dart';
import '../application/appointment_calendar/meeting_list_provider.dart';
import '../application/appointment_screen/appointments_provider.dart';
import '../application/appointment_screen/student_request_appointment_status_provider.dart';
import '../../../shared/domain/event.dart';
import '../infrastructure/student_appointment_requests_controller.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  final _storeStudentAppointmentRequests =
      StudentAppointmentRequestsFirestore();
  @override
  Widget build(BuildContext context) {
    bool? hasAppointmentRequest;
    bool? hasMedicalRecord;

    final currAppointmentReq = ref.watch(currentAppointmentRequestProvider);

    ref.watch(studentHasAppointmentRequestProvider).maybeWhen(
          data: (data) {
            hasAppointmentRequest = data;
          },
          orElse: () {},
        );
    ref.watch(studentHasMedicalRecordProvider).maybeWhen(
          data: (data) {
            hasMedicalRecord = data;
          },
          orElse: () {},
        );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Request Appointment',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        body: currAppointmentReq.when(data: (data) {
          data?.status == 'declined'
              ? Future(() async {
                  try {
                    ref.read(studentAppointmentRequestUpdateProvider(false));
                    await _storeStudentAppointmentRequests.cancelRequest();
                  } catch (e) {
                    print(e.toString());
                  }
                  if (!mounted) return;
                  showRequestDeclinedAlert(context);
                })
              : null;

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              ref.invalidate(currentAppointmentRequestProvider);
              ref.invalidate(meetingListProvider);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.red[500]!,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Booked'),
                      const SizedBox(width: 8),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue[500]!,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Waiting'),
                      const SizedBox(width: 16),
                      data?.status == 'accepted'
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.green[500]!,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Your Schedule'),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  data?.status == 'accepted'
                      ? Column(
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Upcoming online consultation'.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                                '${data!.type.toString()} - ${DateFormat('EEE, M/d/y').format(data.start!)}'),
                            appointmentInfo(data, true)
                          ],
                        )
                      : Container(),
                  data?.status == 'pending'
                      ? Text(
                          'Pending request'.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        )
                      : Container(),
                  data?.status == 'pending'
                      ? Column(
                          children: [
                            Text(
                                '${data!.type.toString()}: ${DateFormat('EEE, M/d/y').format(data.start!)}'),
                            appointmentInfo(data, false)
                          ],
                        )
                      : Container(),
                  Expanded(
                      child: Calendar(
                    hasAppointmentRequest: hasAppointmentRequest ?? false,
                    hasMedicalRecord: hasMedicalRecord ?? false,
                  )),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return SimpleDialog(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          const Text(
                                            'You can request an appointment by tapping on any tile that is not colored red and choose either online consultation or clinical visit.'
                                            'You can only make a request once at a time.',
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Booked: These are confirmed appointment schedules colored with red that are no longer available to make a request.',
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Waiting: These are appointment requests colored with blue from other people that is not yet confirmed.',
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Your Schedule: This is your scheduled date colored with green.',
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Go back',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'view calendar description',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }, error: (e, st) {
          log('appointment screen$e');
          log('appointment screen$st');
          return const ErrorPage(isNoInternetError: false);
        }, loading: () {
          return const LoadingScreen();
        }));
  }

  void showRequestDeclinedAlert(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Your request has been declined, please request a new appointment.',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'okay',
                    style: TextStyle(color: primaryColor),
                  ))
            ],
          );
        });
  }

  Widget appointmentInfo(Event data, bool isForVideoCall) => TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  title: Text(data.type.toString()),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Schedule: ${DateFormat('EEE, M/d/y').format(data.start!)}'),
                        Text(
                            'Time: ${DateFormat("h:mma").format(data.start!)} - ${DateFormat("h:mma").format(data.end!)}'),
                        Text('Concern: ${data.description.toString()}'),
                      ],
                    ),
                  ),
                  actions: [
                    isForVideoCall
                        ? IconButton(
                            onPressed: () {
                              bool isValidTimeRange(
                                  DateTime startTime, DateTime endTime) {
                                DateTime now = DateTime.now();
                                return (now.compareTo(startTime) >= 0 &&
                                    now.compareTo(endTime) <= 0);
                              }

                              if (!isValidTimeRange(data.start!, data.end!)) {
                                snackBar(
                                    context,
                                    "Current time is not within the timeframe set for your consultation",
                                    primaryColor,
                                    const Icon(Icons.error));
                                Navigator.pop(context);
                                return;
                              }
                              // Navigator.pushNamed(context, '/videocall');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CallScreen(
                                            isDoctor: false,
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            icon: const Icon(
                              Icons.video_call,
                              color: Colors.green,
                            ))
                        : TextButton(
                            onPressed: () async {
                              try {
                                Navigator.pop(context);
                                EasyLoading.show(status: 'cancelling...');
                                await _storeStudentAppointmentRequests
                                    .cancelRequest();
                                EasyLoading.dismiss();
                                ref.invalidate(appointmentCalendarProvider);
                                ref.invalidate(
                                    studentHasAppointmentRequestProvider);
                              } catch (e) {
                                EasyLoading.dismiss();

                                print(e.toString());
                              }
                            },
                            child: const Text(
                              'Cancel request',
                              style: TextStyle(color: Colors.red),
                            )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Go back',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        )),
                  ],
                );
              });
        },
        child: const Text(
          'view details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
