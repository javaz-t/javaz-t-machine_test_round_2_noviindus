import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_test_round_2_noviindus/core/constants/constants.dart';
import 'package:machine_test_round_2_noviindus/data/model/token_model.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';

class AuthService {
  Future<Token> verifyOtp(String countryCode, String phone) async {
    final url = Uri.parse(AppConstats.baseUrl + AppConstats.otpVerified);
    print(url);
    try {
      final response = await http.post(
        url,

        body: {"country_code": countryCode, "phone": phone},
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final data = jsonDecode(response.body);

        return TokenModel.fromJson(data);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: $e");
    }
  }
}
