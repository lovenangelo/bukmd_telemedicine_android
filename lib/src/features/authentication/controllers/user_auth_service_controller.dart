import 'dart:async';

import 'package:bukmd_telemedicine/src/features/authentication/service/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateChangeProvider = StreamProvider.autoDispose<User?>(
    (ref) => UserAuthServiceController().authStateChange());

class UserAuthServiceController {
  final _auth = FirebaseAuthService();

  Future userSignInEmailPassword(String email, String password) async {
    await _auth.signInEmailPassword(email, password);
  }

  Future userSignOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChange() {
    return _auth.authStateChange();
  }

  Future userSignUpEmailPassword(String email, String password) async {
    return await _auth.signUpEmailPassword(email, password);
  }

  Future userResetPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email);
  }

  bool? get isUserEmailVerified => _auth.isUserEmailVerified ?? false;

  Future sendVerificationEmail() async {
    return await _auth.sendVerificationEmail();
  }

  Future reloadUser() async {
    return await _auth.reloadUser();
  }

  String? getUserEmail() {
    return _auth.currentUserEmail;
  }

  String? getUserUid() {
    return _auth.currentUserUid;
  }

  User? get currentUser => _auth.currentUser!;
}
