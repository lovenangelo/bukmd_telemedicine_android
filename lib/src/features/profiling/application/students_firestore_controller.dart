import 'package:bukmd_telemedicine/src/features/profiling/infrastructure/services/display_photo_cloud_storage_service.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/past_medical_history.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/personal_social_history.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/student.dart';
import 'package:bukmd_telemedicine/src/shared/infrastructure/service/students_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../doctor_dashboard/domain/patient.dart';

final studentDataProvider = FutureProvider.autoDispose<Student?>((ref) {
  return StudentsFirestoreController().readStudentData();
});

final studentPersonalSocialHistoryProvider =
    FutureProvider<PersonalSocialHistory?>((ref) {
  return StudentsFirestoreController().readStudentPersonalSocialHistory();
});

final studentPastMedicalHistoryProvider =
    FutureProvider.autoDispose<PastMedicalHistory?>((ref) {
  return StudentsFirestoreController().readStudentPastMedicalHistory();
});

final studentFamilyHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>?>((ref) {
  return StudentsFirestoreController().readStudentFamilyHistory();
});

final studentImmunizationHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>?>((ref) {
  return StudentsFirestoreController().readStudentImmunizationHistory();
});

final patientDataProvider =
    FutureProvider.autoDispose.family<Patient, String>((ref, String id) async {
  final student = await StudentsFirestoreController().readPatientData(id);
  final string =
      await DisplayPhotoCloudStorageService().getPatientPhotoDownloadURL(id);
  return Patient(photoUrl: string, student: student!);
});

class StudentsFirestoreController {
  final studentsFirestore = StudentsFirestore();

  Future createStudentInfoData({required Student student}) async {
    await studentsFirestore.createStudent(student: student);
  }

  Future createStudentPersonalSocialHistoryData(
      {required PersonalSocialHistory personalSocialHistory}) async {
    await studentsFirestore.createStudentPersonalSocialHistoryData(
        personalSocialHistory: personalSocialHistory);
  }

  Future createStudentPastMedicalHistoryData(
      {required PastMedicalHistory pastMedicalHistory}) async {
    await studentsFirestore.createStudentPastMedicalHistoryData(
        pastMedicalHistory: pastMedicalHistory);
  }

  Future createStudentFamilyHistoryData(
      {required List<Map<String, dynamic>> familyHistory}) async {
    await studentsFirestore.createStudentFamilyHistoryData(list: familyHistory);
  }

  Future createStudentImmunizationHistoryData(
      {required List<Map<String, dynamic>> immunizationHistory}) async {
    await studentsFirestore.createStudentImmunizationHistoryData(
        list: immunizationHistory);
  }

  Future<Student?> readStudentData() async {
    return await studentsFirestore.readStudent();
  }

  Future<PersonalSocialHistory?> readStudentPersonalSocialHistory() async {
    return await studentsFirestore.readStudentPersonalSocialHistory();
  }

  Future<PastMedicalHistory?> readStudentPastMedicalHistory() async {
    return await studentsFirestore.readStudentPastMedicalHistory();
  }

  Future<List<Map<String, dynamic>>?> readStudentFamilyHistory() async {
    return await studentsFirestore.readStudentFamilyHistory();
  }

  Future<List<Map<String, dynamic>>?> readStudentImmunizationHistory() async {
    return await studentsFirestore.readStudentImmunizationHistory();
  }

  Future<Student?> readPatientData(String id) async {
    return await studentsFirestore.readPatient(id);
  }

  Future<bool?> studentHasAppointmentRequest() async {
    return await studentsFirestore.studentHasAppointmentRequest();
  }

  Future<bool?> studentHasMedicalRecord() async {
    return await studentsFirestore.studentHasMedicalRecord();
  }

  Future updateHasMedicalRecord(bool update) async {
    await studentsFirestore.updateHasMedicalRecord(update);
  }

  Future updateHasAppointmenRequest(bool update) async {
    await studentsFirestore.updateHasAppointmentRequest(update);
  }
}
