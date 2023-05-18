import 'dart:developer';
import 'dart:ui';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/application/firestore_doctor_appointments_controller.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/charts/colleges_pie_chart.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/charts/consultation_cartesian_chart.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/consultation_total_per_x.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/drawer.dart';

import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';

import 'package:bukmd_telemedicine/src/widgets/doctor_appointments_lv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/domain/event.dart';

import '../../prescription/application/prescription_state.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  @override
  void initState() {
    ref.read(prescriptionProvider);
    super.initState();
  }

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
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ref.watch(appointmentSchedulesProvider).when(
                            data: (data) {
                              List<Event> scheduled = data
                                  .where(
                                      (element) => element.status == "accepted")
                                  .toList();
                              if (scheduled.isEmpty) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, //New
                                          blurRadius: 25.0,
                                          offset: Offset(0, 25))
                                    ],
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'NO SCHEDULED CONSULTATIONS',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: horizontalDivider,
                                        ),
                                        Text(
                                          'Consultation schedules will appear here once they are available',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              }

                              final itemCount =
                                  scheduled.isEmpty ? 1 : scheduled.length;
                              return scheduled.isEmpty
                                  ? Container()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 16.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'List of Scheduled Consultations',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Row(
                                                children: const [
                                                  Text("• "),
                                                  Text(
                                                    'Swipe left to view other cards.',
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text("• "),
                                                  Expanded(
                                                    child: Text(
                                                      'Long-press a card to view student data, create e-prescription, or mark the consultation as done.',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              16,
                                          height: 320,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder:
                                                (BuildContext context, _) =>
                                                    const SizedBox(
                                              height: 300,
                                              width: 16,
                                            ),
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 16, 8),
                                            itemCount: itemCount,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    16,
                                                child: AppointmentsListViewCard(
                                                  data: scheduled,
                                                  index: index,
                                                  isAppointmentRequestScreen:
                                                      false,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                            },
                            error: (e, st) {
                              log(e.toString());
                              log(st.toString());
                              return Expanded(
                                child: Center(
                                  child: SizedBox(
                                    height: 250,
                                    width:
                                        MediaQuery.of(context).size.width - 16,
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                      horizontalDivider,
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  // decoration: BoxDecoration(
                  //   boxShadow: const [
                  //     BoxShadow(
                  //         color: Colors.black12, //New
                  //         blurRadius: 25.0,
                  //         offset: Offset(0, 25))
                  //   ],
                  //   color: Colors.cyan,
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'REALTIME REPORTS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              DateFormat('EEE, M/d/y').format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TotalNumberOfConsultationsPerX(),
                        ),
                        const SizedBox(height: 12),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: const ConsultationCartesianChart()),
                        const SizedBox(height: 12),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: const CollegesPieChart()),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
