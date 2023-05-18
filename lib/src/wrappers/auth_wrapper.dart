import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/authentication/screens/signin_screen.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/wrappers/usertype.wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangeProvider);
    return user.when(
        data: ((data) {
          return data != null ? const UserTypeWrapper() : SignInScreen();
        }),
        error: (e, st) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const LoadingScreen());
  }
}
