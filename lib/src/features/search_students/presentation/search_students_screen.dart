import 'dart:developer';

import 'package:bukmd_telemedicine/src/features/search_students/application/search_students_provider.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../doctor_dashboard/screens/patient_information.dart';

class SearchStudentsScreen extends ConsumerStatefulWidget {
  const SearchStudentsScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchStudentsScreenState();
}

class _SearchStudentsScreenState extends ConsumerState<SearchStudentsScreen> {
  final titleTextController = TextEditingController();
  final quantityTextController = TextEditingController();
  final searchTextController = TextEditingController();
  bool isForUpdate = false;
  String query = '';
  @override
  void dispose() {
    titleTextController.dispose();
    quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentList = ref.watch(searchStudentsProvider(query));

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        // title: const Text('Students/Patients',
        //     style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  )),
            ),
          ),
          Flexible(
            child: studentList.when(
              data: (data) {
                return Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: data.isEmpty ? 1 : data.length,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemBuilder: ((context, index) {
                        return data.isEmpty
                            ? const Center(child: Text("Can't find student"))
                            : ListTile(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PatientInformationPage(
                                      id: data[index].id.toString());
                                })),
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Text(data[index].name),
                                leading: const Icon(Icons.person),
                              );
                      }),
                    ),
                  ),
                );
              },
              error: (e, st) {
                log(e.toString());
                log(st.toString());

                return const ErrorPage(isNoInternetError: false);
              },
              loading: () => Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
