import 'package:auth_example/services/auth_services.dart';
import 'package:auth_example/view/pages/phone_login.dart';
import 'package:auth_example/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInPage extends HookWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final forgotPasswordEmailController = useTextEditingController();

    var isloading = useState(false);

    Future<void> signin() async {
      isloading.value = true;

      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await AuthServices.login(emailController.text, passwordController.text);
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PhoneLogin(),
                    ));
                  },
                  child: const Text("SignIn with Phone"),
                ),
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
                    child: const Text("SignUp"),
                  ),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                controller: forgotPasswordEmailController,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      await AuthServices.forgotPassword(
                                          forgotPasswordEmailController.text);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Cannot reset password')));
                                    } finally {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Send Reset Link")),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text("Forgot password?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
