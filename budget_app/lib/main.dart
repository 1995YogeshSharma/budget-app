import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

void main() {
  // runApp(BudgetApp());
  runApp(new MaterialApp(
    home: new BudgetApp(),
  ));
}

class BudgetApp extends StatefulWidget {
  @override
  _state createState() => new _state();
}

class TransactionRow extends StatelessWidget {
  String date = "";
  String type = "";
  String amount = "";

  TransactionRow(String date, String type, String amount) {
    this.date = date;
    this.type = type;
    this.amount = amount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: Text(date)),
      Expanded(child: Text(type)),
      Expanded(child: Text(amount)),
    ]);
  }
}

class _state extends State<BudgetApp> {
  int _amount = 0;
  int _expenseAmount = 0;
  int _incomeAmount = 0;
  List<TransactionRow> _transactions = [];

  TextEditingController _expenseController = new TextEditingController();
  TextEditingController _incomeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _expenseController.addListener(() {
      setState(() {
        this._expenseAmount = int.parse(_expenseController.text);
      });
    });
    _incomeController.addListener(() {
      setState(() {
        this._incomeAmount = int.parse(_incomeController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _addExpenseClick() {
      _amount = _amount - _expenseAmount;
      _transactions.add(TransactionRow(
          DateTime.now().toString(), "Expense", _expenseAmount.toString()));
      setState(() {
        _expenseController.text = "";
      });
    }

    void _addIncomeClick() {
      _amount = _amount + _incomeAmount;
      _transactions.add(TransactionRow(
          DateTime.now().toString(), "Income", _incomeAmount.toString()));
      setState(() {
        _incomeController.text = "";
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Budget App"),
          actions: [
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                      padding: EdgeInsets.only(right: 30.0, left: 30.0),
                      child: Column(children: [
                        TextField(
                          decoration: InputDecoration(hintText: "User Name"),
                          keyboardType: TextInputType.text,
                          controller: null,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Password"),
                          keyboardType: TextInputType.text,
                          controller: null,
                        ),
                        ElevatedButton(
                            onPressed: () => {}, child: Text("Login"))
                      ]))),
              padding: EdgeInsets.only(right: 50.0),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(32.0),
          child: Center(
              child: Column(
            children: <Widget>[
              Text("Current Balance: " + _amount.toString()),
              Row(children: <Widget>[
                Flexible(
                    child: TextField(
                        decoration: InputDecoration(hintText: "Amount"),
                        keyboardType: TextInputType.number,
                        controller: _expenseController)),
                ElevatedButton(
                    onPressed: _addExpenseClick, child: Text("Add Expense"))
              ]),
              Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    decoration: InputDecoration(hintText: "Amount"),
                    keyboardType: TextInputType.number,
                    controller: _incomeController,
                  )),
                  ElevatedButton(
                      onPressed: _addIncomeClick, child: Text("Add Income")),
                ],
              ),
              Text("Transactions"),
              Column(
                  children: _transactions.map((TransactionRow transaction) {
                return transaction;
              }).toList())
            ],
          )),
        ));
  }
}
