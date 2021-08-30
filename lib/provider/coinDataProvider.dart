import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CoinDataProvider with ChangeNotifier {
  String url = baseUrl;
  String path = basePath;

  //List<Newcoin>? coinData;

  //List<Newcoin>? get coindata => coinData;

  // ignore: close_sinks
  StreamController<List<Newcoin>> dataStream =
      StreamController<List<Newcoin>>.broadcast();

  Stream<List<Newcoin>> get getStreamDate => dataStream.stream;

  void addToStream(List<Newcoin> data) {
    dataStream.sink.add(data);
  }

  // void dispose() async {
  //   await dataStream.close();
  //   super.dispose();
  // }

  Future<void> getNewCoinsData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final Uri uri = Uri.http(url, path, {'action': 'getNewCoins'});
    DateTime now = DateTime.now();
    List<Newcoin> coinData = [];
    try {
      await http.post(uri, body: {'id': id, 'dateTime': now.toString()}).then(
          (responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          if (res['result']) {
            print(res);
            List<dynamic> data = res['data'];
            coinData = data.map((e) => Newcoin.fromJson(e)).toList();
            addToStream(coinData);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

class Newcoin {
  String coinName;
  String coinSymbol;
  String tradeDate;
  String tradeStartTime;
  String buyPrice;
  String sellingPrice;
  String stopLoss;
  String platform;
  String icon;
  String address;

  Newcoin({
    required this.coinName,
    required this.coinSymbol,
    required this.tradeDate,
    required this.buyPrice,
    required this.platform,
    required this.icon,
    required this.sellingPrice,
    required this.stopLoss,
    required this.tradeStartTime,
    required this.address,
  });

  factory Newcoin.fromJson(Map<String, dynamic> json) {
    return Newcoin(
      coinName: json['Coin'],
      coinSymbol: json['symbol'],
      tradeDate: json['Trade_Date'],
      tradeStartTime: json['Trade_Start_Time'],
      buyPrice: json['Buy_Price'],
      sellingPrice: json['Selling_Price'],
      platform: json['Platform'],
      stopLoss: json['Stop_Loss'],
      icon: json['icon'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
