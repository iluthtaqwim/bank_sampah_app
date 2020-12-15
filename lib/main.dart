import 'package:bank_sampah/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bank_sampah/login_page.dart';
import 'package:bank_sampah/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Login': (context) => LoginPage(),
        '/Home': (context) => Home(),
      },
      title: "Code Land",
      debugShowCheckedModeBanner: false,
      home: Container(
        child: SplashScreen(),
      ),
      theme: ThemeData(accentColor: Colors.white70),
    );
  }
}
