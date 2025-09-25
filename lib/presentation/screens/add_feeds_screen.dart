import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';

class AddFeedsScreen extends StatelessWidget {
  const AddFeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          50.vs(),
          ElevatedButton(
            onPressed: () async {
              print('started');
              final videos = await pickMultipleVideos();
              if (videos.isNotEmpty) {
                print("Picked ${videos.length} videos");
                // You can now upload, play, or show them in a list
              }
              print('started');
            },
            child: Text("Select video from gallery "),
          ),
          20.vs(),
          ElevatedButton(
            onPressed: () async {
              final images = await pickMultipleImages();
              if (images.isNotEmpty) {
                print("Picked ${images.length} images");
                // Display them in a grid or upload to API
              }
            },
            child: const Text("Pick Images"),
          ),
        ],
      ),
    );
  }

  Future<List<File>> pickMultipleVideos() async {
    try {
      // Opens gallery for multiple video selection
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Convert picked files to File objects
        return result.paths.map((path) => File(path!)).toList();
      } else {
        return []; // User canceled
      }
    } catch (e) {
      print("Error picking videos: $e");
      return [];
    }
  }

  /// Picks multiple images from device gallery and returns them as a list of [File].
  Future<List<File>> pickMultipleImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.paths.map((path) => File(path!)).toList();
      } else {
        return []; // User canceled
      }
    } catch (e) {
      print("Error picking images: $e");
      return [];
    }
  }
}
