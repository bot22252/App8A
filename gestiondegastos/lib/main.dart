import 'package:flutter/material.dart';
import 'PaginaPrincipal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Gastos Flutter',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: PaginaPrincipal(),
    );
  }
}
