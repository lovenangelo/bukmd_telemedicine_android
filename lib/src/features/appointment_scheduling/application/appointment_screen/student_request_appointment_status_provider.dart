import 'package:bukmd_telemedicine/src/features/profiling/application/students_firestore_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentHasAppointmentRequestProvider =
    FutureProvider.autoDispose<bool?>((ref) {
  return StudentsFirestoreController().studentHasAppointmentRequest();
});

final studentHasMedicalRecordProvider =
    FutureProvider.autoDispose<bool?>((ref) {
  return StudentsFirestoreController().studentHasMedicalRecord();
});

final studentAppointmentRequestUpdateProvider =
    FutureProvider.autoDispose.family<Future<dynamic>, bool>((ref, update) {
  return StudentsFirestoreController().updateHasAppointmenRequest(update);
});
