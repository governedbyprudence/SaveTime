import 'dart:convert';

import 'package:savetime/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRModel {
  String qrData;
  String tag;
  DateTime dateTime;
  QRModel({
    required this.qrData,
    required this.tag,
    required this.dateTime
  });

  String toJsonString() {
    return jsonEncode(
      {
        "qrData": qrData,
        "tag": tag,
        "datetime":dateTime.toString()
      }
    );
  }

  factory QRModel.fromJsonString(String json){
    Map data = jsonDecode(json);
    if (data.keys.contains("qrData") && data.keys.contains("tag")) {
      return QRModel(qrData: data["qrData"], tag: data["tag"],dateTime: DateTime.parse(data["datetime"]));
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

  static Future<void> deleteAllItemsFromCache()async{
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove("qrlist");
  }

  static Future<void> deleteItemByTag(String tag)async{
    List<QRModel>? allData = await QRModel.getListFromCache();

    if(allData!=null) {
      allData.removeWhere((element) => element.tag == tag);
      List<String> jsonData = [];
      try{
        for (var i in allData) {
          CustomLogger.debug(i.qrData);
          jsonData.add(i.toJsonString());
        }
      }catch(e){
        CustomLogger.error(e);
      }
      await QRModel.deleteAllItemsFromCache();
      await QRModel.saveToCache(jsonData);
    }
  }
}