 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_test_round_2_noviindus/core/constants/constants.dart';
import '../model/feed_model.dart';

class HomeApiService {

  Future<List<FeedModel>> fetchHomeFeeds() async {
    final url = Uri.parse(AppConstats.baseUrl+AppConstats.home);


    final response = await http.get(url,  );

    if (response.statusCode == 200 ||response.statusCode == 202) {
      final jsonResponse = jsonDecode(response.body);
      final List resultsJson = jsonResponse['results'];
print(resultsJson);
      return resultsJson
          .map((json) => FeedModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load home feeds. Status code: ${response.statusCode}');
    }
  }
}
