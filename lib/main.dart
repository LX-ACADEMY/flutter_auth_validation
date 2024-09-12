import 'package:auth_example/firebase_options.dart';
import 'package:auth_example/view/pages/home_page.dart';
import 'package:auth_example/view/pages/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends HookWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null || !user.emailVerified) {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        } else {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      });

      return null;
    }, []);

    return MaterialApp(
      title: 'Auth Example',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const SignInPage(),
    );
  }
}
