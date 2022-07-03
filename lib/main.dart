import 'package:autocomplete/homepage.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Auto Complete',
      theme: ThemeData(
        primaryColor: const Color(0xff112435),
      ),
      home: const HomePage(),
    );
  }
}
