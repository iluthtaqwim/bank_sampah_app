import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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

              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension WidgetModifier on Widget {
  Widget bgWaves() {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          Colors.white70,
          Colors.white54,
          Colors.white30,
          Colors.white24,
        ],
        durations: [22000, 15000, 10000, 5000],
        heightPercentages: [0.15, 0.16, 0.18, 0.11],
        blur: MaskFilter.blur(BlurStyle.solid, 5.0),
      ),
      size: Size(
        double.infinity,
        double.infinity,
      ),
      backgroundColor: Colors.pinkAccent,
    );
  }

  Widget title() {
    return Text("HAlooo");
  }
}

Container textSection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
    child: Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          elevation: 10.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: TextFormField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.black),
                hintText: "Email",
                // border: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.black12),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: TextFormField(
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
