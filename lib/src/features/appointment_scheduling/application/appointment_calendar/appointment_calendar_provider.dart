import 'package:bukmd_telemedicine/src/features/appointment_scheduling/application/appointment_calendar/meeting_list_provider.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/domain/appointment_calendar/appointment_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profiling/application/students_firestore_controller.dart';
import '../../domain/appointment_calendar/appointment_system_calendar.dart';
import '../../infrastructure/student_appointment_requests_controller.dart';

final appointmentCalendarProvider =
    FutureProvider.autoDispose<AppointmentSystemCalendarData?>((ref) async {
  final hasAppointmentRequest =
      await StudentsFirestoreController().studentHasAppointmentRequest();
  final hasMedicalRecord =
      await StudentsFirestoreController().studentHasMedicalRecord();
  final scheduledAppointments = ref.watch(bookedAppointmentsProvider);
  scheduledAppointments.whenData((value) =>
      ref.read(meetingListProvider.notifier).getScheduledAppointments(value));

  final appointments = ref.read(meetingListProvider);

  return AppointmentSystemCalendarData(
      hasMedicalRecord: hasMedicalRecord!,
      appointments: MeetingDataSource(appointments),
      hasAppointmentRequest: hasAppointmentRequest!);
});
