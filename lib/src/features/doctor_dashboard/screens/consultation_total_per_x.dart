import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/application/firestore_doctor_appointments_controller.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';

class TotalNumberOfConsultationsPerX extends ConsumerStatefulWidget {
  const TotalNumberOfConsultationsPerX({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TotalNumberOfConsultationsPerXState();
}

class _TotalNumberOfConsultationsPerXState
    extends ConsumerState<TotalNumberOfConsultationsPerX> {
  String dropDownValue = 'day';
  int total = 0;
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    updateTotal(List<AppointmentResult> data) {
      total = 0;
      int currentMonth = now.month;

      // Calculate the current quarter

      int quarter = 3;
      if (currentMonth >= 1 && currentMonth <= 3) {
        quarter = 1;
      } else if (currentMonth >= 4 && currentMonth <= 6) {
        quarter = 2;
      } else if (currentMonth >= 7 && currentMonth <= 9) {
        quarter = 3;
      } else {
        quarter = 4;
      }

      int startMonth = (quarter - 1) * 3 + 1;
      int endMonth = quarter * 3;

      for (AppointmentResult value in data) {
        if (dropDownValue == 'day' &&
            DateTimeUtils.isSameDay(now, value.date!)) {
          total++;
        }
        if (dropDownValue == 'week' &&
            value.date!.year == now.year &&
            DateTimeUtils.getWeekNumber(value.date!) ==
                DateTimeUtils.getWeekNumber(now)) {
          total++;
        }
        if (dropDownValue == 'month' &&
            value.date!.year == now.year &&
            DateFormat('M').format(value.date!) ==
                DateFormat('M').format(now)) {
          total++;
        }
        if (dropDownValue == 'quarter' &&
            value.date!.year == now.year &&
            value.date!.month >= startMonth &&
            value.date!.month <= endMonth) {
          total++;
        }
        if (dropDownValue == 'school year' &&
            (value.date!.year == now.year - 1 ||
                value.date!.year == now.year) &&
            (value.date!.month >= 8 || value.date!.month <= 7)) {
          total++;
        }
      }
    }

    return ref.watch(appointmentRecordProvider(null)).when(data: (data) {
      if (data != null || data!.isNotEmpty) {
        log(data.toString());

        updateTotal(data);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Number of consultations this ',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton(
                  value: dropDownValue,
                  items: const [
                    DropdownMenuItem(value: 'day', child: Text('day')),
                    DropdownMenuItem(value: 'week', child: Text('week')),
                    DropdownMenuItem(value: 'month', child: Text('month')),
                    DropdownMenuItem(value: 'quarter', child: Text('quarter')),
                    DropdownMenuItem(
                        value: 'school year', child: Text('school year'))
                  ],
                  onChanged: (String? val) {
                    setState(() {
                      total = 0;
                      dropDownValue = val!;
                    });
                  }),
            ],
          ),
          Row(
            children: [
              const Text('TOTAL: '),
              Text(
                total.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      );
    }, error: (e, st) {
      log(e.toString());
      return const Text('Data unavailable');
    }, loading: () {
      return Container();
    });
  }
}
