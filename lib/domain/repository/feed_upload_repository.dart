import 'package:image_picker/image_picker.dart';

abstract class FeedUploadRepository {
  Future<void> uploadFeed({
    required List<XFile> videoFiles,
    required List<XFile> imageFiles,
    required String description,
    required List<int> categoryIds,
    required String accessToken,
  });
}
