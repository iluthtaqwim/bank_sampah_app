import 'package:bank_sampah/home.dart';
import 'package:flutter/material.dart';
import 'package:bank_sampah/profile.dart';
import 'package:bank_sampah/transaksi.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), QrCode(), Transaksi(), Profile()];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_rounded),
            title: Text("QR Code"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            title: Text("Transaksi"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            title: Text("Profil"),
          )
        ],
      ),
    );
  }
}
