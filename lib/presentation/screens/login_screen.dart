
import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/navigation_extension.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/home_screen.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             40.vs(),
        CustomText(text: 'Enter Your\nMobile Number'),
        16.vs(),
        const SizedBox(height: 16),
        // Description
        CustomText(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          text:
          'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
        ),
        36.vs(), // Phone nu
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Enter Phone"),
            ),
            const SizedBox(height: 20),
           /* Consumer<AuthProvider>(
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
            ),*/
           ],
        ),
      ),
    );
  }
}

