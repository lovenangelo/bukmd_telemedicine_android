import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/event.dart';
import '../../infrastructure/student_appointment_requests_controller.dart';

final consultationDataSourceProvider =
    StreamProvider.autoDispose<List<Event>>((ref) {
  return StudentAppointmentRequestsFirestore().getConsultationDataSource();
});
