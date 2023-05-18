import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/no_record.dart';
import '../../../theme/theme.dart';
import '../../../widgets/doctor_appointments_lv.dart';
import '../application/firestore_doctor_appointments_controller.dart';

class AppointmentRequestScreen extends ConsumerStatefulWidget {
  const AppointmentRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentRequestScreenState();
}

class _AppointmentRequestScreenState
    extends ConsumerState<AppointmentRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DoctorAppDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Appointment Requests',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          ref.watch(appointmentRequestsProvider).when(
              data: (data) {
                final itemCount = data.isEmpty ? 1 : data.length;
                return data.isEmpty
                    ? Expanded(child: noRecord('No requests'))
                    : Expanded(
                        child: RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () async {
                            return await ref
                                .refresh(appointmentRequestsProvider);
                          },
                          child: Scrollbar(
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                return AppointmentsListViewCard(
                                    data: data.reversed.toList(),
                                    index: index,
                                    isAppointmentRequestScreen: true);
                              },
                            ),
                          ),
                        ),
                      );
              },
              error: (e, st) {
                log(e.toString());
                return const Text('Something went wrong');
              },
              loading: () => const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                    color: primaryColor,
                  )))),
        ],
      ),
    );
  }
}
