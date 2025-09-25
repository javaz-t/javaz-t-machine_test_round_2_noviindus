import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/category_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_shimmer.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedIndex = context.watch<CategoryProvider>().selectedIndex;

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return CategoryShimmer();
        }

        if (categoryProvider.errorMessage != null) {
          return Center(
            child: Text(
              categoryProvider.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
        }

        if (categoryProvider.categories.isEmpty) {
          return const Center(
            child: Text(
              'No categories available',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          );
        }

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              return GestureDetector(
                onTap: () {
                  categoryProvider.onCategoryChange(index,category.title);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColors.accentRed
                                : AppColors.primaryText,
                          ),
                        ),
                        child: CustomText(
                          text: category.title,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
