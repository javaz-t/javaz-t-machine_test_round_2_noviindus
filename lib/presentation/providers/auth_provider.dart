import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/errors/failure.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/auth_use_case.dart';

class AuthProvider with ChangeNotifier {
  final VerifyOtpUseCase verifyOtpUseCase;
   AuthProvider(this.verifyOtpUseCase);

  bool isLoading = false;
  Token? token;
  Failure? failure;

  Future<void> verifyOtp(String countryCode, String phone) async {
    isLoading = true;
    notifyListeners();

    final result = await verifyOtpUseCase(countryCode, phone);

    result.fold(
      (fail) {
        failure = fail;
        token = null;
      },
      (tok) async {
        token = tok;
        failure = null;
        await verifyOtpUseCase.cacheToken(tok);
      },
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadCachedToken() async {
    // Optional: load token on app startup
    final result = await verifyOtpUseCase.getCachedToken();
    result.fold(
      (fail) {
        token = null;
      },
      (tok) {
        token = tok;
      },
    );
    notifyListeners();
  }
}
