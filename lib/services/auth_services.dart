import 'package:firebase_auth/firebase_auth.dart';

final class AuthServices {
  static Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signUp(String email, String password) async {
    throw Exception('Ssdfsdfdsfs');
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> resetPassword(String newPasword) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPasword);
  }

  static Future<void> sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }
}
