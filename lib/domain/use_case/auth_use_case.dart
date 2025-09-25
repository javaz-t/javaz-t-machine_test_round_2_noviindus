import 'package:dartz/dartz.dart';
import 'package:machine_test_round_2_noviindus/core/errors/failure.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/repository/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, Token>> call(
      String countryCode, String phone) async {
    return await repository.verifyOtp(countryCode, phone);
  }
  // Cache token locally
  Future<Either<Failure, void>> cacheToken(Token token) async {
    return await repository.cacheToken(token);
  }

  // Get token from cache
  Future<Either<Failure, Token?>> getCachedToken() async {
    return await repository.getCachedToken();
  }
}
