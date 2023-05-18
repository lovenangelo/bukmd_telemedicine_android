import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/prescription.dart';
import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, Prescription>((ref) {
  return PrescriptionNotifier();
});

class PrescriptionNotifier extends StateNotifier<Prescription> {
  PrescriptionNotifier()
      : super(Prescription(
            appointmentId: '',
            medicineDescription: '',
            appointmentInfo: Event()));

  setPrescriptionId(String id) {
    state = state.copyWith(appointmentId: id);
  }

  setPrescriptionDescription(String description) {
    state = state.copyWith(medicineDescription: description);
  }

  setAppointmentInfo(Event event) {
    state = state.copyWith(appointmentInfo: event);
  }

  resetAll() {
    state = Prescription(
        appointmentId: '', medicineDescription: '', appointmentInfo: Event());
  }
}
