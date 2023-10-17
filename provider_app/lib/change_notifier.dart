import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Model extends ChangeNotifier {
  var one = 0;
  var two = 0;

  void inc1() {
    one += 1;
    notifyListeners();
  }

  void inc2() {
    two += 1;
    notifyListeners();
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final model = Model();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      //provider внутри себя созраняет замыкание. поэтому при hotReload данные сохраняются,
      //хоть виджет и перестраивается
      create: (context) => model,
      lazy: true,
      child: const _View());
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //получить модель, но не подписаться
    final model = context.read<Model>();
//получить конкретное значение модели + подписаться только на значения этого параметра
    //Работает только с провайдером
    // context.select((Model value) => value.one);

    // Provider.of<Model>(context, listen: true); ~ context.watch<Model>().one
    // Provider.of<Model>(context, listen: false); ~ context.read<Model>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: model.inc1,
              child: const Text('one'),
            ),
            ElevatedButton(
              onPressed: model.inc2,
              child: const Text('two'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('complex'),
            ),
            const _OneWidget(),
            const _TwoWidget(),
            const _ThreeWidget(),
            const _FourWidget(),
          ],
        ),
      ),
    );
  }
}

class _OneWidget extends StatelessWidget {
  const _OneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //получить модель + подписаться на изменения
    final value = context.watch<Model>().one;
    return Text("$value");
  }
}

class _TwoWidget extends StatelessWidget {
  const _TwoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.watch<Model>().two;
    return Text("$value");
  }
}

class _ThreeWidget extends StatelessWidget {
  const _ThreeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const value = 0;
    return const Text("$value");
  }
}

class _FourWidget extends StatelessWidget {
  const _FourWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const value = 0;
    return const Text("$value");
  }
}
