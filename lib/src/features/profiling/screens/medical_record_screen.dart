import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/family_history_lv_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/immunization_history_lv_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/past_medical_history_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/personal_social_history_screen.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/error_page.dart';
import '../application/checkboxes/family_history_illness_list_provider.dart';
import '../application/checkboxes/immunization_history_list_provider.dart';
import '../application/students_firestore_controller.dart';

class MedicalRecordScreen extends ConsumerStatefulWidget {
  const MedicalRecordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends ConsumerState<MedicalRecordScreen> {
  final authServiceController = UserAuthServiceController();
  final _pageController = PageController(initialPage: 0);
  final _studentsFirestore = StudentsFirestoreController();

  @override
  void initState() {
    initializeFields();
    super.initState();
  }

  void initializeFields() async {
    final immunizationData =
        await _studentsFirestore.readStudentImmunizationHistory();

    final familyHistoryData =
        await _studentsFirestore.readStudentFamilyHistory();

    if (immunizationData == null) return;
    ref
        .read(immunizationHistoryIllnessListProvider.notifier)
        .updateState(immunizationData);
    if (familyHistoryData == null) return;
    ref
        .read(familyHistoryIllnessListProvider.notifier)
        .updateState(familyHistoryData);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalSocialHistory =
        ref.watch(studentPersonalSocialHistoryProvider);
    final pastMedicalHistory = ref.watch(studentPastMedicalHistoryProvider);

    final pages = [
      personalSocialHistory.when(
        data: (data) {
          return PersonalSocialHistoryLVScreen(
            pageController: _pageController,
            data: data,
          );
        },
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: primaryColor,
          ),
        ),
      ),
      pastMedicalHistory.when(
        data: (data) {
          return PastMedicalHistoryLVScreen(
            pageController: _pageController,
            data: data,
          );
        },
        error: (e, st) =>
            const Expanded(child: ErrorPage(isNoInternetError: false)),
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: primaryColor,
          ),
        ),
      ),
      FamilyHistoryLVScreen(pageController: _pageController),
      ImmunizationHistoryLVScreen(pageController: _pageController),
    ];

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
        ),
        backgroundColor: primaryColor,
      ),
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return lvContainer(pages[index]);
        },
      ),
    );
  }

  Widget lvContainer(Widget lvScreen) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: lvScreen,
    );
  }
}
