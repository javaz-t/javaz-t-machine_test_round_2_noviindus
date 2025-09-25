import 'package:image_picker/image_picker.dart';
import 'package:machine_test_round_2_noviindus/data/services/feed_upload_service.dart';
import '../../domain/repository/feed_upload_repository.dart';

class FeedUploadRepositoryImpl implements FeedUploadRepository {
  final FeedUploadService service;

  FeedUploadRepositoryImpl(this.service, );

  @override
  Future<void> uploadFeed({
    required List<XFile> videoFiles,
    required List<XFile> imageFiles,
    required String description,
    required List<int> categoryIds,
    required String accessToken,
  }) async {
    await service.uploadFeed(
      accessToken: accessToken,
      imageFiles: imageFiles,
      description: description,
      categoryIds: categoryIds,
      videoFiles: videoFiles
    );
    // Note: We ignore the successful response body here since the use case only cares about completion/error.
  }
}
