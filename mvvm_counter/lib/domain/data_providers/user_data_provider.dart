import 'package:mvvm_counter/domain/entity/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {
  final sharedPreferences = SharedPreferences.getInstance();

  Future<void> saveValue(User user) async {
    (await sharedPreferences).setInt('age', user.age);
  }

  Future<User> loadValue() async {
    final age = (await sharedPreferences).getInt('age') ?? 0;
    return User(age: age);
  }
}
