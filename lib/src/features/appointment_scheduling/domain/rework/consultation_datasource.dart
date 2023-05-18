import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/patient_medical_record.dart';
import 'package:bukmd_telemedicine/src/shared/domain/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ConsultationDataSource extends CalendarDataSource {
  ConsultationDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }

  @override
  String getSubject(int index) {
    if (appointments![index].id == authServiceController.currentUser!.uid &&
        appointments![index].status == 'accepted') {
      return 'Your scheduled consultation';
    }
    if (appointments![index].status == 'pending') {
      return 'Waiting';
    }
    return 'Booked';
  }

  @override
  Color getColor(int index) {
    if (appointments![index].id == authServiceController.currentUser!.uid &&
        appointments![index].status == 'accepted') {
      return Colors.green;
    }
    if (appointments![index].status == 'pending') {
      return Colors.blue;
    }

    return Colors.red;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
