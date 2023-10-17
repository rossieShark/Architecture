import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Model {
  final int one;
  final int two;

  Model({required this.one, required this.two});
//
  Model copyWith({int? one, int? two}) {
    return Model(
      one: one ?? this.one,
      two: two ?? this.two,
    );
  }

  @override
  String toString() => 'Model(one: $one, two: $two)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model && other.one == one && other.two == two;
  }

  @override
  int get hashCode => one.hashCode ^ two.hashCode;
}

// void inc1() {
//   one += 1;
// }

// void inc2() {
//   two += 1;
// }

class ExampleWidget2 extends StatefulWidget {
  const ExampleWidget2({super.key});

  @override
  State<ExampleWidget2> createState() => _ExampleWidget2State();
}

class _ExampleWidget2State extends State<ExampleWidget2> {
  var model = Model(one: 0, two: 0);
  void inc1() {
    model = model.copyWith(one: model.one + 1);
    setState(() {});
  }

  void inc2() {
    model = model.copyWith(two: model.two + 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Provider.value(
        value: this,
        child: Provider.value(
            //provider внутри себя созраняет замыкание. поэтому при hotReload данные сохраняются,
            //хоть виджет и перестраивается
            value: model,
            child: const _View()),
      );
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //получить модель, но не подписаться
    // final model = context.read<Model>();
//получить конкретное значение модели + подписаться только на значения этого параметра
    //Работает только с провайдером
    // context.select((Model value) => value.one);

    // Provider.of<Model>(context, listen: true); ~ context.watch<Model>().one
    // Provider.of<Model>(context, listen: false); ~ context.read<Model>();

    final state = context.read<_ExampleWidget2State>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: state.inc1,
              child: const Text('one'),
            ),
            ElevatedButton(
              onPressed: state.inc2,
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
    final value = context.select((Model value) => value.one);
    return Text("$value");
  }
}

class _TwoWidget extends StatelessWidget {
  const _TwoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.select((Model value) => value.two);
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
