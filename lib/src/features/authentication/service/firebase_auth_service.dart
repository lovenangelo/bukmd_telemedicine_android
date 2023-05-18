import 'package:bukmd_telemedicine/src/features/authentication/models/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? get isUserEmailVerified => _auth.currentUser!.emailVerified;

  String? get currentUserEmail => _auth.currentUser!.email;

  String? get currentUserUid => _auth.currentUser!.uid;

  User? get currentUser => _auth.currentUser!;

  String? get photoUrl => _auth.currentUser!.photoURL;

  Stream<User?> authStateChange() {
    return _auth.authStateChanges();
  }

  FirebaseUser? userFromFirebase(User? user) {
    return user != null ? FirebaseUser(uid: user.uid, email: user.email) : null;
  }

  Future signInEmailPassword(email, password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future signUpEmailPassword(email, password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future signOut() async {
    return await _auth.signOut();
  }

  Future sendPasswordResetEmail(email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future sendVerificationEmail() async {
    return await _auth.currentUser!.sendEmailVerification();
  }

  Future reloadUser() async {
    return await _auth.currentUser?.reload();
  }

  Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
  }

  Future<void> updatePhotoUrl(String? url) async {
    try {
      await currentUser?.updatePhotoURL(url);
    } catch (e) {
      print(e.toString());
    }
  }
}
