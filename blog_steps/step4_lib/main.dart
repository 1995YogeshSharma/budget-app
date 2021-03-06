import 'package:flutter/material.dart';
import 'model.dart';

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
  // state variables
  int _amount = 0;
  int _expenseAmount = 0;
  int _incomeAmount = 0;
  List<TransactionRow> _transactions = [];

  // controllers
  TextEditingController _expenseController = new TextEditingController();
  TextEditingController _incomeController = new TextEditingController();

  void updateAmount(String type) {
    if (type == 'expense') {
      setState(() {
        _amount = _amount - _expenseAmount;
      });
      _transactions.add(
          TransactionRow(DateTime.now().toString(), 'Expense', _expenseAmount));
      _expenseController.text = '';
    } else if (type == 'income') {
      setState(() {
        _amount = _amount + _incomeAmount;
      });
      _transactions.add(
          TransactionRow(DateTime.now().toString(), 'Income', _incomeAmount));
      _incomeController.text = '';
    }
  }

  @override
  void initState() {
    super.initState();

    // adding listeners
    _expenseController.addListener(() {
      setState(() {
        _expenseAmount = int.parse(_expenseController.text);
      });
    });

    _incomeController.addListener(() {
      setState(() {
        _incomeAmount = int.parse(_incomeController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Container(
        child: Center(
          child: ListView(padding: EdgeInsets.all(16.0), children: [
            // current amount row
            Center(child: Text("Current Amount - " + _amount.toString())),
            Divider(),
            // expense row
            Row(children: <Widget>[
              Flexible(
                  child: TextField(
                      decoration: InputDecoration(hintText: "Amount"),
                      keyboardType: TextInputType.number,
                      controller: _expenseController)),
              ElevatedButton(
                  onPressed: () => {updateAmount('expense')},
                  child: Text("Add Expense"))
            ]),
            // income row
            Row(children: <Widget>[
              Flexible(
                  child: TextField(
                      decoration: InputDecoration(hintText: "Amount"),
                      keyboardType: TextInputType.number,
                      controller: _incomeController)),
              ElevatedButton(
                  onPressed: () => {updateAmount('income')},
                  child: Text("Add Income"))
            ]),
            Divider(),
            // transaction row
            Column(
                children: _transactions.map((TransactionRow transaction) {
              return transaction;
            }).toList())
          ]),
        ),
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  Transaction? transaction;

  TransactionRow(String date, String type, int amount) {
    this.transaction = new Transaction(date: date, type: type, amount: amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: <Widget>[
        Expanded(child: Text(transaction!.date)),
        Expanded(child: Text(transaction!.type)),
        Expanded(child: Text(transaction!.amount.toString())),
      ]),
      Divider(),
    ]);
  }
}

