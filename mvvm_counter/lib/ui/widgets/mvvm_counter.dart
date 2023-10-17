import 'package:flutter/material.dart';
import 'package:mvvm_counter/domain/service/user_service.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String ageTitle;
  _ViewModelState({required this.ageTitle});
}

class _ViewModel extends ChangeNotifier {
  final _userService = UserService();

  var _state = _ViewModelState(ageTitle: '');
  _ViewModelState get state => _state;

  _ViewModel() {
    loadValue();
  }
  void loadValue() async {
    await _userService.initialize();
    _updateState;
  }

  Future<void> onIncrementButtonPressed() async {
    _userService.incrementValue();
    _updateState();
  }

  Future<void> onDecrementButtonPressed() async {
    _userService.decrementValue();
    _updateState();
  }

  void _updateState() {
    final user = _userService.user;
    _state = _ViewModelState(
      ageTitle: user.age.toString(),
    );
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  static Widget create() {
    return ChangeNotifierProvider(
        create: (_) => _ViewModel(), child: const MyHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_AgeTitle(), _AgeIncrementWidget(), _AgeDecrementWidget()],
        ),
      )),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle();

  @override
  Widget build(BuildContext context) {
    final ageTitle = context.select((_ViewModel model) => model.state.ageTitle);

    return Text(ageTitle);
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return ElevatedButton(
      onPressed: viewModel.onIncrementButtonPressed,
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return ElevatedButton(
      onPressed: viewModel.onDecrementButtonPressed,
      child: const Text('-'),
    );
  }
}
