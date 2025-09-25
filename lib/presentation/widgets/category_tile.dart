import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';

class CategoryTile extends StatelessWidget {
  final bool isSharePost;
  final Function() onTap;
  final String title;
  final bool isSelected;
  const CategoryTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,this.isSharePost=false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isSharePost? const EdgeInsets.only(right: 14):const    EdgeInsets.all(0),
        padding:isSharePost? const EdgeInsets.symmetric(horizontal: 20,vertical: 8):const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:isSharePost?AppColors.accentRed.withOpacity(.2): isSelected ? Colors.blue.withOpacity(0.2) : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : AppColors.accentRed,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[300],
            fontSize: isSharePost?13:10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
