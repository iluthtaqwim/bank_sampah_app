import 'package:flutter/material.dart';
import 'package:bank_sampah/home.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new Berita(null));

class Berita extends StatelessWidget {
  static String tag = 'description-page';
  Berita(this.urlnews);
  final String urlnews;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pinkAccent,
        title: new Text(
          "Headline News",
          style: new TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebviewScaffold(
          withZoom: true,
          withLocalStorage: true,
          url: urlnews,
        ),
      ),
    );
  }
}
