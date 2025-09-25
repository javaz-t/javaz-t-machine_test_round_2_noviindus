 import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';

class CategoryApiService {
  static const String _baseUrl = 'https://frijo.noviindus.in/api';

  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/category_list');

    // NOTE: For a real app, do not hardcode the Cookie/CSRF token.
    // They should be fetched from an authentication flow.
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'csrftoken=AFPZD2F2WSb468xXIHTL9pPZuEOY4zdk; sessionid=ak9job3jvyjnhvanymq6ydy3pc4xlqjj',
    };

    final body = jsonEncode({"name": "Add your name in the body"});

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200||response.statusCode == 202) {
      final jsonResponse = jsonDecode(response.body);
      final List categoriesJson = jsonResponse['categories'];

      return categoriesJson
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories. Status code: ${response.statusCode}');
    }
  }
}
