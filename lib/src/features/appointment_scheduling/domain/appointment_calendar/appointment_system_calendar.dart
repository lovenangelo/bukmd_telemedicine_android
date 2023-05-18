import 'package:bukmd_telemedicine/src/features/appointment_scheduling/domain/appointment_calendar/appointment_data_source.dart';

class AppointmentSystemCalendarData {
  final bool hasAppointmentRequest;
  final bool hasMedicalRecord;
  final MeetingDataSource appointments;

  AppointmentSystemCalendarData(
      {required this.hasAppointmentRequest,
      required this.appointments,
      required this.hasMedicalRecord});
}
