import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/features/profiling/infrastructure/services/firestore_appointment_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentAppointmentRecordProvider = StreamProvider.autoDispose
    .family<List<AppointmentResult>, String>((ref, uid) {
  return FirestoreStudentAppointmentRecordController()
      .getAppointmentRecord(uid);
});

final studentUpcomingAppointmentProvider =
    StreamProvider.autoDispose.family<Event?, String>((ref, uid) {
  return FirestoreStudentAppointmentRecordController()
      .getUpcomingAppointment(uid);
});

class FirestoreStudentAppointmentRecordController {
  final FirestoreStudentAppointmentRecord _controller =
      FirestoreStudentAppointmentRecord();

  Stream<List<AppointmentResult>> getAppointmentRecord(String uid) =>
      _controller.getAppointmentRecord(uid);

  Stream<Event?> getUpcomingAppointment(String uid) =>
      _controller.getUpcomingAppointment(uid);
}
