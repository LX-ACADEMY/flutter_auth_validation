import 'dart:developer';

import 'package:auth_example/main.dart';
import 'package:auth_example/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final regex = RegExp(r'^([a-zA-Z0-9\.]+)@[a-zA-Z0-9]+\.[a-zA-Z0-9]{3,}$');
    if (!regex.hasMatch(value)) {
      return "Invalid email";
    }

    log(regex.firstMatch(value)!.group(1).toString());

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }

    final regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
    if (!regex.hasMatch(value)) {
      return "Weak password";
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return "Confirm password is required";
    }

    if (password != confirmPassword) {
      return "Password does not match";
    }

    return null;
  }

  static Future<void> login(String email, String password) async {}

  static Future<void> signUp(String email, String password) async {
    try {
      await AuthServices.signUp(email, password);
    } on FirebaseAuthException catch (e) {
      MyApp.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Something went wrong')),
      );
    } catch (e) {
      await showDialog(
          context: MyApp.navigatorKey.currentContext!,
          builder: (context) =>
              const AlertDialog(content: Text('Something went wrong')));
    }
  }
}
