import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersCollection {
  final _firestore = FirebaseFirestore.instance;

  Future addToUsersCollection(String email) async {
    await _firestore
        .collection(Strings.usersCollection)
        .doc(email)
        .set({"userType": "patient"});
  }

  Future<bool?> getUserType(String email) async {
    try {
      final snapshot =
          await _firestore.collection(Strings.usersCollection).doc(email).get();
      return snapshot["userType"] == 'doctor' ? true : false;
    } on FirebaseException {
      return null;
    }
  }
}
