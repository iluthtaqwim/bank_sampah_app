import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bank_sampah/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navLoginPage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: Image(
          width: 300,
          image: AssetImage(
            "assets/images/BS-black.png",
          ),
        ),
      ),
    );
  }

  Future<void> navLoginPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    if (status) {
      Navigator.pushNamed(context, "/Home");
    } else {
      Navigator.pushNamed(context, "/Login");
    }
  }
}
