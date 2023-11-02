import 'package:flutter/material.dart';

class Daily extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;
  Daily({required this.balance, required this.income, required this.expense});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(children: [
        AppBar(
          title: const Text(
            'Home Page',
          ),
          backgroundColor: Colors.blueAccent,
        ),
        Card(
          shadowColor: Colors.orangeAccent,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 170,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 60,
                  ),
                  Text(
                    ' ${DateTime.now().toString().split(' ')[0]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
          shadowColor: Colors.blueAccent,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 100,
            child: Center(
              child: Row(children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                ),
                Text(
                  'Balance Rs.: $balance',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),
        ),
        Card(
          shadowColor: Colors.greenAccent,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 100,
            child: Center(
                child: Row(
              children: [
                const Icon(
                  Icons.arrow_upward_sharp,
                  size: 60,
                ),
                Text(
                  'Income Rs.:$income ',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
        Card(
          shadowColor: Colors.redAccent,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 100,
            child: Center(
                child: Row(
              children: [
                const Icon(
                  Icons.arrow_downward_sharp,
                  size: 60,
                ),
                Text(
                  'Expenditure Rs.:$expense ',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
      ]),
    );
  }
}
