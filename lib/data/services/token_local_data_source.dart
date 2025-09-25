import 'package:shared_preferences/shared_preferences.dart';
import '../model/token_model.dart';

class TokenLocalDataSource {
  static const String accessKey = "ACCESS_TOKEN";
  static const String refreshKey = "REFRESH_TOKEN";

  Future<void> cacheToken(TokenModel token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessKey, token.access);
    await prefs.setString(refreshKey, token.refresh);
  }

  Future<TokenModel?> getCachedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString(accessKey);
    final refresh = prefs.getString(refreshKey);

    if (access != null && refresh != null) {
      return TokenModel(access: access, refresh: refresh);
    } else {
      return null;
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessKey);
    await prefs.remove(refreshKey);
  }
}
