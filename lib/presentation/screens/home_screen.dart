import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/category_list.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Text('Hello'),
            CategoryList()
          ],
        ),
      ),
    );
  }
}
