import 'dart:convert';

import 'package:bank_sampah/model/Session.dart';
import 'package:bank_sampah/model/Transaksi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  var BASE_URL =
      'http://192.168.100.200/bank_sampah/api/transaksi/transaksi_nasabah';

  Future<String> getDataFromToken() async {
    Session session = await Session.getSession();
    return session.id_nasabah;
  }

  Future<List<TransaksiModel>> historiTransaksi() async {
    var asd = await getDataFromToken();
    Map payload = {'id_nasabah': asd};
    var headers = {
      'x-api-key': 'CODEX@123',
      'Authorization': 'Basic aWx1dGg6aWx1dGg='
    };
    var response = await http.post(BASE_URL, headers: headers, body: payload);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<dynamic> list = body["person"] as List<dynamic>;
      List<TransaksiModel> trx =
          list.map((e) => TransaksiModel.fromJsonMap(e)).toList();

      return trx;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/images/Wave-100s-1036px.png'),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Row(
                    children: [
                      Text(
                        "Histori Transaksi",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Riwayat Transaksi"),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: FutureBuilder(
                      future: historiTransaksi(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<TransaksiModel> list = snapshot.data;
                          print(snapshot.data.length);
                          return ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        physics: ScrollPhysics(),
                                        itemCount: list.length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Card(
                                                child: ListTile(
                                                  leading: Text(
                                                    list[index].berat_sampah +
                                                        " Kg",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3,
                                                  ),
                                                  title: Text(
                                                      list[index].jenis_sampah),
                                                  subtitle: Text(list[index]
                                                      .tanggal_transaksi),
                                                  dense: true,
                                                  isThreeLine: true,
                                                  trailing: Text("Rp " +
                                                      list[index].harga),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          print("ikut apa yang diomongin");
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.pinkAccent),
                          ),
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
