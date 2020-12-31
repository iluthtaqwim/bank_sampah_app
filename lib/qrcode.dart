import 'package:bank_sampah/model/articles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:bank_sampah/model/Session.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

Future<Map<String, dynamic>> getDataFromToken() async {
  Session session = await Session.getSession();
  Map<String, dynamic> decodedToken = JwtDecoder.decode(session.token);

  return decodedToken;
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image(
        image: AssetImage("assets/images/Wave-100s-1036px.png"),
      ),
      Center(
        child: FutureBuilder(
          future: getDataFromToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Qr Code',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Text('Silahkan Scan untuk transaksi lebih mudah'),
                    Image(
                      image: Image.network(snapshot.data['qr_code']).image,
                    )
                  ],
                ),
              );
            } else {
              return Text('has no data');
            }
          },
        ),
      ),
    ]);
  }
}
