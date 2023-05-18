import 'dart:async';
import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme/theme.dart';
import '../../../authentication/controllers/auth_view_models.dart';
import '../../../authentication/controllers/user_auth_service_controller.dart';

class EmailVerificationDialog extends ConsumerStatefulWidget {
  const EmailVerificationDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationDialogState();
}

class _EmailVerificationDialogState
    extends ConsumerState<EmailVerificationDialog> {
  bool allowResend = true;
  final authServiceController = UserAuthServiceController();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      ref
          .read(userVerificationProvider(authServiceController).notifier)
          .reloadUser();
      bool isUserVerified =
          ref.read(userVerificationProvider(authServiceController));

      isUserVerified ? timer.cancel() : null;
      if (isUserVerified) {
        Navigator.pop(context);
      }
    });
  }

  Future sendEmailVerification() async {
    await authServiceController.sendVerificationEmail();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titleTextStyle: const TextStyle(color: Colors.black),
      children: <Widget>[
        SizedBox(
          height: 500,
          width: 200,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SvgPicture.asset(
                  'lib/src/assets/images/verification-mail-sent.svg',
                  height: 110,
                ),
                const SizedBox(height: 8),
                const Text('Email verification sent to your email!',
                    textAlign: TextAlign.center),
                const Text(
                  "If it's not found in your inbox, try checking your spam folder.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: allowResend
                          ? () async {
                              await sendEmailVerification();
                              setState(
                                () {
                                  allowResend = false;
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          backgroundColor: Colors.orange[50],
                          minimumSize: const Size(0.0, 0.0),
                          disabledBackgroundColor: Colors.grey[300]),
                      child: const Text(
                        'Resend',
                      ),
                    ),
                    allowResend
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: CircularCountDownTimer(
                              width: 32,
                              height: 32,
                              duration: 60,
                              fillColor: primaryColor,
                              ringColor: Colors.grey[300]!,
                              isReverse: true,
                              isReverseAnimation: true,
                              onComplete: () {
                                setState(() {
                                  allowResend = true;
                                });
                              },
                            ),
                          )
                  ],
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
