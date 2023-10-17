import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Complex {
  final int valueOne;
  final int valueTwo;
  Complex({
    required this.valueOne,
    required this.valueTwo,
  });

  Complex copyWith({
    int? valueOne,
    int? valueTwo,
  }) {
    return Complex(
      valueOne: valueOne ?? this.valueOne,
      valueTwo: valueTwo ?? this.valueTwo,
    );
  }

  @override
  String toString() => 'Complex(valueOne: $valueOne, valueTwo: $valueTwo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Complex &&
        other.valueOne == valueOne &&
        other.valueTwo == valueTwo;
  }

  @override
  int get hashCode => valueOne.hashCode ^ valueTwo.hashCode;
}

class Model {
  final int one;
  final int two;
  final Complex complex;
  Model({
    required this.one,
    required this.two,
    required this.complex,
  });

  Model copyWith({
    int? one,
    int? two,
    Complex? complex,
  }) {
    return Model(
      one: one ?? this.one,
      two: two ?? this.two,
      complex: complex ?? this.complex,
    );
  }

  @override
  String toString() => 'Model(one: $one, two: $two, complex: $complex)';

  @override
  bool operator ==(covariant Model other) {
    if (identical(this, other)) return true;

    return other.one == one && other.two == two && other.complex == complex;
  }

  @override
  int get hashCode => one.hashCode ^ two.hashCode ^ complex.hashCode;
}

class ExampleWidget3 extends StatefulWidget {
  const ExampleWidget3({super.key});

  @override
  State<ExampleWidget3> createState() => _ExampleWidget3State();
}

class _ExampleWidget3State extends State<ExampleWidget3> {
  var model = Model(one: 0, two: 0, complex: Complex(valueOne: 0, valueTwo: 0));
  void inc1() {
    model = model.copyWith(one: model.one + 1);
    setState(() {});
  }

  void inc2() {
    model = model.copyWith(two: model.two + 1);
    setState(() {});
  }

  void incComplex1() {
    final complex = model.complex.copyWith(
      valueOne: model.complex.valueOne + 1,
    );
    model = model.copyWith(complex: complex);
    setState(() {});
  }

  void incComplex2() {
    final complex = model.complex.copyWith(
      valueTwo: model.complex.valueTwo + 1,
    );
    model = model.copyWith(complex: complex);
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

    final state = context.read<_ExampleWidget3State>();
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
              onPressed: state.incComplex1,
              child: const Text('complex1'),
            ),
            ElevatedButton(
              onPressed: state.incComplex2,
              child: const Text('complex2'),
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
    final value = context.select((Model value) => value.complex.valueOne);
    return Text("$value");
  }
}

class _FourWidget extends StatelessWidget {
  const _FourWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context.select((Model value) => value.complex.valueTwo);
    return Text("$value");
  }
}
