import 'package:bukmd_telemedicine/src/features/doctor_dashboard/infrastructure/service/firestore_student_medical_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profiling/models/past_medical_history.dart';
import '../../../profiling/models/personal_social_history.dart';

final personalSocialHistoryMRProvider =
    FutureProvider.family<PatientMedicalRecord?, String>(
        (ref, patientID) async {
  final psh = await StudentMedicalRecordFirestore()
      .readStudentPersonalSocialHistory(patientID);
  final pmh = await StudentMedicalRecordFirestore()
      .readStudentPastMedicalHistory(patientID);
  final familyHist =
      await StudentMedicalRecordFirestore().readStudentFamilyHistory(patientID);
  final immunizationHist = await StudentMedicalRecordFirestore()
      .readStudentImmunizationHistory(patientID);
  if (psh == null &&
      pmh == null &&
      familyHist == null &&
      immunizationHist == null) {
    return null;
  }
  return PatientMedicalRecord(
      psh: psh,
      pmh: pmh,
      familyHist: familyHist,
      immunizationHist: immunizationHist);
});

class PatientMedicalRecord {
  PersonalSocialHistory? psh;
  PastMedicalHistory? pmh;
  List<Map<String, dynamic>>? familyHist;
  List<Map<String, dynamic>>? immunizationHist;

  PatientMedicalRecord(
      {required this.psh,
      required this.pmh,
      required this.familyHist,
      required this.immunizationHist});
}
