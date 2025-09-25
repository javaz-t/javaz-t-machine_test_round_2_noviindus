import 'package:flutter/material.dart';

import '../../domain/entity/category_entity.dart';

class CategorySelector extends StatefulWidget {
  final List<CategoryEntity> categories;
  final List<String> selectedCategories;
  final Function(List<String>) onSelectionChanged;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onSelectionChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {


    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.categories.map((category) {
        final isSelected = widget.selectedCategories.contains(category);

        return GestureDetector(
          onTap: () {
            List<String> newSelection = List.from(widget.selectedCategories);

            if (isSelected) {
              newSelection.remove(category.title);
            } else {
              newSelection.add(category.title);
            }

            widget.onSelectionChanged(newSelection);
            setState(() {

            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[700]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              category.title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[300],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
