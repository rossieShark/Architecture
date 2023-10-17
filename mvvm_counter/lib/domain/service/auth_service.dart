import 'package:mvvm_counter/domain/data_providers/auth_api_data_provider.dart';
import 'package:mvvm_counter/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiProvider = AuthApiProvider();

  Future<bool> checkAuth() async {
    final apiKey = await _sessionDataProvider.apiKey();
    return apiKey != null;
  }

  Future<void> login(String login, String password) async {
    final apiKey = await _authApiProvider.login(login, password);
    await _sessionDataProvider.saveApiKey(apiKey);
  }

  Future<void> logOut() async {
    await _sessionDataProvider.clearApiKey();
  }
}
