import 'package:auth_example/controller/auth_controller.dart';
import 'package:auth_example/view/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmController = useTextEditingController();

    final isloading = useState(false);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    Future<void> signUp() async {
      isloading.value = true;

      // if (formKey.currentState!.validate()) {
      await AuthController.signUp(
          emailController.text, passwordController.text);
      // }

      isloading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: AuthController.validateEmail,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: AuthController.validatePassword,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => AuthController.validateConfirmPassword(
                      passwordController.text, value),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: signUp, child: const Text("SignUp")),
                if (isloading.value) const CircularProgressIndicator(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Spacer(),
                    const Text("Already have an account"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
                        },
                        child: const Text("SignIn"))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () async {},
                    child: const Text("Signin with Google"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
