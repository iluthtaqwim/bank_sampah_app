import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bank_sampah/berita.dart';
import 'package:bank_sampah/model/Session.dart';
import 'package:bank_sampah/model/articles.dart';
import 'package:bank_sampah/model/source.dart';
import 'package:bank_sampah/model/Tabungan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List data;
  int _index = 0;
  bool _isLoading = true;
  String posturl;
  String BASE_URL = 'http://192.168.100.200/bank_sampah/api/nasabah/tabungan';

  Future<String> getDataFromId() async {
    Session session = await Session.getSession();
    return session.id_nasabah;
  }

  Future<String> getData() async {
    http.Response response =
        await http.get(Uri.encodeFull("https://api.kawalcorona.com/indonesia"));
    _isLoading = false;
    setState(() {
      data = json.decode(response.body);
    });
    return "Success!";
  }

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

  Future<String> tabungan() async {
    var asd = await getDataFromId();
    Map payload = {'id_nasabah': asd};
    var headers = {
      'x-api-key': 'CODEX@123',
      'Authorization': 'Basic aWx1dGg6aWx1dGg='
    };
    var response = await http.post(BASE_URL, headers: headers, body: payload);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      String list = body['tabungan']['total_tabungan'].toString();
      print(list);
      return list;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    articleFutures = fetchArticles();
    getFromToken = getDataFromToken();
    this.getData();
    this.tabungan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Wave-100s-1036px.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.pinkAccent,
        onRefresh: fetchArticles,
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Wave-100s-1036px.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: tabungan(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    "Rp " + snapshot.data,
                                    style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("0");
                                }
                                return CircularProgressIndicator();
                              },
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
                    "Live Data Covid-19 Indonesia",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Stack(children: [
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.pinkAccent),
                          ),
                        )
                      : ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data == null ? 0 : data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .lightGreenAccent
                                                        .shade400,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(0, 21),
                                                        blurRadius: 53,
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Sembuh",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(Icons
                                                              .accessibility_outlined),
                                                          Text(
                                                            data[index]
                                                                ["sembuh"],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(0, 21),
                                                        blurRadius: 53,
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Positif",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(Icons
                                                              .add_rounded),
                                                          Text(
                                                            data[index]
                                                                ["positif"],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(0, 21),
                                                        blurRadius: 53,
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Dirawat",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(Icons
                                                              .local_hotel),
                                                          Text(
                                                            data[index]
                                                                ["dirawat"],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(0, 21),
                                                        blurRadius: 53,
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Meninggal",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(Icons
                                                              .assistant_photo_outlined),
                                                          Text(
                                                            data[index]
                                                                ["meninggal"],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          addAutomaticKeepAlives: true,
                        ),
                ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Headline News",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                                              BorderRadius.circular(10)),
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
          ),
        ),
      ),
    );
  }
}
