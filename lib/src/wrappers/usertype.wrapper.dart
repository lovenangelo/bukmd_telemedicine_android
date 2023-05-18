import 'package:bukmd_telemedicine/src/features/authentication/controllers/firestore_users_collection_controller.dart';
import 'package:bukmd_telemedicine/src/features/authentication/service/firebase_auth_service.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/wrappers/doctor_bottom_nav_bar_wrapper.dart';
import 'package:bukmd_telemedicine/src/wrappers/registration_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTypeWrapper extends ConsumerWidget {
  const UserTypeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType =
        ref.watch(getUserTypeProvider(FirebaseAuthService().currentUserEmail!));

    return userType.when(
        data: (isDoctor) {
          return isDoctor != null && isDoctor
              ? const DoctorBottomNavBarWrapper()
              : const RegistrationFormWrapper();
        },
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const LoadingScreen());
  }
}
