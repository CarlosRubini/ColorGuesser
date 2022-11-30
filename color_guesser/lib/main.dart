import 'package:color_guesser/color_guesser_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Guesser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ColorGuesserHome()
    );
  }
}