import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/appointment_calendar_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/event_provider.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentCalendar extends ConsumerStatefulWidget {
  const AppointmentCalendar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentCalendarState();
}

class _AppointmentCalendarState extends ConsumerState<AppointmentCalendar> {
  @override
  Widget build(BuildContext context) {
    final appointmentRequest = ref.watch(appointmentCalendarProvider);
    final now = DateTime.now();

    DateTime? appointmentStart;
    DateTime? appointmentEnd;

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

    return appointmentRequest.when(data: (data) {
      return Center(
        child: SfCalendar(
          todayHighlightColor: primaryColor,
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          view: CalendarView.workWeek,
          dataSource: data!.appointments,
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
            if (value.date!.isBefore(now)) {
              return;
            }
            if (!data.hasMedicalRecord) {
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

            if (data.hasAppointmentRequest) {
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
              appointmentStart = value.date!;
              appointmentEnd = value.date!.add(const Duration(minutes: 30));
              ref
                  .read(eventProvider.notifier)
                  .setAppointmentStartTime(appointmentStart!);
              ref
                  .read(eventProvider.notifier)
                  .setAppointmentEndTime(appointmentEnd!);
              Navigator.pushNamed(context, '/setappointment');
            }
          },
        ),
      );
    }, error: (st, e) {
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
