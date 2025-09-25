import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final Color fontColor;
  final double fontSize;
  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.fontColor = AppColors.primaryText,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
      ),
    );
  }
}
