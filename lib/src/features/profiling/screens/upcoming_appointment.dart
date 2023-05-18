import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';
import '../../../widgets/snackbar.dart';
import '../../appointment_scheduling/infrastructure/student_appointment_requests_controller.dart';
// import '../../authentication/controllers/user_auth_service_controller.dart';
import '../../authentication/service/firebase_auth_service.dart';
import '../../video_call/call.dart';
import '../infrastructure/controller_firestore_appointment.dart';

// final _authServiceController = UserAuthServiceController();
final _studentAppointment = StudentAppointmentRequestsFirestore();
final _auth = FirebaseAuthService();

class UpcomingAppointment extends ConsumerStatefulWidget {
  const UpcomingAppointment({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpcomingAppointmentState();
}

class _UpcomingAppointmentState extends ConsumerState<UpcomingAppointment> {
  @override
  Widget build(BuildContext context) {
    final upcomingAppointment =
        ref.watch(studentUpcomingAppointmentProvider(_auth.currentUserUid!));
    final now = DateTime.now();

    return upcomingAppointment.when(
        data: (data) {
          // log(data.toString());
          if (data == null) {
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0),
                        child: SvgPicture.asset(
                          'lib/src/assets/images/no-data.svg',
                          height: 256,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'No upcoming appointment',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          data.status == 'accepted' && data.end!.isBefore(now)
              ? Future(() async {
                  if (!mounted) return;
                  showAppointmentMissedAlert(context);
                })
              : null;

          if (data.status == "pending" || data.status == null) {
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 48.0),
                      child: SvgPicture.asset(
                        'lib/src/assets/images/no-data.svg',
                        height: 256,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'No upcoming appointment',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            );
          }

          return data.status == 'accepted'
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Center(
                          child: SvgPicture.asset(
                            'lib/src/assets/images/doctor-patient.svg',
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Date: ${DateFormat('EEE, M/d/y').format(data.start!)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Time: ${DateFormat("h:mma").format(data.start!)} - ${DateFormat("h:mma").format(data.end!)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green,
                                padding: const EdgeInsets.all(8),
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              bool isValidTimeRange(
                                  DateTime startTime, DateTime endTime) {
                                DateTime now = DateTime.now();
                                return (now.isAfter(startTime) &&
                                    now.isBefore(endTime));
                              }

                              if (!isValidTimeRange(data.start!, data.end!)) {
                                snackBar(
                                    context,
                                    "Current time is not within the timeframe set for your consultation",
                                    primaryColor,
                                    const Icon(Icons.error));
                                return;
                              }

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
                              size: 24.0,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Start online consultation',
                              style: TextStyle(color: Colors.white),
                            ) // ,<-- Text
                            ),
                      ],
                    ),
                  ),
                )
              : Container();
        },
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => Container());
  }

  void showAppointmentMissedAlert(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              await _studentAppointment.deleteMissedAppointment();
              return true;
            },
            child: AlertDialog(
              title: const Text(
                'You have missed your appointment!',
              ),
              content: const Text('Please make sure to not miss it next time.'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await _studentAppointment.deleteMissedAppointment();
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'okay',
                      style: TextStyle(color: primaryColor),
                    ))
              ],
            ),
          );
        });
  }
}
