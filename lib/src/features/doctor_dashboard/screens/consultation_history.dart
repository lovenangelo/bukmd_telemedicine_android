import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/domain/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/no_record.dart';
import '../../../theme/theme.dart';
import '../application/firestore_doctor_appointments_controller.dart';
import 'appointment_record_screen.dart';

class ConsultationHistory extends ConsumerStatefulWidget {
  final String name;
  final bool inAppointmentRecordItem;
  const ConsultationHistory(
      {super.key, required this.name, this.inAppointmentRecordItem = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsultationHistoryState();
}

class _ConsultationHistoryState extends ConsumerState<ConsultationHistory> {
  late Filter filterData;

  @override
  void initState() {
    filterData = Filter(widget.name, null, null, null, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Center(
              child: Text(
            'Consultation History',
            style: TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
          )),
          const SizedBox(height: 16),
          ref.watch(appointmentRecordProvider(filterData)).when(
              data: (data) {
                final itemCount = data!.isEmpty ? 1 : data.length;

                return data.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No consultations'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          return data.isEmpty
                              ? Container()
                              : appointmentRecordListView(
                                  data.reversed.toList(),
                                  index,
                                  context,
                                  widget.inAppointmentRecordItem);
                        },
                      );
              },
              error: (e, st) {
                log(e.toString());
                log(st.toString());
                return const Text('Something went wrong');
              },
              loading: () => const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ))),
        ],
      ),
    );
  }
}
