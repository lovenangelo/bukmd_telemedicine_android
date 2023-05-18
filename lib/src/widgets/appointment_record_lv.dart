import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/features/profiling/infrastructure/controller_firestore_appointment.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/appointment_report/presentation/appointment_report_page.dart';
import '../shared/presentation/no_record.dart';

class AppointmentRecordListView extends ConsumerStatefulWidget {
  const AppointmentRecordListView({Key? key, required this.uid})
      : super(key: key);
  final String uid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentRecordListViewState();
}

class _AppointmentRecordListViewState
    extends ConsumerState<AppointmentRecordListView> {
  @override
  Widget build(BuildContext context) {
    final appointmentRecord =
        ref.watch(studentAppointmentRecordProvider(widget.uid));

    return appointmentRecord.when(
        data: (data) {
          int itemCount = data.length;
          return data.isEmpty
              ? noRecord()
              : Scrollbar(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                        child: horizontalDivider,
                      );
                    },
                    itemCount: itemCount == 0 ? 1 : itemCount,
                    itemBuilder: (context, index) =>
                        buildCard(data.reversed.toList(), index, context),
                  ),
                );
        },
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const Center(child: LoadingScreen()));
  }
}

Widget buildCard(
    List<AppointmentResult> data, int index, BuildContext context) {
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment ID: ${data[index].appointmentId.toString().toUpperCase()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('EEE, M/d/y').format(data[index].date!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentReportPage(
                                isForDoctorReport: false,
                                data: data[index],
                              )));
                },
                icon: const Icon(Icons.read_more, color: Colors.blueAccent),
                label: const Text(
                  'view report',
                  style: TextStyle(color: Colors.blueAccent),
                ))
          ],
        ),
      ),
    ),
  );
}
