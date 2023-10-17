import 'package:shared_preferences/shared_preferences.dart';

class SessionDataProviderKeys {
  static const _apiKey = 'api_key';
}

class SessionDataProvider {
  //в реальной работе вместо sharedPreferences должен стоять sequirityStorage
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<void> saveApiKey(String key) async {
    (await _sharedPreferences).setString(SessionDataProviderKeys._apiKey, key);
  }

  Future<void> clearApiKey() async {
    (await _sharedPreferences).remove(SessionDataProviderKeys._apiKey);
  }

  Future<String?> apiKey() async {
    return (await _sharedPreferences)
        .getString(SessionDataProviderKeys._apiKey);
  }
}
