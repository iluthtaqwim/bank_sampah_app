import 'dart:convert';

import 'package:bank_sampah/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              colors: [
                Colors.white70,
                Colors.white54,
                Colors.white30,
                Colors.white24,
              ],
              durations: [22000, 15000, 10000, 5000],
              heightPercentages: [0.45, 0.46, 0.48, 0.41],
              blur: MaskFilter.blur(BlurStyle.solid, 5.0),
            ),
            size: Size(
              double.infinity,
              double.infinity,
            ),
            backgroundColor: Colors.pinkAccent,
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Hiragino Kaku Gothic ProN',
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              textSection(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  textColor: Colors.black,
                  color: Colors.pinkAccent,
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    signIn(usernameController.text, passwordController.text);
                  },
                  child: Center(
                    child: Text('Sign In'),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  signIn(String username, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'nama_nasabah': username, 'password': pass};
    var jsonResponse;
    var response = await http.post("YOUR_BASE_URL", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
}

TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

Container textSection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
    child: Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          elevation: 10.0,
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: usernameController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle, color: Colors.black),
                hintText: "Username",
                // border: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.black12),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          elevation: 10.0,
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: passwordController,
              cursorColor: Colors.white,
              obscureText: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.black),
                hintText: "Password",
                // border: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(color: Colors.black12),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
