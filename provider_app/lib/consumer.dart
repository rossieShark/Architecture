import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Complex {
  var valueOne = 0;
  var valueTwo = 0;
}

class Model extends ChangeNotifier {
  var one = 0;
  var two = 0;
  final complex = Complex();
  void inc1() {
    one += 1;
    notifyListeners();
  }

  void inc2() {
    two += 1;
    notifyListeners();
  }

  void incComplex1() {
    complex.valueOne += 1;
    notifyListeners();
  }

  void incComplex2() {
    complex.valueTwo += 1;
    notifyListeners();
  }
}

class Model2 extends ChangeNotifier {
  var one = 0;

  void inc1() {
    one += 1;
    notifyListeners();
  }
}

class Wrapper {
  final Model model;
  final Model2 model2;

  Wrapper(this.model, this.model2);
}

class ExampleWidget8 extends StatelessWidget {
  const ExampleWidget8({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Model(),
          ),
          ChangeNotifierProvider(
            create: (_) => Model2(),
          ),
          //ProxyProvide берет несколько провайдеров (до 6) и на основе их сделать новое значение
          //
          ProxyProvider2(
              update: (BuildContext context, Model model, Model2 model2, prev) {
            return Wrapper(model, model2);
          })
        ],
        child: const _View(),
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

    final state = context.read<Model>();
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
            //аналог builder
            Consumer<Model>(builder: (context, model, _) {
              return Text('${model.one}');
            })
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
    final value = context.watch<Wrapper>().model2.one;
    return Text("$value");
  }
}
