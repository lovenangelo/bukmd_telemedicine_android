import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/student_appointment_requests_controller.dart';
import '../../../../shared/domain/event.dart';

final currentAppointmentRequestProvider =
    StreamProvider.autoDispose<Event?>((ref) {
  return StudentAppointmentRequestsFirestore().getCurrentAppointmentRequest();
});

// final getScheduledAppointmentsProvider =
//     StreamProvider.autoDispose<List<Event>?>((ref) {
//   return StudentAppointmentRequestsFirestore().getScheduledAppointments();
// });
