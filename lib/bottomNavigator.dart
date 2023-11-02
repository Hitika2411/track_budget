import 'dart:async';
import 'package:track_budget/screens/addtransactions.dart';
import 'package:track_budget/screens/daily.dart';
import 'package:track_budget/screens/profile.dart';
import 'package:track_budget/screens/transactionsList.dart';
import 'package:flutter/material.dart';
import 'package:track_budget/googleSheetsApi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await googleSheetsApi().init();
  runApp(const BottomNavigationBarExampleApp());
}

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  bool timeHasStarted = false;

  @override
  void initState() {
    super.initState();
    if (googleSheetsApi.loading == true && timeHasStarted == false) {
      startLoading();
    }
  }

  void startLoading() {
    timeHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (googleSheetsApi.loading == false) {
        timer.cancel();
        setState(() {});
      }
    });
  }

  final _textcontrollerAmount = TextEditingController();
  final _textcontrollerName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _enterTransaction() {
    googleSheetsApi.insert(
      _textcontrollerName.text,
      _textcontrollerAmount.text,
      _isIncome,
    );
    setState(() {});
  }

  void newTransaction() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('N E W  T R A N S A C T I O N'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Expense'),
                        Switch(
                          value: _isIncome,
                          onChanged: (newValue) {
                            setState(() {
                              _isIncome = newValue;
                            });
                          },
                        ),
                        Text('Income'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Amount?',
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter an amount';
                                }
                                return null;
                              },
                              controller: _textcontrollerAmount,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'For what?',
                            ),
                            controller: _textcontrollerName,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.grey[600],
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  color: Colors.grey[600],
                  child: Text('Enter', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _enterTransaction();
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            Daily(
              balance: (googleSheetsApi.calculateIncome() -
                      googleSheetsApi.calculateExpense())
                  .toString(),
              income: googleSheetsApi.calculateIncome().toString(),
              expense: googleSheetsApi.calculateExpense().toString(),
            ),
            AddTransaction(
              function: newTransaction,
            ),
            if (googleSheetsApi.loading == false)
              ListView.builder(
                itemCount: googleSheetsApi.currentTransactions.length,
                itemBuilder: (context, numberOfTransactions) {
                  return TransactionList(
                    transactionName: googleSheetsApi
                        .currentTransactions[numberOfTransactions][0],
                    money: googleSheetsApi
                        .currentTransactions[numberOfTransactions][1],
                    expenseOrIncome: googleSheetsApi
                        .currentTransactions[numberOfTransactions][2],
                  );
                },
              ),
            const Profile(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card_sharp),
            label: 'Add Transaction',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_sharp),
            label: 'Transactions',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_sharp),
            label: 'Profile',
            backgroundColor: Colors.blueGrey,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
