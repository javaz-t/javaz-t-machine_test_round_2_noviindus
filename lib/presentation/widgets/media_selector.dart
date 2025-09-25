import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MediaSelector extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isFileSelected;
  final VoidCallback onTap;
  final bool isVideo;

  const MediaSelector({
    super.key,
    required this.title,
    required this.icon,
    required this.isFileSelected,
    required this.onTap,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 10],
          strokeWidth: 1,
          radius: Radius.circular(16),
          color: Colors.white12,
          padding: EdgeInsets.all(16),
        ),
        child: Container(
          width: double.infinity,
          height: isVideo?270:120,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),
           ),
          child: isFileSelected
              ? _buildSelectedMedia()
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildSelectedMedia() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child:  Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.done_all,
                color: Colors.green,
                size: 40,
              ),

            ],
          ),
        ),
      )

    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.grey[400],
          size: 32,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

