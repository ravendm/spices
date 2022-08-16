import 'package:flutter/material.dart';
import 'package:spice_widgets/spice_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpiceColumn(
        gap: 10,
        children: [
          Container(height: 10, color: Colors.red),
          Container(height: 10, color: Colors.black),
          Container(height: 10, color: Colors.yellow),
          Container(height: 10, color: Colors.blue),
          Container(height: 10, color: Colors.green),
        ],
      ),
    );
  }
}
