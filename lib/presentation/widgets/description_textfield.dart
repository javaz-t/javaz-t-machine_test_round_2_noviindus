import 'package:flutter/material.dart';

class DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  const DescriptionTextField({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.blue, fontSize: 13),
      controller: controller,
      onChanged: onChanged,
      maxLines: 2,
      decoration: InputDecoration(
        hintText:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Congue lacus iaculis aliquam integer pulvinar...',
        hintStyle: TextStyle(color: Colors.white24, fontSize: 11),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Description is required';
        }
        if (value.trim().length < 10) {
          return 'Description must be at least 10 characters';
        }
        return null;
      },
    );
  }
}
