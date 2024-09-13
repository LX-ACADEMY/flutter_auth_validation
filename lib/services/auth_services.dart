import 'dart:async';

import 'package:auth_example/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final class AuthServices {
  static Future<void> login(String email, String password) async {
    final user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (!user.user!.emailVerified) {
      await user.user!.sendEmailVerification();

      MyApp.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text("Please verify your email"),
        ),
      );
    }
  }

  static Future<void> signUp(String email, String password) async {
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

  static Future<String> sendOTP(String phoneNumber) async {
    Completer<String> verifyIdCompleter = Completer<String>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        verifyIdCompleter.complete(verificationId);
      },
      verificationFailed: (error) {
        MyApp.scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Phone authentication failed'),
          ),
        );
      },
      verificationCompleted: (phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    await verifyIdCompleter.future;
    return verifyIdCompleter.future;
  }

  /// Verify OTP
  static Future<void> verifyOTP(String otp, String verificationId) async {
    final phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

    final user = FirebaseAuth.instance.currentUser;
    print(user);
  }
}
