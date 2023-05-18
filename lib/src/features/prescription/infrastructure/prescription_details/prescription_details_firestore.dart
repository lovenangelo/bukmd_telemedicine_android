import 'package:bukmd_telemedicine/src/features/prescription/infrastructure/prescription_details/prescription_details_repository.dart';
import 'package:bukmd_telemedicine/src/features/profiling/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PrescriptionDetailsFirestore implements PrescriptionDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<Student?> getPatientInfo(String id) async {
    final querySnapshot = await _firestore.collection('students').doc(id).get();
    if (querySnapshot.exists) {
      return Student.fromJson(querySnapshot.data()!);
    } else {
      return null;
    }
  }
}
