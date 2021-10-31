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

  String _balanceDocId = "";
  String _transDocId = "";

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
    Future<void> _updateAmount(String type) async {
      int _newAmount = 0;
      TransactionRow? _newTransaction = null;

      if (type == 'income') {
        _newAmount = _amount + _incomeAmount;
        _newTransaction =
            TransactionRow(DateTime.now().toString(), 'Income', _incomeAmount);
      } else if (type == 'expense') {
        _newAmount = _amount - _expenseAmount;
        _newTransaction = TransactionRow(
            DateTime.now().toString(), 'Expense', _expenseAmount);
      }

      setState(() {
        _amount = _newAmount;
        _transactions.add(_newTransaction!);
      });
      await _appwrite.updateBalance(_balanceDocId, _amount, _username);
      await _appwrite.updateTransaction(_transDocId,
          _transactions.map((e) => e.transaction!).toList(), _username);
    }

    Future<void> _updateInfoFromDB(String _username) async {
      // get balance doc id
      _balanceDocId = (await _appwrite.getBalanceDocId(_username))!;

      // get transaction doc id
      _transDocId = (await _appwrite.getTransactionDocId(_username))!;

      // get balance
      _amount = (await _appwrite.getBalance(_balanceDocId))!;

      // get transactions
      List<Transaction> _trans = (await _appwrite.getTransaction(_transDocId))!;
      _transactions =
          _trans.map((e) => TransactionRow(e.date, e.type, e.amount)).toList();
    }

    Future<void> _loginUser() async {
      print('Login User called with $_username and $_password');
      await _appwrite.login(_username, _password);
      await _updateInfoFromDB(_username);
      print('Login done!');
    }

    Future<void> _signupUser() async {
      print('Signup User called with $_username and $_password');
      await _appwrite.signup(_username, _password);
      await _appwrite.createBalance(_username);
      await _appwrite.createTransaction(_username);
      print('Signup done!');
    }

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'imgs/built-with-appwrite.png',
          scale: 2.0,
        ),
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
                                  onPressed: () => {_loginUser()},
                                  child: Text("Login")),
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
