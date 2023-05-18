import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStudentAppointmentRecord {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AppointmentResult>> getAppointmentRecord(String uid) {
    final querySnapshots = _firestore
        .collection('students')
        .doc(uid)
        .collection('appointment_record').orderBy('date', descending: true); ;

    return querySnapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final appointmentRecordFromFirestore =
            AppointmentResult.fromJson(doc.data());
        appointmentRecordFromFirestore.appointmentId = doc.id;
        return appointmentRecordFromFirestore;
      }).toList();
      return list;
    });
  }

  Stream<Event?> getUpcomingAppointment(String uid) {
    final docRef = _firestore
        .collection('students')
        .doc(uid)
        .collection('appointments')
        .doc('appointment_request');
    final snapshots = docRef.snapshots();
    final event = snapshots.map(
        (event) => event.data() != null ? Event.fromJson(event.data()!) : null);
    return event;
  }
}
