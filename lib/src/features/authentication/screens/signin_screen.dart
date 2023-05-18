import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/email_form.dart';
import 'package:bukmd_telemedicine/src/widgets/password_form.dart';
import 'package:bukmd_telemedicine/src/widgets/remove_screen_keyboard.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends ConsumerStatefulWidget {
  SignInScreen({Key? key}) : super(key: key);
  final _loginFormKey = GlobalKey<FormState>();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _authController = UserAuthServiceController();
  @override
  Widget build(BuildContext context) {
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white24,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SvgPicture.asset(
                    Strings.logo,
                    width: 220.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: widget._loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const EmailForm(),
                        const SizedBox(height: 16),
                        const PasswordForm(
                          underlineBorder: false,
                          formText: Strings.password,
                          hideUnhideText: false,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotpassword');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                          child: const Text(
                            Strings.forgotPassword,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            removeKeyboard();
                            if (widget._loginFormKey.currentState!.validate()) {
                              EasyLoading.show(status: 'Signing in...');
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              try {
                                await _authController.userSignInEmailPassword(
                                    email.trim(), password);
                                EasyLoading.dismiss();
                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                              } on FirebaseAuthException catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                if (e.code == 'network-request-failed') {
                                  snackBar(
                                      context,
                                      'No internet connection',
                                      primaryColor,
                                      const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                  return;
                                }
                                snackBar(
                                    context,
                                    'Sign in failed',
                                    primaryColor,
                                    const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  Strings.noAccountYet,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                  child: const Text(
                    Strings.signUpCall,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
