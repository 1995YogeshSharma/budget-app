import 'package:flutter/material.dart';

void main() {
  // runApp(BudgetApp());
  runApp(new MaterialApp(
    home: new BudgetApp(),
  ));
}

class BudgetApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<BudgetApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Container(
        child: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
