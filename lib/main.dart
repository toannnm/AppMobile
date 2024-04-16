import 'package:capstones/category_screen.dart';
import 'package:capstones/home_screen.dart';
import 'package:capstones/login_screen.dart';
import 'package:capstones/session_screen.dart';
import 'package:capstones/welcome_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstones/welcome_screen/welcome_screen.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => Welcome(), // Set the initial route handler
        '/login': (context) => Login(),
        '/regis':(context) => Register(),
        '/category':(context) => Category(),
        '/session':(context) => SessionScreen(),
        '/home_screen': (context) => Homepage(
  firstName: '',
  lastName: '',
  token: '',
),


      },
    );
  }
}
