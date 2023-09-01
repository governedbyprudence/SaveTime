import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QRModel {
  String qrData;
  String tag;

  QRModel({
    required this.qrData,
    required this.tag
  });

  String toJsonString() {
    return jsonEncode({
      {
        "qrData": qrData,
        "tag": tag
      }
    });
  }

  factory QRModel.fromJsonString(String json){
    Map data = jsonDecode(json);
    if (data.keys.contains("qrData") && data.keys.contains("tag")) {
      return QRModel(qrData: data["qrData"], tag: data["tag"]);
    }
    else {
      throw ArgumentError("Wrong Json");
    }
  }

  static saveToCache(List<String> qr) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    List<String>? data = instance.getStringList("qrlist");
    if (data != null) {
      qr.addAll(data);
    }
    instance.setStringList("qrlist", qr);
  }

  static Future<List<QRModel>?> getListFromCache() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    List<String>? data = instance.getStringList("qrlist");
    if (data != null) {
      List<QRModel> modelData = [];
      for (String i in data) {
        modelData.add(QRModel.fromJsonString(i));
      }
      return modelData;
    }
    return null;
  }
}