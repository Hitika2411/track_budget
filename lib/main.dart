import 'package:track_budget/googleSheetsApi.dart';
import 'package:track_budget/screens/biometric.dart';
import 'package:track_budget/screens/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await googleSheetsApi().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BiometricLogin());
  }
}
