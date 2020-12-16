import 'package:bank_sampah/home.dart';
import 'package:bank_sampah/landing.dart';
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
        '/Landing': (context) => Landing()
      },
      title: "Code Land",
      debugShowCheckedModeBanner: false,
      home: Container(
        child: SplashScreen(),
      ),
      theme: ThemeData(
          accentColor: Colors.white70,
          brightness: Brightness.light,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            headline6: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),
    );
  }
}
