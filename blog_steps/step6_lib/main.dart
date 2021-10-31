import 'package:flutter/material.dart';
import 'model.dart';
import 'appwrite_client.dart';

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

  String _username = "";
  String _password = "";

  // controllers
  TextEditingController _expenseController = new TextEditingController();
  TextEditingController _incomeController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  // appwrite instance
  AppWriteClient _appwrite = AppWriteClient();

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

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _updateAmount(String type) {
      if (type == 'expense') {
        setState(() {
          _amount = _amount - _expenseAmount;
        });
        _transactions.add(TransactionRow(
            DateTime.now().toString(), 'Expense', _expenseAmount));
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

    void _loginUser() {
      print('Login User called');
      _appwrite.login(_username, _password);
      //Navigator.of(context).pop();
    }

    void _signupUser() {
      print('Signup User called with ' +
          _username.toString() +
          _password.toString());
      _appwrite.signup(_username, _password);
      _appwrite.createBalance(_username);
      _appwrite.createTransaction(_username);
      //Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.only(right: 50.0),
              icon: Icon(Icons.login),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                      padding: EdgeInsets.only(right: 30.0, left: 30.0),
                      child: Column(children: [
                        TextField(
                          decoration: InputDecoration(hintText: "User Email"),
                          keyboardType: TextInputType.text,
                          controller: _usernameController,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Password"),
                          keyboardType: TextInputType.text,
                          controller: _passwordController,
                        ),
                        Divider(),
                        Container(
                            margin: EdgeInsets.only(right: 30.0, left: 30.0),
                            child: Row(children: [
                              ElevatedButton(
                                  onPressed: _loginUser, child: Text("Login")),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: _signupUser,
                                  child: Text("Sign up"))
                            ]))
                      ]))))
        ],
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
                  onPressed: () => {_updateAmount('expense')},
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
                  onPressed: () => {_updateAmount('income')},
                  child: Text("Add Income"))
            ]),
            Divider(),
            // transaction row
            Center(child: Text("Transactions")),
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

