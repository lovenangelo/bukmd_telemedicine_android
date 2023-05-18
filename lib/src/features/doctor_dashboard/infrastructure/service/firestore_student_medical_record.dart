import 'package:bukmd_telemedicine/src/features/profiling/models/past_medical_history.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/personal_social_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentMedicalRecordFirestore {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PersonalSocialHistory?> readStudentPersonalSocialHistory(
      String patientID) async {
    final ref = _db
        .collection('students')
        .doc(patientID)
        .collection('personal-social-history')
        .doc('personal-social-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      return PersonalSocialHistory.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<PastMedicalHistory?> readStudentPastMedicalHistory(
      String patientID) async {
    final ref = _db
        .collection('students')
        .doc(patientID)
        .collection('past-medical-history')
        .doc('past-medical-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      return PastMedicalHistory.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> readStudentFamilyHistory(
      String patientID) async {
    final ref = _db
        .collection('students')
        .doc(patientID)
        .collection('family-history')
        .doc('family-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final list = List<Map<String, dynamic>>.from(
          snapshot.data()!["familyHistory"] as List);
      return list;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> readStudentImmunizationHistory(
      String patientID) async {
    final ref = _db
        .collection('students')
        .doc(patientID)
        .collection('immunization-history')
        .doc('immunization-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final list = List<Map<String, dynamic>>.from(
          snapshot.data()!["immunizationHistory"] as List);
      return list;
    } else {
      return null;
    }
  }
}
