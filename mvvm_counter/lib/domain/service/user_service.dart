import 'dart:math';

import 'package:mvvm_counter/domain/data_providers/user_data_provider.dart';
import 'package:mvvm_counter/domain/entity/user.dart';

class UserService {
  final _userDataProvider = UserDataProvider();
  var _user = User(age: 0);
  User get user => _user;

  void incrementValue() {
    _user = user.copyWith(age: user.age + 1);
    _userDataProvider.saveValue(_user);
  }

  void decrementValue() {
    _user = user.copyWith(age: max(user.age - 1, 0));
    _userDataProvider.saveValue(_user);
  }

  Future<void> initialize() async {
    _user = await _userDataProvider.loadValue();
  }
}
