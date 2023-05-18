import 'package:bukmd_telemedicine/src/features/profiling/models/past_medical_history.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/personal_social_history.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentsFirestore {
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future createStudent({required Student student}) async {
    final docStudent = _db.collection('students').doc(_currentUser);
    final json = Student.toJson(student);
    await docStudent.set(json);
  }

  Future createStudentPersonalSocialHistoryData(
      {required PersonalSocialHistory personalSocialHistory}) async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('personal-social-history')
        .doc('personal-social-history');
    final json = personalSocialHistory.toJson();
    await ref.set(json);
  }

  Future createStudentPastMedicalHistoryData(
      {required PastMedicalHistory pastMedicalHistory}) async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('past-medical-history')
        .doc('past-medical-history');
    final json = pastMedicalHistory.toJson();
    await ref.set(json);
  }

  Future createStudentFamilyHistoryData(
      {required List<Map<String, dynamic>> list}) async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('family-history')
        .doc('family-history');
    final json = {"familyHistory": list};
    await ref.set(json);
  }

  Future createStudentImmunizationHistoryData(
      {required List<Map<String, dynamic>> list}) async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('immunization-history')
        .doc('immunization-history');
    final json = {"immunizationHistory": list};
    await ref.set(json);
  }

  Future<Student?> readStudent() async {
    final docStudent = _db.collection("students").doc(_currentUser);
    final snapshot = await docStudent.get();

    if (snapshot.exists) {
      return Student.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<PersonalSocialHistory?> readStudentPersonalSocialHistory() async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('personal-social-history')
        .doc('personal-social-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      return PersonalSocialHistory.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<PastMedicalHistory?> readStudentPastMedicalHistory() async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
        .collection('past-medical-history')
        .doc('past-medical-history');

    final snapshot = await ref.get();

    if (snapshot.exists) {
      return PastMedicalHistory.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> readStudentFamilyHistory() async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
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

  Future<List<Map<String, dynamic>>?> readStudentImmunizationHistory() async {
    final ref = _db
        .collection('students')
        .doc(_currentUser)
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

  Future<Student?> readPatient(String id) async {
    final docStudent = _db.collection("students").doc(id);
    final snapshot = await docStudent.get();

    if (snapshot.exists) {
      return Student.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<bool?> studentHasAppointmentRequest() async {
    final docStudent = _db.collection("students").doc(_currentUser);
    final snapshot = await docStudent.get();

    if (snapshot.exists) {
      return Student.fromJson(snapshot.data()!).hasAppointmentRequest;
    } else {
      return null;
    }
  }

  Future<bool?> studentHasMedicalRecord() async {
    final docStudent = _db.collection("students").doc(_currentUser);
    final snapshot = await docStudent.get();

    if (snapshot.exists) {
      return Student.fromJson(snapshot.data()!).hasMedicalRecord;
    } else {
      return null;
    }
  }

  updateHasAppointmentRequest(bool update) async {
    await _db
        .collection("students")
        .doc(_currentUser)
        .update({"hasAppointmentRequest": update}).whenComplete(() async {
      print("Completed");
    }).catchError((e) => print(e));
  }

  updateHasMedicalRecord(bool update) async {
    await _db
        .collection("students")
        .doc(_currentUser)
        .update({"hasMedicalRecord": update}).whenComplete(() async {
      print("Completed");
    }).catchError((e) => print(e));
  }
}
