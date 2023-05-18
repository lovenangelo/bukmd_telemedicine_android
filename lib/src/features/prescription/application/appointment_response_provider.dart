import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/features/profiling/application/students_firestore_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appointmentResultProvider =
    StateNotifierProvider<AppointmentResponseNotifier, AppointmentResult>(
        (ref) {
  return AppointmentResponseNotifier();
});

class AppointmentResponseNotifier extends StateNotifier<AppointmentResult> {
  AppointmentResponseNotifier() : super(AppointmentResult());

  setAppointmentPatientName(String name) {
    super.state.name = name;
  }

  setAppointmentDiagnosis(String responseBody) {
    super.state.diagnosis = responseBody;
  }

  setAppointmentAppointmentDate(DateTime date) {
    super.state.date = date;
  }

  setAppointmentAppointmentDoctor(String doctor) {
    super.state.doctor = doctor;
  }

  setAppointmentResponsePrescriptionUrl(String? url) {
    super.state.prescriptionUrl = url;
  }

  setAppointmentResponsePatientId(String id) {
    super.state.patientId = id;
  }

  setAppointmentResponseConsultationType(String consultationType) {
    super.state.consultationType = consultationType;
  }

  Future<void> setAppointmentResponseCollege(String id) async {
    List<String> cob = [
      'BS in Accountancy',
      'BS in Business Administration',
      'BS in Hospitality Management',
    ];

    List<String> cas = [
      'BS in Biology',
      'BS in Environmental Science',
      'BA in English Language',
      'BA in Economics',
      'BA in Sociology',
      'BA in Philosophy',
      'BA in Social Science',
      'BS in Mathematics',
      'BS in Community Development',
      'BS in Development Communication'
    ];

    List<String> coa = ['Bachelor of Public Administration'];

    List<String> con = ['BS in Nursing'];

    List<String> cot = [
      'BS in Automotive Technology',
      'BS in Information Technology',
      'BS in Food Technology',
      'BS in Electronics Technology',
      'BS in Entertainment and Multimedia Computing',
    ];

    List<String> coe = [
      'Bachelor of Elementary Education',
      'Bachelor of Secondary Education',
      'Bachelor of Early Education',
      'Bachelor of Physical Education'
    ];

    List<String> col = ['Bachelor of Law'];

    final docStudent = await StudentsFirestoreController().readPatientData(id);
    if (docStudent != null) {
      final course = docStudent.course!;
      if (cot.contains(course)) super.state.college = "COT";
      if (coa.contains(course)) super.state.college = "COA";
      if (cob.contains(course)) super.state.college = "COB";
      if (col.contains(course)) super.state.college = "COL";
      if (coe.contains(course)) super.state.college = "COE";
      if (con.contains(course)) super.state.college = "CON";
      if (cas.contains(course)) super.state.college = "CAS";
    } else {
      super.state.college = "other";
    }
  }
}
