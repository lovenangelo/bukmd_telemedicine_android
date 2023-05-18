import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/shared/loading_provider.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/email_form.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final countDown = ref.watch(countDownProvider);
    final email = ref.watch(emailProvider);
    final authController = UserAuthServiceController();
    final isLoading = ref.watch(loadingProvider);

    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              backgroundColor: primaryColor,
              title: Text(
                Strings.resetPassword.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'A link will be sent to your email to reset your password.',
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: widget._forgotPasswordFormKey,
                      child: const EmailForm(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: (countDown == 60 || countDown == 0)
                          ? () async {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              if (countDown == 0) {
                                ref
                                    .read(countDownProvider.notifier)
                                    .stopCountDown();
                              }
                              if (widget._forgotPasswordFormKey.currentState!
                                  .validate()) {
                                try {
                                  ref
                                      .read(loadingProvider.notifier)
                                      .setLoadingTrue();
                                  await authController
                                      .userResetPassword(email.trim());
                                  ref
                                      .read(loadingProvider.notifier)
                                      .setLoadingFalse();

                                  ref
                                      .read(countDownProvider.notifier)
                                      .startCountDown();
                                  if (!mounted) return;
                                  snackBar(context, Strings.snackbarSuccess,
                                      Colors.green[400]);
                                } on FirebaseAuthException catch (e) {
                                  ref
                                      .read(loadingProvider.notifier)
                                      .setLoadingFalse();
                                  snackBar(context, e.message.toString(),
                                      Colors.red[400]);
                                }
                              }
                            }
                          : null,
                      child: (countDown == 0)
                          ? const Text(
                              'Resend',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Send',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                    ),
                    const SizedBox(height: 24),
                    countDown != 0
                        ? Text(
                            'Resend link after ${countDown}s',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
  }
}
