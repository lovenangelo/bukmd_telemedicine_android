import 'package:bukmd_telemedicine/src/features/profiling/models/student.dart';

abstract class PrescriptionDetailsRepository {
  Future<Student?> getPatientInfo(String id);
}
