import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/infrastructure/service/firestore_appointment_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookedAppointmentsProvider =
    StreamProvider.autoDispose<List<Event>>((ref) {
  return StudentAppointmentRequestsFirestore().getConsultationDataSource();
});

class StudentAppointmentRequestsFirestore {
  final FirestoreAppointmentRequest _store = FirestoreAppointmentRequest();

  Future<void> setNewRequest(Event event) async =>
      await _store.addNewAppointmentRequest(event);

  Stream<Event?> getCurrentAppointmentRequest() =>
      _store.getCurrentAppointmentRequest();

  Future cancelRequest() async => await _store.cancelAppointmentRequest();

  Stream<List<Event>> getConsultationDataSource() =>
      _store.getScheduledAppointments();

  Future deleteMissedAppointment() async =>
      await _store.deleteMissedAppointment();
}
