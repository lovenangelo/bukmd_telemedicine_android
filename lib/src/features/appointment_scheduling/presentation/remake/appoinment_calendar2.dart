import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/rework/consultation_datasource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../shared/presentation/error_page.dart';
import '../../../../theme/theme.dart';
import '../../application/appointment_calendar/event_provider.dart';
import '../../domain/rework/consultation_datasource.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({
    super.key,
    required this.hasAppointmentRequest,
    required this.hasMedicalRecord,
  });
  final bool hasAppointmentRequest;
  final bool hasMedicalRecord;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  final now = DateTime.now();
  DateTime minDate() {
    final now = DateTime.now();
    DateTime mindate = now;

    if (now.minute > 30) {
      mindate = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0, 0);
    }
    if (now.minute <= 30) {
      mindate = DateTime(now.year, now.month, now.day, now.hour, 30, 0, 0);
    }
    return mindate;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(consultationDataSourceProvider).when(data: (data) {
      return Container(
        margin: const EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!, width: 3)),
        child: Center(
          child: SfCalendar(
            todayHighlightColor: primaryColor,
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
            view: CalendarView.workWeek,
            dataSource: ConsultationDataSource(data),
            minDate: minDate(),
            initialSelectedDate: now,
            timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 7,
                endHour: 17,
                timeIntervalHeight: 80,
                timeIntervalWidth: -1,
                timeInterval: Duration(minutes: 30),
                timeFormat: 'h:mm'),
            onTap: (value) {
              // log(value.date!.toString());
              // log(data[0].start.toString());

              // log('test' +
              //     data
              //         .where((element) => element.start == value.date!)
              //         .toList()
              //         .toString());
              if (data
                  .where((element) => element.start == value.date!)
                  .toList()
                  .isNotEmpty) return;

              if (value.date!.isBefore(now)) return;

              log(widget.hasMedicalRecord.toString());
              if (!widget.hasMedicalRecord) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'You need to provide your medical record first to request an appointment',
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text(
                              'Open the sidebar in your appointment record screen and tap medical record.',
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'okay',
                            style: TextStyle(color: primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              if (widget.hasAppointmentRequest) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'You have already requested an appointment',
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text(
                              'Cancel your current request or finish your scheduled appointment to request a new one.',
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'okay',
                            style: TextStyle(color: primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                final DateTime appointmentStart = value.date!;
                final DateTime appointmentEnd =
                    value.date!.add(const Duration(minutes: 30));
                ref
                    .read(eventProvider.notifier)
                    .setAppointmentStartTime(appointmentStart);
                ref
                    .read(eventProvider.notifier)
                    .setAppointmentEndTime(appointmentEnd);
                Navigator.pushNamed(context, '/setappointment');
              }
            },
          ),
        ),
      );
    }, error: (st, e) {
      log(e.toString());
      return const ErrorPage(isNoInternetError: false);
    }, loading: () {
      return Scaffold(
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Checking available slots...')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 128, vertical: 24),
                  child: LinearProgressIndicator(
                    backgroundColor: primaryColor,
                  ),
                ),
              ]),
        ),
      );
    });
  }
}
