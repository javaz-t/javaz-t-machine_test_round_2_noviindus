import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machine_test_round_2_noviindus/core/constants/api_constants.dart';

class FeedUploadService {

  Future<Map<String, dynamic>> uploadFeed({
    required String accessToken,
    required List<XFile> videoFiles,
    required List<XFile> imageFiles,
    required String description,
    required List<int> categoryIds,
  }) async {
    final uri = Uri.parse(ApiConstats.baseUrl + ApiConstats.feedUpload);
    final request = http.MultipartRequest('POST', uri);

     request.headers['Authorization'] = 'Bearer $accessToken';

     if (videoFiles.isEmpty) {
      throw Exception('Video file list cannot be empty.');
    }
    if (imageFiles.isEmpty) {
      throw Exception('Image file list cannot be empty.');
    }

    request.files.add(
      await http.MultipartFile.fromPath('video', videoFiles.first.path),
    );

     request.files.add(
      await http.MultipartFile.fromPath('image', imageFiles.first.path),
    );

    // 3. Add Text Fields
    request.fields['desc'] = description;
    // CRUCIAL: Encode the list of integers to a JSON string
    request.fields['category'] = jsonEncode(categoryIds);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseBody = jsonDecode(response.body);

      // Status code check updated to include 202
      if (response.statusCode == 200 || response.statusCode == 202) {
        return responseBody;
      } else {
        // Handle API errors (e.g., validation failure from server)
        throw Exception(
          responseBody['message'] ?? 'Failed to upload feed. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle network errors, file errors, etc.
      throw Exception('Upload failed: ${e.toString()}');
    }
  }
}
