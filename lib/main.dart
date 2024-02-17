import 'package:flutter/material.dart';
import 'login.dart';
//import 'assistant.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(   
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0x192734),
      ),
      home: LoginPage(),
    );
  }
}