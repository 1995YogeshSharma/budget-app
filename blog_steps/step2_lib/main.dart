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
          child: ListView(padding: EdgeInsets.all(16.0), children: [
            Center(child: Text("Current Amount")),
            Divider(),
            Center(child: Text("Add Expense Row")),
            Center(child: Text("Add Income Row")),
            Divider(),
            Center(child: Text("Transaction Row"))
          ]),
        ),
      ),
    );
  }
}

