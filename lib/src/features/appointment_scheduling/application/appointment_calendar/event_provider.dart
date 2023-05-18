import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/event.dart';

final eventProvider = StateNotifierProvider<EventNotifier, Event>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<Event> {
  EventNotifier() : super(Event());

  setAppointmentType(String type) {
    super.state.type = type;
  }

  setAppointmentStartTime(DateTime start) {
    super.state.start = start;
  }

  setAppointmentEndTime(DateTime end) {
    super.state.end = end;
  }

  setAppointmentDescription(String? description) {
    super.state.description = description;
  }

  setAppointmentName(String? name) {
    super.state.name = name;
  }

  setAppointmentColor(String? hex) {
    super.state.hex = hex;
  }

  setAppointmentStatus(String? status) {
    super.state.status = status;
  }

  setAppointmentRequestDate() {
    super.state.createdAt = DateTime.now();
  }
}
