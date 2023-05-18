import 'dart:developer';

import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAppointmentRequest {
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future addNewAppointmentRequest(Event event) async {
    event.id = _currentUser;
    final eventJson = event.toJson();
    await _db
        .collection('students')
        .doc(_currentUser)
        .collection('appointments')
        .doc('appointment_request')
        .set(eventJson)
        .then((onValue) {})
        .catchError((e) {});
    await _db
        .collection('students')
        .doc(_currentUser)
        .update({"hasAppointmentRequest": true}).then((onValue) {
      log('updated');
    }).catchError((e) {
      log('======studentsHasAppointmentRequestError======== $e');
    });
    await _db
        .collection('appointment_requests')
        .doc(_currentUser)
        .set(eventJson)
        .then((onValue) {
      log('Created it in sub collection');
    }).catchError((e) {
      log('======appointment_requestsCollectionError======== $e');
    });
    await _db.collection('scheduled_appointments').doc(event.id).set(eventJson);
  }

  Future cancelAppointmentRequest() async {
    await _db
        .collection('students')
        .doc(_currentUser)
        .collection('appointments')
        .doc('appointment_request')
        .delete()
        .then((onValue) {
      log('deleted');
    }).catchError((e) {
      log('======Error======== $e');
    });
    await _db
        .collection('students')
        .doc(_currentUser)
        .update({"hasAppointmentRequest": false}).then((onValue) {
      log('updated');
    }).catchError((e) {
      log('======Error======== $e');
    });

    await _db
        .collection('appointment_requests')
        .doc(_currentUser)
        .delete()
        .then((onValue) {
      log('deleted');
    }).catchError((e) {
      log('======Error======== $e');
    });
    await _db
        .collection('scheduled_appointments')
        .doc(_currentUser)
        .delete()
        .catchError((e) {
      log('======Error======== $e');
    });
  }

  Stream<Event?> getCurrentAppointmentRequest() {
    final docRef = _db
        .collection('students')
        .doc(_currentUser)
        .collection('appointments')
        .doc('appointment_request');
    final snapshots = docRef.snapshots();
    final event = snapshots.map((event) {
      return event.exists ? Event.fromJson(event.data()!) : null;
    });
    return event;
  }

  Stream<List<Event>> getScheduledAppointments() {
    final snapshots = _db.collection('scheduled_appointments');
    return snapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final eventFromFirestore = Event.fromJson(doc.data());
        eventFromFirestore.id = doc.id;
        return eventFromFirestore;
      }).toList();
      return list;
    });
  }

  Future deleteMissedAppointment() async {
    await _db
        .collection('students')
        .doc(_currentUser)
        .collection('appointments')
        .doc('appointment_request')
        .delete()
        .then((onValue) {
      log('deleted');
    }).catchError((e) {
      log('======Error======== $e');
    });

    await _db
        .collection('students')
        .doc(_currentUser)
        .update({"hasAppointmentRequest": false}).then((onValue) {
      log('deleted');
    }).catchError((e) {
      log('======Error======== $e');
    });
  }
}
