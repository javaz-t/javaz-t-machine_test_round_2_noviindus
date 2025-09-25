import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/navigation_extension.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/home_screen.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
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
            36.vs(),
            Row(
              children: [
                Container(
                  width: 60,height: 55,
                  decoration: BoxDecoration(border: BoxBorder.all(width: 1,color: Colors.white),borderRadius: BorderRadius.circular(5)),
                  child: Center(child: CustomText(text: '+91',fontWeight: FontWeight.w400,fontSize: 20,))),10.hs(),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Enter Phone Number",
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Optional: Rounded corners
                        borderSide: BorderSide(color: Colors.white),
                      ),
                       prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        // Placeholder for a Country Code Picker Widget

                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return GestureDetector(
                    onTap: () async {
                      await authProvider.verifyOtp("+91", "8129466718");
                      if (authProvider.token != null) {
                        print("acees token ${authProvider.token!.access}");
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
                    child: Container(
                      // Added decoration for border and curve
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 1.0, // Border thickness
                        ),
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ), // Fully curved sides
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ), // Added padding to space content from border

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Continue',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          15.hs(),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.accentRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.primaryText,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            20.vs(),
          ],
        ),
      ),
    );
  }
}
