import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/core/helper/toast_util.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/description_textfield.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/category_tile.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/category_provider.dart';
import '../providers/feed_upload_provider.dart';
import '../widgets/media_selector.dart';

class FeedUploadScreen extends StatefulWidget {
  const FeedUploadScreen({super.key});

  @override
  State<FeedUploadScreen> createState() => _FeedUploadScreenState();
}

class _FeedUploadScreenState extends State<FeedUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showAllCategory = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<FeedUploadProvider>().updateDescription('');
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<CategoryProvider>().categories;
    return Consumer<FeedUploadProvider>(
      builder: (context, uploadProvider, child) {
        if (uploadProvider.message != null && !uploadProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastUtils.showInfo(context, uploadProvider.message!);
          });
        }

        if (uploadProvider.description.isEmpty &&
            _descriptionController.text.isNotEmpty) {
          _descriptionController.clear();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text(
              'Add Feeds',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              CategoryTile(
                isSharePost: true,
                onTap: () {
                  if (uploadProvider.isLoading) {
                    return;
                  } else {
                    uploadProvider.uploadFeed();
                  }
                },
                title: 'Share Post',
                isSelected: false,
              ),
            ],
          ),
          body: uploadProvider.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      10.vs(),
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
                        MediaSelector(
                          title: 'Select a video from Gallery',
                          icon: Icons.upload_file,
                          isFileSelected: uploadProvider.videoFiles.isNotEmpty,
                          onTap: () =>
                              uploadProvider.pickMultipleVideos(_picker),
                          isVideo: true,
                        ),
                        _selectedDataDetails(
                          isSelected: uploadProvider.videoFiles.isNotEmpty,
                          isVedio: true,
                          title:
                              '${uploadProvider.videoFiles.length} videos selected',
                          onTap: () {
                            uploadProvider.clearVideos();
                          },
                        ),

                        38.vs(),
                        MediaSelector(
                          title: 'Add a Thumbnail',
                          icon: Icons.image_outlined,
                          isFileSelected: uploadProvider.imageFiles.isNotEmpty,
                          onTap: () =>
                              uploadProvider.pickMultipleImages(_picker),
                          isVideo: false,
                        ),
                        _selectedDataDetails(
                          isSelected: uploadProvider.imageFiles.isNotEmpty,
                          isVedio: false,
                          title:
                              '${uploadProvider.imageFiles.length} images selected',
                          onTap: () {
                            uploadProvider.clearImages();
                          },
                        ),

                        20.vs(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CustomText(
                            text: 'Add Description',
                            fontSize: 14,
                          ),
                        ),

                        10.vs(),
                        DescriptionTextField(
                          onChanged: (val) {
                            uploadProvider.updateDescription(val);
                          },
                          controller: _descriptionController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Categories This Project",
                              fontSize: 14,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAllCategory = !_showAllCategory;
                                });
                              },
                              child: Text(
                                _showAllCategory ? "" : 'View All',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        12.vs(),
                        Consumer<FeedUploadProvider>(
                          builder: (context, feedProvider, child) {
                            final displayCategories = _showAllCategory
                                ? categories
                                : categories.take(5).toList();
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: displayCategories.map((category) {
                                final isSelected = feedProvider
                                    .selectedCategoryIds
                                    .contains(category.id);

                                return CategoryTile(
                                  onTap: () {
                                    feedProvider.updateCategoryId(category.id);
                                  },
                                  title: category.title,
                                  isSelected: isSelected,
                                );
                              }).toList(),
                            );
                          },
                        ),

                        40.vs(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }



  Widget _selectedDataDetails({
    required bool isSelected,
    required bool isVedio,
    required String title,
    required Function() onTap,
  }) {
    if (!isSelected) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.deepPurple)),
        TextButton(
          onPressed: onTap,
          child: CustomText(
            text: 'Clear selected ${isVedio ? "videos" : "images"}',
            fontSize: 10,
            fontColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
