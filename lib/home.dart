import 'dart:convert';

import 'package:bank_sampah/model/articles.dart';
import 'package:bank_sampah/model/source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  Future<List<Articles>> articleFutures;

  Future<List<Articles>> fetchArticles() async {
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=id&apiKey=996cf4ccbdda4924bdf762802f3ca472');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return List<Articles>.from(
          body["articles"].map((it) => Articles.fromJsonMap(it)));
    } else {
      throw Exception('failed to load articles');
    }
  }

  @override
  void initState() {
    super.initState();
    articleFutures = fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.pinkAccent,
      onRefresh: fetchArticles,
      child: Material(
        child: Stack(
          children: [
            Image(
              image: AssetImage("assets/images/Wave-100s-1036px.png"),
            ),
            ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        width: 150,
                        image: AssetImage("assets/images/BS-white.png"),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tabungan",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Rp 70000",
                              style: TextStyle(
                                fontSize: 36.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Headline News",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                        height: 180,
                        child: FutureBuilder(
                          future: articleFutures,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot.data);
                              return PageView.builder(
                                itemCount: snapshot.data.length,
                                controller:
                                    PageController(viewportFraction: 0.7),
                                onPageChanged: (int i) =>
                                    setState(() => _index = i),
                                itemBuilder: (context, index) {
                                  Articles article = snapshot.data[index];
                                  Source source = article.source;
                                  return Transform.scale(
                                    scale: index == _index ? 1 : 0.9,
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(
                                                article.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2.0),
                                                  child: Text(
                                                    "Sumber :" + source.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Image(
                                              image: Image.network(snapshot
                                                      .data[index].urlToImage)
                                                  .image,
                                              height: 100,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              // return ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: snapshot.data.length,
                              //     itemBuilder: (context, index) {
                              //       return Text(snapshot.data[index].title);

                            } else if (snapshot.hasError) {
                              print("error: ${snapshot.error}");
                            }

                            return Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.pinkAccent),
                                ),
                              ),
                            );
                          },
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("QrCode"),
    );
  }
}
