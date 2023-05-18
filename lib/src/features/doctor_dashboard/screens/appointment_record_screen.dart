import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/appointment_report/presentation/appointment_report_page.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/application/firestore_doctor_appointments_controller.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/domain/filter.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/drawer.dart';
import 'package:bukmd_telemedicine/src/features/prescription/domain/entities/appointment_response.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/filter_tags.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import '../../../shared/presentation/no_record.dart';

class AppointmentRecordScreen extends ConsumerStatefulWidget {
  const AppointmentRecordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentRecordScreenState();
}

class _AppointmentRecordScreenState
    extends ConsumerState<AppointmentRecordScreen> {
  String name = '';
  DateTime? date;
  String college = '';
  bool onlineConsultation = false;
  bool clinicalVisit = false;
  Filter? filterData;

  @override
  Widget build(BuildContext context) {
    log(filterData?.name ?? 'none');
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
          'Appointment Record',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          ref.watch(appointmentRecordProvider(filterData)).when(
              data: (data) {
                final itemCount = data!.isEmpty ? 1 : data.length;

                return data.isEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                      onPressed: () {
                                        filterData = null;
                                        name = '';
                                        date = null;
                                        college = '';
                                        onlineConsultation = false;
                                        clinicalVisit = false;
                                        showFilterDialog();
                                      },
                                      icon: const Icon(
                                        Icons.filter_alt,
                                        color: Colors.grey,
                                      ),
                                      label: const Text(
                                        'Filter',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  Text('Total Results: ${data.length}')
                                ],
                              ),
                            ),
                            filterData != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: filterTags(),
                                  )
                                : Container(),
                            Expanded(child: noRecord()),
                            filterData != null ? clearFilter() : Container()
                          ],
                        ),
                      )
                    : Expanded(
                        child: Scrollbar(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {
                                          filterData = null;
                                          name = '';
                                          date = null;
                                          college = '';
                                          onlineConsultation = false;
                                          clinicalVisit = false;
                                          showFilterDialog();
                                        },
                                        icon: const Icon(
                                          Icons.filter_alt,
                                          color: Colors.grey,
                                        ),
                                        label: const Text(
                                          'Filter',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    Text('Total Results: ${data.length}')
                                  ],
                                ),
                              ),
                              filterData != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: filterTags(),
                                    )
                                  : Container(),
                              Expanded(
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  itemCount: itemCount,
                                  itemBuilder: (context, index) {
                                    return data.isEmpty
                                        ? Container()
                                        : appointmentRecordListView(
                                            data, index, context, false);
                                  },
                                ),
                              ),
                              filterData != null ? clearFilter() : Container()
                            ],
                          ),
                        ),
                      );
              },
              error: (e, st) {
                log(e.toString());
                log(st.toString());
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

  Widget filterTags() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tags:'),
          Wrap(
            children: [
              name.isNotEmpty
                  ? FilterTag(text: name, color: Colors.brown[50]!)
                  : Container(),
              date != null
                  ? FilterTag(
                      text: DateFormat('yyyy-MM-dd').format(date!),
                      color: Colors.brown[50]!)
                  : Container(),
              college.isNotEmpty
                  ? FilterTag(text: college, color: Colors.brown[50]!)
                  : Container(),
              onlineConsultation
                  ? FilterTag(
                      text: 'online consultation', color: Colors.brown[50]!)
                  : Container(),
              clinicalVisit
                  ? FilterTag(text: 'clinical visit', color: Colors.brown[50]!)
                  : Container(),
            ],
          ),
          horizontalDivider
        ],
      );

  Widget clearFilter() => Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
            onPressed: () {
              setState(() {
                filterData = null;
                name = '';
                date = null;
                college = '';
                onlineConsultation = false;
                clinicalVisit = false;
              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Clear filter',
                style: TextStyle(color: Colors.white),
              ),
            )),
      );

  void updateFilter(Filter filter) {
    setState(() {
      filterData = filter;
    });
  }

  showFilterDialog() => showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(builder: ((context, setState) {
          return AlertDialog(
            title: const Text('Filter appointment record'),
            content: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DateTimeField(
                      selectedDate: date,
                      onDateSelected: (value) {
                        setState(() {
                          date = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Date'),
                      dateFormat: DateFormat('yyyy-MM-dd'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: primaryColor,
                      decoration:
                          const InputDecoration(labelText: 'Department'),
                      onChanged: (value) {
                        setState(() {
                          college = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      activeColor: primaryColor,
                      value: onlineConsultation,
                      onChanged: (value) {
                        setState(() {
                          onlineConsultation = value!;
                        });
                      },
                      title: const Text('Online Consultation'),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      activeColor: primaryColor,
                      value: clinicalVisit,
                      onChanged: (value) {
                        setState(() {
                          clinicalVisit = value!;
                        });
                      },
                      title: const Text('Clinical Visit'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        updateFilter(Filter(name.trim(), date, college.trim(),
                            clinicalVisit, onlineConsultation));
                      },
                      child: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
      }));
}

Widget appointmentRecordListView(List<AppointmentResult> data, index,
        BuildContext context, bool isInAppointmentRecordItem) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, //New
                blurRadius: 20.0,
                offset: Offset(0, 25))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'ID: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.amber[100],
                    child: Text(
                      data[index].appointmentId.toString().toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Date:  ${DateFormat('EEE, M/d/y').format(data[index].date!)}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Divider(),
              TextButton.icon(
                  onPressed: () {
                    log(isInAppointmentRecordItem.toString());
                    if (!isInAppointmentRecordItem) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentReportPage(
                                    isForDoctorReport: true,
                                    data: data[index],
                                  )));
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentReportPage(
                                  isForDoctorReport: true,
                                  data: data[index],
                                )));

                    // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
                  },
                  icon: const Icon(Icons.read_more, color: Colors.blueAccent),
                  label: const Text(
                    'view record',
                    style: TextStyle(color: Colors.blueAccent),
                  ))
            ],
          ),
        ),
      ),
    );
