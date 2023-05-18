import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prescription.freezed.dart';

@freezed
class Prescription with _$Prescription {
  const Prescription._();
  const factory Prescription({
    required String appointmentId,
    required String medicineDescription,
    required Event appointmentInfo,
  }) = _Prescription;
}
