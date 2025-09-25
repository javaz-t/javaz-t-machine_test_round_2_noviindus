import 'package:image_picker/image_picker.dart';

import '../repository/feed_upload_repository.dart';

class UploadFeedUseCase {
  final FeedUploadRepository repository;

  UploadFeedUseCase(this.repository);

  Future<void> call({
    required List<XFile> videoFiles,
    required List<XFile> imageFiles,
    required String description,
    required List<int> categoryIds,
    required String accessToken, // Pass token from presentation/storage
  }) async {
     if (description.isEmpty || categoryIds.isEmpty) {
      throw Exception('Description and categories are mandatory.');
    }

    await repository.uploadFeed(
      videoFiles: videoFiles,
      imageFiles: imageFiles,
      description: description,
      categoryIds: categoryIds,
      accessToken: accessToken,
    );
  }
}
