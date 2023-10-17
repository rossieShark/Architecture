abstract class AuthApiProviderError {}

class AuthApiProviderIncorectLoginDataError {}

class AuthApiProvider {
  Future<String> login(String login, String password) async {
    await Future.delayed(Duration(seconds: 2));
    final isSuccess = login == 'admin' && password == '123456';
    if (isSuccess) {
      return 'sdfafeferfsdqwe';
    } else {
      throw AuthApiProviderIncorectLoginDataError();
    }
  }

  Future<void> logout() async {}
}
