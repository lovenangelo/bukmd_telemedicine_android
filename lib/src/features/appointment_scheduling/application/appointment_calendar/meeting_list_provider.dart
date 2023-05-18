import 'dart:developer';

import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/domain/appointment_calendar/meeting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// can be deleted

final meetingListProvider =
    StateNotifierProvider.autoDispose<MeetingListNotifier, List<Meeting>>(
        (ref) {
  return MeetingListNotifier();
});

class MeetingListNotifier extends StateNotifier<List<Meeting>> {
  MeetingListNotifier() : super([]);

  getScheduledAppointments(List<Event>? events) {
    final scheduledAppointments = events!.map((event) {
      log(event.id.toString());
      return event.id == FirebaseAuth.instance.currentUser!.uid
          ? Meeting(event.type!, event.start!, event.end!, Colors.green, false)
          : Meeting('Booked', event.start!, event.end!, Colors.red, false);
    });

    state = [...scheduledAppointments];
  }

  emptyDataSource() {
    state = [];
  }
}
