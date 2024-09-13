import 'package:auth_example/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhoneLogin extends HookWidget {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = useTextEditingController();
    final otpController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PhoneLogin"),
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
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final verificationId =
                          await AuthServices.sendOTP(phoneController.text);

                      showModalBottomSheet(
                        context: context,
                        builder: (context) => HookBuilder(builder: (context) {
                          final isInvalidOTP = useState(false);

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: otpController,
                                  decoration: const InputDecoration(
                                    labelText: "OTP",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                if (isInvalidOTP.value)
                                  const Text(
                                    'Invalid OTP, try again',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ElevatedButton(
                                  onPressed: () async {
                                    /// Verify OTP
                                    try {
                                      await AuthServices.verifyOTP(
                                          otpController.text, verificationId);
                                      // Navigator.pop(context);
                                    } catch (e) {
                                      isInvalidOTP.value = true;
                                    }
                                  },
                                  child: const Text("Submit"),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login failed'),
                        ),
                      );
                    }
                  },
                  child: const Text("SignIn")),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
