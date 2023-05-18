import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/consultation_history.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/patient_medical_record/personal_social_history_information.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/strings.dart';
import '../../profiling/application/students_firestore_controller.dart';

class PatientInformationPage extends ConsumerWidget {
  const PatientInformationPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(patientDataProvider(id));
    return data.when(
        data: (data) {
          return Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white));
              }),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: primaryColor,
              centerTitle: true,
              title: const Text('Student Information',
                  style: TextStyle(color: Colors.white)),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  data.photoUrl != null
                                      ? Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: primaryColor,
                                                  width: 5,
                                                )),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  data.photoUrl!,
                                                  fit: BoxFit.cover,
                                                  frameBuilder: ((context,
                                                      child,
                                                      frame,
                                                      wasSynchronouslyLoaded) {
                                                    return SizedBox(
                                                      width: 160,
                                                      height: 160,
                                                      child: child,
                                                    );
                                                  }),
                                                  loadingBuilder: ((context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return SizedBox(
                                                      width: 160,
                                                      height: 160,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: primaryColor,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      )),
                                                    );
                                                  }),
                                                  errorBuilder: ((context,
                                                      error, stackTrace) {
                                                    return Ink.image(
                                                      image: const AssetImage(
                                                          'lib/src/assets/defaults/default-user-image.png'),
                                                      width: 160,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                    );
                                                  }),
                                                )),
                                          ),
                                        )
                                      : Center(
                                          child: Ink.image(
                                            image: const AssetImage(
                                                Strings.profileUserIcon),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  // wrapped with row because middle name would be optional
                                  const SizedBox(height: 24),
                                  info('STUDENT ID', data.student.idNumber!),
                                  const SizedBox(height: 8),
                                  info('NAME', data.student.fullName!),
                                  const SizedBox(height: 8),
                                  info('COURSE', data.student.course!),
                                  const SizedBox(height: 8),
                                  info('YEAR LEVEL', data.student.yearLevel!),
                                  const SizedBox(height: 8),
                                  info(
                                      'BIRTH DATE',
                                      data.student.birthDate
                                              ?.substring(0, 10) ??
                                          'Unknown'),
                                  const SizedBox(height: 8),
                                  info('SEX', data.student.sex!),
                                  const SizedBox(height: 8),
                                  info('WEIGHT', '${data.student.weight!} kg'),
                                  const SizedBox(height: 8),
                                  info('HEIGHT', '${data.student.height!} cm'),
                                  const SizedBox(height: 8),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    'ADDRESS:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: highlight,
                                    child: Text(
                                      '${data.student.barangay}, ${data.student.city}, ${data.student.province}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'PHONE NUMBER:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: highlight,
                                    child: Text(
                                      '${data.student.studentPhoneNumber}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ]),
                          ),
                        ),
                        horizontalDivider,
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Medical Record',
                            style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        PersonalSocialHistoryInformation(id: id),
                        horizontalDivider,
                        ConsultationHistory(
                          name: data.student.fullName!,
                          inAppointmentRecordItem: false,
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //     child: ConsultationHistory(name: data.student.fullName!))
              ],
            ),
          );
        },
        error: (e, st) => const ErrorPage(isNoInternetError: false),
        loading: () => const LoadingScreen());
  }
}

final highlight = BoxDecoration(
  color: Colors.orange[50],
);

Widget info(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        decoration: highlight,
        child: Text(
          value,
        ),
      ),
    ],
  );
}
