import 'dart:io';
import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/category_provider.dart';
import '../providers/feed_upload_provider.dart';
import '../widgets/media_selector.dart';

class AddFeedPage extends StatefulWidget {
  const AddFeedPage({Key? key}) : super(key: key);

  @override
  State<AddFeedPage> createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Local state to track selected categories by NAME for the CategorySelector widget
  List<String> _localSelectedCategoryNames = [];

  @override
  void initState() {
    super.initState();
    // Load categories when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      // Initialize description in the provider if needed
      context.read<FeedUploadProvider>().updateDescription('');
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCategoriesSelected(
    FeedUploadProvider uploadProvider,
    List<String> selectedNames,
    List<CategoryEntity> allCategories, // Pass all available categories
  ) {
    // 1. Update local state for the CategorySelector widget
    setState(() {
      _localSelectedCategoryNames = selectedNames;
    });

    // 2. Update the provider with IDs for the API call
    //   uploadProvider.updateSelectedCategories(allCategories, selectedNames);
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<CategoryProvider>().categories;
    return Consumer<FeedUploadProvider>(
      builder: (context, uploadProvider, child) {
        // Handle post-upload message display
        if (uploadProvider.message != null && !uploadProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(
              context,
              uploadProvider.message!,
              isError: uploadProvider.message!.toLowerCase().contains('failed'),
            );
            // Clear message after display
            //   uploadProvider._setMessage(null);
          });
        }

        // This is necessary to sync the TextEditingController when the provider clears the form
        if (uploadProvider.description.isEmpty &&
            _descriptionController.text.isNotEmpty) {
          _descriptionController.clear();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Simple pop navigation
                  },
                  icon: const Icon(Icons.navigate_before),
                ),
                const Text(
                  'Add Feeds',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: uploadProvider.isLoading
                    ? null
                    : () => uploadProvider.uploadFeed(),
                child: CustomText(
                  text: 'Share Post',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  // Disable color when loading
                  fontColor: uploadProvider.isLoading
                      ? Colors.grey
                      : Colors.blue,
                ),
              ),
            ],
          ),
          body: uploadProvider.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        uploadProvider.message ?? 'Uploading your feed...',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Selector
                        MediaSelector(
                          title: 'Select a video from Gallery',
                          icon: Icons.videocam_outlined,
                          // Convert XFile? to File? for the widget to display
                          selectedFile: uploadProvider.videoFiles.isNotEmpty
                              ? File(
                                  uploadProvider.videoFiles.first.path,
                                ) // FIX IS HERE
                              : null,
                          onTap: () =>
                              uploadProvider.pickMultipleVideos(_picker),
                          isVideo: true,
                        ),

                        const SizedBox(height: 20),

                        // Thumbnail Selector
                        MediaSelector(
                          title: 'Add a Thumbnail',
                          icon: Icons.image_outlined,
                          selectedFile: uploadProvider.imageFiles.isNotEmpty
                              ? File(uploadProvider.imageFiles!.first.path)
                              : null,
                          onTap: () =>
                              uploadProvider.pickMultipleImages(_picker),
                          isVideo: false,
                        ),

                        const SizedBox(height: 20),

                        // Description Input
                        const Text(
                          'Add Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[700]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: _descriptionController,
                            style: const TextStyle(color: Colors.white),
                            onChanged: uploadProvider
                                .updateDescription, // Update provider directly
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Congue lacus iaculis aliquam integer pulvinar...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
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
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Categories Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Categories This Project',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Show all categories logic here
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Consumer<FeedUploadProvider>(
                          builder: (context, feedProvider, child) {
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: categories.map((category) {
                                final isSelected = feedProvider
                                    .selectedCategoryIds
                                    .contains(category.id);

                                return GestureDetector(
                                  onTap: () {
                                    feedProvider.updateCategoryId(category.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.withOpacity(0.2)
                                          : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey[700]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      category.title,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey[300],
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

