import 'package:dartz/dartz.dart';
import 'package:machine_test_round_2_noviindus/core/errors/failure.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Token>> verifyOtp(
      String countryCode, String phone);
  Future<Either<Failure, void>> cacheToken(Token token);
  Future<Either<Failure, Token?>> getCachedToken();
}
