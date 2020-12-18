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
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/Wave-100s-1036px.png'),
            ),
            FutureBuilder(
                future: historiTransaksi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TransaksiModel> list = snapshot.data;
                    print(snapshot.data.length);
                    print(list.length);
                    return ListView.builder(
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Text(list[index].jenis_sampah);
                        });
                  } else if (snapshot.hasError) {
                    print("ikut apa yang diomongin");
                  }
                  return CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  );
                })
          ],
        ),
      ),
    );
  }
}
