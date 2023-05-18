import 'package:bukmd_telemedicine/src/features/profiling/application/students_firestore_controller.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/user_information_screen.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/wrappers/bottom_navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationFormWrapper extends ConsumerWidget {
  const RegistrationFormWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentData = ref.watch(studentDataProvider);

    return studentData.when(
        data: ((data) {
          if (data != null) {
            return const BottomNavBarWrapper();
          } else {
            return const UserInformationScreen(
              title: 'PERSONAL INFORMATION',
              canSignOut: true,
            );
          }
        }),
        error: (e, st) {
          throw e.toString();
        },
        loading: () => const LoadingScreen());
  }
}
