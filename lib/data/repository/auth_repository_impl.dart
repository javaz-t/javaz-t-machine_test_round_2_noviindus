import 'package:dartz/dartz.dart';
import 'package:machine_test_round_2_noviindus/core/errors/failure.dart';
import 'package:machine_test_round_2_noviindus/data/model/token_model.dart';
import 'package:machine_test_round_2_noviindus/data/services/token_local_data_source.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/repository/auth_repository.dart';

import '../../core/connection/network_info.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.service,
    required this.localDataSource,
    required this.networkInfo,
  });
  Future<Either<Failure, Token>> verifyOtp(
    String countryCode,
    String phone,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected!) {
      return Left(ServerFailure(errorMessage: "No internet connection"));
    }
    try {
      final token = await service.verifyOtp(countryCode, phone);

      if (token.access.isNotEmpty) {
        //print('Access token: ${token.access}');
        return Right(token);
      } else {
        return Left(ServerFailure(errorMessage: "Invalid token received"));
      }
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheToken(Token token) async {
    try {
      await localDataSource.cacheToken(
        TokenModel(access: token.access, refresh: token.refresh),
      );
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Token?>> getCachedToken() async {
    try {
      final tokenModel = await localDataSource.getCachedToken();
      if (tokenModel != null) {
        return Right(tokenModel);
      } else {
        return Right(null);
      }
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
