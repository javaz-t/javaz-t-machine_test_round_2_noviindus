import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/navigation_extension.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Enter Phone"),
            ),
            const SizedBox(height: 20),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isLoading) {
                  return const CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () async {
                    await authProvider.verifyOtp("+91", "8129466718");
                    if (authProvider.token != null) {
                      pushAndRemoveUntilScreen(HomeScreen(), context);
                    } else if (authProvider.failure != null) {
                      // Failure → show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.failure!.errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Verify OTP"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
