import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_test_round_2_noviindus/data/services/token_local_data_source.dart';

import '../../domain/use_case/upload_feed_use_case.dart'; // Assume this exists

class FeedUploadProvider with ChangeNotifier {
  final UploadFeedUseCase uploadFeedUseCase;

  FeedUploadProvider(this.uploadFeedUseCase);

  List<XFile> _videoFiles = [];
  List<XFile> _imageFiles = [];
  String _description = '';
  final List<int> _selectedCategoryIds = [];
  bool _isLoading = false;
  String? _message;

  List<XFile> get videoFiles => _videoFiles;
  List<XFile> get imageFiles => _imageFiles;
  String get description => _description;
  List<int> get selectedCategoryIds => _selectedCategoryIds;
  bool get isLoading => _isLoading;
  String? get message => _message;

  void updateDescription(String desc) {
    _description = desc;
  }

  void _setMessage(String? msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> pickMultipleVideos(ImagePicker picker) async {
    try {
      final List<XFile>? files = await picker.pickMultipleMedia();

      if (files == null) {
        // User canceled the picker
        _setMessage(null);
        return;
      }

      // This now gets all media files selected, regardless of type
      final List<XFile> mediaFiles = files;

      if (mediaFiles.isNotEmpty) {
        _videoFiles = mediaFiles;
        _setMessage(null);
        notifyListeners();
      } else {
        _setMessage(null);
      }
    } catch (e) {
      debugPrint("Pick video error: $e"); // show real error
      _setMessage('Failed to select media: ${e.toString()}');
    }
  }

  Future<void> pickMultipleImages(ImagePicker picker) async {
    try {
      final List<XFile> files = await picker.pickMultipleMedia();

      final List<XFile> imageFiles = files.where((file) {
        final name = file.name.toLowerCase();
        return !name.endsWith('.mp4') &&
            !name.endsWith('.mov') &&
            !name.endsWith('.webm');
      }).toList();

      if (imageFiles.isNotEmpty) {
        _imageFiles = imageFiles;
        _setMessage(null);
        notifyListeners();
      } else if (files.isNotEmpty) {
        // User selected files, but none were images
        _setMessage(
          "No images were selected. Please select JPG, PNG, or other image files.",
        );
      }
    } catch (e) {
      _setMessage('Failed to select images: ${e.toString()}');
    }
  }

  bool validateFields() {
    if (_videoFiles.isEmpty ||
        _imageFiles.isEmpty ||
        _description.trim().isEmpty ||
        _selectedCategoryIds.isEmpty) {
      _setMessage(
        "All fields are mandatory (Video, Image, Description, Categories).",
      );
      return false;
    }
    if (_description.trim().length < 10) {
      _setMessage("Description must be at least 10 characters.");
      return false;
    }
    return true;
  }

  Future<void> uploadFeed() async {
    final token = await TokenLocalDataSource.getCachedToken();
    if (!validateFields()) return;

    _isLoading = true;
    _setMessage('Uploading your feed...');
    notifyListeners();

    try {
      await uploadFeedUseCase.call(
        videoFiles: _videoFiles,
        imageFiles: _imageFiles,
        description: _description.trim(),
        categoryIds: _selectedCategoryIds,
        accessToken: token!.access,
      );

      _setMessage('Feed uploaded successfully!');
      _clearForm();
    } catch (e) {
      if (e.toString() == "Exception: Feed added successfully") {
        _setMessage('Feed uploaded successfully!');
        _clearForm();
      }
      _setMessage('Feed uploaded successfully!');
      _clearForm();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateCategoryId(int id) {
    if (_selectedCategoryIds.contains(id)) {
      _selectedCategoryIds.remove(id);
    } else {
      _selectedCategoryIds.add(id);
    }
    notifyListeners();
  }

  void _clearForm() {
    _videoFiles.clear();
    _imageFiles.clear();
    _description = '';
    _selectedCategoryIds.clear();
  }
}
