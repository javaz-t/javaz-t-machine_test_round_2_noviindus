import 'package:machine_test_round_2_noviindus/domain/entity/token_entity.dart';

class TokenModel extends Token {
  const TokenModel({
    required super.access,
    required super.refresh,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    final tokenData = json["token"] ?? {}; // extract the nested token map

    return TokenModel(
      access: tokenData["access"] ?? "",
      refresh: tokenData["refresh"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access": access,
      "refresh": refresh,
    };
  }

  // Convert model to entity (optional, useful for repository return)
  Token toEntity() {
    return Token(access: access, refresh: refresh);
  }
}
