import 'dart:convert';

import 'package:bank_sampah/landing.dart';
import 'package:bank_sampah/model/Session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _failed = false;
  String BASE_URL =
      "https://karangtarunapelangi.000webhostapp.com/api/authentication/login";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
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
                    child: Image(
                      width: 200,
                      image: AssetImage("assets/images/BS-white.png"),
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
                    onPressed: usernameController.text == "" ||
                            passwordController.text == ""
                        ? null
                        : () {
                            setState(() {
                              _isLoading = true;
                            });

                            signIn(usernameController.text,
                                passwordController.text);
                          },
                    child: Center(
                      child: Text('Sign In'),
                    ),
                  ),
                )
              ],
            ),
            if (_isLoading == true)
              Stack(
                children: [
                  Center(
                    child: Loading(),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> login(String username, pass) async {
    Map body = {'username': username, 'password': pass};
    var headers = {
      'x-api-key': 'CODEX@123',
      'Authorization': 'Basic aWx1dGg6aWx1dGg='
    };
    return http.post(BASE_URL, headers: headers, body: body);
  }

  signIn(String username, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await login(username, pass);
    var body;
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      body = json.decode(response.body);
      if (body != null) {
        // sharedPreferences.setString("token", body['data']['token']);
        Session.setLoginData(body["data"]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Landing()),
            (Route<dynamic> route) => false);
      } else {
        print('no data was found');
      }

      return print(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:
            usernameController.text == "" || passwordController.text == ""
                ? null
                : () {
                    setState(() {
                      _isLoading = false;
                    });
                    // signIn(usernameController.text, passwordController.text);
                  },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Sign In", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget Loading() {
    return CircularProgressIndicator();
  }

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
                cursorColor: Colors.black,
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
                cursorColor: Colors.black,
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
}
