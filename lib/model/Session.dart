import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  String id_nasabah;
  String id_wilayah;
  String nama_nasabah;
  String token;

  Session.fromJsonMap(Map<String, dynamic> map)
      : id_nasabah = map["id_nasabah"],
        id_wilayah = map["id_wilayah"],
        nama_nasabah = map["nama_nasabah"],
        token = map["token"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_nasabah'] = id_nasabah;
    data['id_wilayah'] = id_wilayah;
    data['nama_nasabah'] = nama_nasabah;
    data['token'] = token;
    return data;
  }

  static getSession() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var json = prefs.getString("login_json");
      return Session.fromJsonMap(jsonDecode(json));
    } on Exception catch (_) {
      throw Exception('error');
    }
  }

  static setLoginData(Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var session = Session.fromJsonMap(map).toJson();
    prefs.setString("login_json", jsonEncode(session));
  }

  static logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
