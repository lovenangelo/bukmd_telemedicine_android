import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/consultation_history.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/patient_medical_record/personal_social_history_information.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceController = UserAuthServiceController();
final pageController = PageController(keepPage: false, initialPage: 0);

class PatientMedicalRecordScreen extends ConsumerStatefulWidget {
  const PatientMedicalRecordScreen({Key? key, required this.id})
      : super(key: key);
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MedicalRecordScreenState();
}

class _MedicalRecordScreenState
    extends ConsumerState<PatientMedicalRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white));
          }),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Medical Record',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            PersonalSocialHistoryInformation(id: widget.id),
          ],
        ));
  }
}
