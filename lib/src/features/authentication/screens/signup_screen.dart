import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/authentication/service/firestore_users_collection.dart';
import 'package:bukmd_telemedicine/src/shared/loading_provider.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/email_form.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/widgets/password_form.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _authController = UserAuthServiceController();
  bool _checkboxValue = false;
  bool _showCheckboxValidator = false;
  @override
  Widget build(BuildContext context) {
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final isLoading = ref.watch(loadingProvider);
    final usersFirestore = FirestoreUsersCollection();
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              backgroundColor: primaryColor,
              title: const Text(
                Strings.signUp,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          Form(
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                const EmailForm(underlineBorder: true),
                                const SizedBox(height: 8),
                                const PasswordForm(
                                  underlineBorder: true,
                                  formText: Strings.password,
                                  hideUnhideText: false,
                                ),
                                const SizedBox(height: 8),
                                const PasswordForm(
                                  underlineBorder: true,
                                  formText: Strings.confirmPassword,
                                  hideUnhideText: true,
                                  isConfirmPasswordForm: true,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      activeColor: primaryColor,
                                      value: _checkboxValue,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          _checkboxValue = newValue!;
                                        });
                                      },
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "I Agree to ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              showPrivacyConsent();
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(50, 30),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            child: const Text(
                                              "BukMD's privacy consent",
                                              style: TextStyle(fontSize: 12),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                                _showCheckboxValidator && !_checkboxValue
                                    ? const Text(
                                        "Agree to privacy consent to sign up",
                                        style: TextStyle(
                                            color: Color(0xFFe53935),
                                            fontSize: 12))
                                    : Container(),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    !_checkboxValue
                                        ? setState(() {
                                            _showCheckboxValidator = true;
                                          })
                                        : setState(() {
                                            _showCheckboxValidator = false;
                                          });
                                    _showCheckboxValidator
                                        ? showPrivacyConsent()
                                        : null;
                                    if (_signUpFormKey.currentState!
                                            .validate() &&
                                        _checkboxValue) {
                                      EasyLoading.show(status: 'loading...');

                                      try {
                                        ref
                                            .read(loadingProvider.notifier)
                                            .setLoadingTrue();
                                        await usersFirestore
                                            .addToUsersCollection(email);

                                        await _authController
                                            .userSignUpEmailPassword(
                                                email.trim(), password);
                                        EasyLoading.dismiss();
                                        if (!mounted) return;
                                        Navigator.pop(context);

                                        snackBar(
                                            context,
                                            Strings.successSignUpBar,
                                            primaryColor,
                                            const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ));
                                      } on FirebaseAuthException catch (e) {
                                        EasyLoading.dismiss();

                                        snackBar(
                                            context,
                                            e.message.toString(),
                                            primaryColor,
                                            const Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ));
                                      }
                                    }
                                  },
                                  child: const Text(
                                    Strings.createAccountTxt,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      Strings.askIfUserHasAccount,
                                      style: TextStyle(),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text(
                                        Strings.signIn,
                                        style: TextStyle(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  showPrivacyConsent() => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Center(
              child: Text(
            "PRIVACY CONSENT",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: SizedBox(
            height: 200,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    Strings.privacyConsent,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _checkboxValue = true;
                  Navigator.pop(context);
                });
              },
              child: const Text(
                'I Agree',
                style: TextStyle(color: Colors.green),
              ),
            )
          ],
        ),
      );
}
