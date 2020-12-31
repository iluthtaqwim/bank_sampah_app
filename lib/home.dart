import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bank_sampah/berita.dart';
import 'package:bank_sampah/model/Session.dart';
import 'package:bank_sampah/model/articles.dart';
import 'package:bank_sampah/model/source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  String posturl;
  Future<List<Articles>> articleFutures;
  Future<Map<String, dynamic>> getFromToken;

  Future<Map<String, dynamic>> getDataFromToken() async {
    Session session = await Session.getSession();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(session.token);
    return decodedToken;
  }

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
    getFromToken = getDataFromToken();
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
                                fontSize: 20.0, fontWeight: FontWeight.w400),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                future: getFromToken,
                                builder: (context, snapshot) {
                                  return Text(
                                    "Rp " + snapshot.data['total_tabungan'],
                                    style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
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
                Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 180,
                    child: Container(
                      child: FutureBuilder(
                        future: articleFutures,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PageView.builder(
                              itemCount: snapshot.data.length,
                              controller: PageController(viewportFraction: 0.7),
                              onPageChanged: (int i) =>
                                  setState(() => _index = i),
                              itemBuilder: (context, index) {
                                Articles article = snapshot.data[index];
                                Source source = article.source;
                                return Transform.scale(
                                  scale: index == _index ? 1 : 0.9,
                                  child: GestureDetector(
                                    onTap: () {
                                      var url = article.url;
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Berita(url),
                                        ),
                                      );
                                    },
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
                                                article.title ?? "",
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
                                                    "Sumber :" + source.name ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data[index].urlToImage,
                                              height: 100,
                                            ),
                                          ],
                                        ),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
