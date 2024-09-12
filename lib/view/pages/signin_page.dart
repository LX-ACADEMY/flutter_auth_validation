import 'package:auth_example/view/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInPage extends HookWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    var isloading = useState(false);

    Future<void> signin() async {
      isloading.value = true;

      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      }

      isloading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Signin"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "password",
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(
                height: 8,
              ),
              TextButton(onPressed: signin, child: const Text("SignIn")),
              if (isloading.value) const CircularProgressIndicator(),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Spacer(),
                  const Text("Don't have an account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text("SignUp"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
