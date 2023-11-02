import 'package:flutter/material.dart';
import 'package:track_budget/googleSheetsApi.dart';

class AddTransaction extends StatelessWidget {
  final function;
  const AddTransaction({this.function});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        shadowColor: Colors.purpleAccent,
        elevation: 10,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          height: 200,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text('Add your transactions here',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: function,
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
