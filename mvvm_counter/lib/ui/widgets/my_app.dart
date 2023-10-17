import 'package:flutter/material.dart';
import 'package:mvvm_counter/ui/widgets/auth_widget.dart';
import 'package:mvvm_counter/ui/widgets/mvvm_counter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWidget.create(),
    );
  }
}
