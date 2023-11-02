import 'package:flutter/material.dart';
import 'package:track_budget/googleSheetsApi.dart';

class TransactionList extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  const TransactionList(
      {required this.transactionName,
      required this.money,
      required this.expenseOrIncome});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 5),
      Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.yellowAccent,
            height: 50,
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.wallet),
                  Text(
                    transactionName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    expenseOrIncome == 'expense' ? '- ' : '+ ',
                    style: expenseOrIncome == 'expense'
                        ? const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                        : const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                  ),
                  Text(
                    money,
                    style: expenseOrIncome == 'expense'
                        ? const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                        : const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
