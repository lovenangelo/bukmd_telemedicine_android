import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/domain/filter.dart'
    as filter;
import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_date_utils/in_date_utils.dart';

class DoctorAppointmentsFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Event>> getAppointmentRequests() {
    final querySnapshots = _firestore
        .collection('appointment_requests')
        .orderBy('start', descending: false);
    return querySnapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final eventFromFirestore = Event.fromJson(doc.data());
        eventFromFirestore.id = doc.id;
        return eventFromFirestore;
      }).toList();
      return list;
    });
  }

  Stream<List<Event>> getAppointmentSchedules() {
    final querySnapshots = _firestore
        .collection('scheduled_appointments')
        .orderBy('start', descending: false);
    ;
    return querySnapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final eventFromFirestore = Event.fromJson(doc.data());
        eventFromFirestore.id = doc.id;
        return eventFromFirestore;
      }).toList();
      return list;
    });
  }

  Stream<List<AppointmentResult>?> getAppointmentRecord(
      filter.Filter? filterData) {
    final querySnapshots = _firestore
        .collection('appointment_record')
        .orderBy('date', descending: true);
    return querySnapshots.snapshots().map((event) {
      final list = event.docs.map((doc) {
        final appointmentRecordFromFirestore =
            AppointmentResult.fromJson(doc.data());
        appointmentRecordFromFirestore.appointmentId = doc.id;

        return appointmentRecordFromFirestore;
      }).toList();

      if (filterData != null) {
        log(filterData.name!);

        List<AppointmentResult> result = list;
        if (filterData.name != null && filterData.name!.isNotEmpty) {
          result = result
              .where((element) => element.name!.toLowerCase().contains(
                  filterData.name == null
                      ? ''
                      : filterData.name!.toLowerCase().trim()))
              .toList();
        }
        if (filterData.college != null && filterData.college!.isNotEmpty) {
          result = result
              .where((element) => element.college!.toLowerCase().contains(
                  filterData.college == null
                      ? ''
                      : filterData.college!.toLowerCase().trim()))
              .toList();
        }
        if (filterData.date != null) {
          result = result
              .where((element) =>
                  DateTimeUtils.isSameDay(element.date!, filterData.date!))
              .toList();
        }
        if (filterData.clinicalVisit != null &&
            filterData.onlineConsultation != null &&
            !filterData.onlineConsultation! &&
            filterData.clinicalVisit!) {
          result = result
              .where((element) => element.consultationType == 'clinical visit')
              .toList();
        }
        if (filterData.onlineConsultation != null &&
            filterData.onlineConsultation! &&
            filterData.clinicalVisit != null &&
            !filterData.clinicalVisit!) {
          result = result
              .where((element) =>
                  element.consultationType == 'online consultation')
              .toList();
        }
        return result;
      } else {
        return list;
      }
    });
  }

  Future acceptAppointment(Event event) async {
    event.status = 'accepted';
    final json = event.toJson();
    await _firestore
        .collection('scheduled_appointments')
        .doc(event.id)
        .set(json);
    await _firestore
        .collection('students')
        .doc(event.id)
        .collection('appointments')
        .doc('appointment_request')
        .update({"status": 'accepted'});
  }

  Future declineAppointmentRequest(Event event) async {
    try {
      await _firestore
          .collection('students')
          .doc(event.id)
          .collection('appointments')
          .doc('appointment_request')
          .update({"status": 'declined'});
    } on FirebaseException {
      return null;
    }
  }

  Future deleteAppointmentRequest(String id) async {
    await _firestore.collection('appointment_requests').doc(id).delete();
  }

  Future addToStudentAndDoctorAppointmentRecord(
      AppointmentResult response, String id) async {
    final json = response.toJson();
    try {
      await _firestore.collection('appointment_record').doc().set(json);
      await _firestore
          .collection('students')
          .doc(id)
          .collection('appointment_record')
          .doc()
          .set(json)
          .catchError((e) {
        log('======students_appointment_record======== $e');
      });
      ;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteAndUpdateStudentAndDoctorScheduledAppointment(String id) async {
    try {
      await _firestore.collection('scheduled_appointments').doc(id).delete();
      await _firestore
          .collection('students')
          .doc(id)
          .collection('appointments')
          .doc('appointment_request')
          .delete()
          .catchError((e) {
        log('======scheduled_appointmentsError======== $e');
      });
      await _firestore
          .collection('students')
          .doc(id)
          .update({"hasAppointmentRequest": false}).catchError((e) {
        log('======hasAppointmentRequestError======== $e');
      });
    } catch (e) {
      return null;
    }
  }

  Future deleteScheduledAppointment(String id) async {
    try {
      await _firestore.collection('scheduled_appointments').doc(id).delete();
    } catch (e) {}
  }
}
