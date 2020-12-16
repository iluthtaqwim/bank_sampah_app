import 'package:bank_sampah/model/Session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Map<String, dynamic>> getDataFromToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // print(decodedToken['nama_nasabah']);
    return decodedToken;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDataFromToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Material(
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Row(
                      children: [
                        Text(
                          "Profile",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              "https://instagram.fjog3-1.fna.fbcdn.net/v/t51.2885-19/s150x150/51266182_375389293014030_1874621893194022912_n.jpg?_nc_ht=instagram.fjog3-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=f6D9uNsFCB8AX-y4vI5&tp=1&oh=c401b87913ce8db61e5bbad76fd19c21&oe=60037E0C",
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data['nama_nasabah'],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              snapshot.data['no_hp'],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 10,
                    child: Container(
                      color: Colors.black12,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: double.infinity,
                    child: Text(
                      "Akun",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded),
                        Text("Ubah Profil"),
                        (Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Text("Error");
      },
    );
  }
}
