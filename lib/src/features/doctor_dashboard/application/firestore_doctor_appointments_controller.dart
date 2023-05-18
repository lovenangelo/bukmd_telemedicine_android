import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/infrastructure/service/firestore_doctor_appointments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/filter.dart';

final appointmentRequestsProvider =
    StreamProvider.autoDispose<List<Event>>((ref) {
  return FirestoreDoctorAppointmentsController().getAppointmentRequests();
});

final appointmentSchedulesProvider =
    StreamProvider.autoDispose<List<Event>>((ref) {
  return FirestoreDoctorAppointmentsController().getAppointmentSchedules();
});

final appointmentRecordProvider = StreamProvider.autoDispose
    .family<List<AppointmentResult>?, Filter?>((ref, filterData) {
  return FirestoreDoctorAppointmentsController()
      .getAppointmentRecord(filterData);
});

final scheduleAppointmentProvider =
    FutureProvider.family<void, Event>((ref, event) {
  return FirestoreDoctorAppointmentsController().scheduleAppointment(event);
});

class FirestoreDoctorAppointmentsController {
  final DoctorAppointmentsFirestore _firestore = DoctorAppointmentsFirestore();

  Stream<List<Event>> getAppointmentRequests() =>
      _firestore.getAppointmentRequests();

  Stream<List<Event>> getAppointmentSchedules() =>
      _firestore.getAppointmentSchedules();

  Future scheduleAppointment(Event event) async =>
      _firestore.acceptAppointment(event);

  Future declineAppointmentRequest(Event event) async =>
      await _firestore.declineAppointmentRequest(event);

  Future deleteAppointmentRequest(Event event) async =>
      await _firestore.deleteAppointmentRequest(event.id!);

  Future deleteScheduledAppointment(String id) async =>
      await _firestore.deleteScheduledAppointment(id);

  Future addToAppointmentRecord(AppointmentResult response, String id) async =>
      await _firestore.addToStudentAndDoctorAppointmentRecord(response, id);

  Stream<List<AppointmentResult>?> getAppointmentRecord(Filter? filterData) =>
      _firestore.getAppointmentRecord(filterData);
}
