import 'dart:async';

import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers

final emailProvider =
    StateNotifierProvider.autoDispose<EmailFormNotifier, String>((ref) {
  return EmailFormNotifier();
});

final passwordProvider =
    StateNotifierProvider.autoDispose<PasswordFormNotifier, String>((ref) {
  return PasswordFormNotifier();
});

final confirmPasswordProvider =
    StateNotifierProvider.autoDispose<ConfirmPasswordFormNotifier, String>(
        (ref) {
  return ConfirmPasswordFormNotifier();
});

final passwordObscurationProvider =
    StateNotifierProvider.autoDispose<PasswordObscurationNotifier, bool>((ref) {
  return PasswordObscurationNotifier();
});

final countDownProvider = StateNotifierProvider<CountDownNotifier, int>((ref) {
  return CountDownNotifier();
});

final userVerificationProvider = StateNotifierProvider.family<
    UserVerificationNotifier,
    bool,
    UserAuthServiceController>((ref, userAuthService) {
  return UserVerificationNotifier(userAuthService);
});

class EmailFormNotifier extends StateNotifier<String> {
  EmailFormNotifier() : super('');
  void setEmail(String email) {
    super.state = email;
  }
}

class PasswordFormNotifier extends StateNotifier<String> {
  PasswordFormNotifier() : super('');
  void setPassword(String password) {
    super.state = password;
  }
}

class ConfirmPasswordFormNotifier extends StateNotifier<String> {
  ConfirmPasswordFormNotifier() : super('');
  void setPassword(String password) {
    super.state = password;
  }
}

class PasswordObscurationNotifier extends StateNotifier<bool> {
  PasswordObscurationNotifier() : super(false);
  void toggleVisibility() {
    super.state = !super.state;
  }
}

class CountDownNotifier extends StateNotifier<int> {
  CountDownNotifier() : super(60);
  Timer? countDownTimer;

  void startCountDown() {
    if (super.state == 0) super.state = 60;
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (super.state > 0) {
        super.state--;
      }
    });
  }

  void stopCountDown() {
    countDownTimer?.cancel();
  }
}

class UserVerificationNotifier extends StateNotifier<bool> {
  UserVerificationNotifier(UserAuthServiceController userAuthService)
      : super(userAuthService.isUserEmailVerified ?? false);

  final userAuthService = UserAuthServiceController();

  Timer? timer;

  reloadUser() async {
    await userAuthService.reloadUser();
    state = userAuthService.isUserEmailVerified!;
  }
}
