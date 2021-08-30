import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider extends ChangeNotifier {
  String url = baseUrl;
  String path = basePath;
  String _totalBalance = 'Feteching Data..';

  void setBalance(String bal) {
    _totalBalance = bal;
    notifyListeners();
  }

  String get totBal => _totalBalance;

  Future<List<dynamic>> getWalletData(bool inRout) async {
    List<dynamic> data = [];
    String typeData = inRout ? 'in' : 'out';
    Map<String, dynamic> responceData;
    Uri uri = Uri.http(url, path, {'action': 'getWalletData'});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('UserId'); 
    try {
      await http
          .post(uri, body: {'id': id, 'inRout': typeData}).then((responce) {
        if (responce.statusCode == 200) {
          responceData = json.decode(responce.body);
          setBalance(responceData["balance"]);
          data = responceData["data"] as List<dynamic>;
          //print(data);
        }
      });
    } on SocketException catch (_) {
      throw 'No internet';
    } catch (e) {
      print('from error');
      print(e);
    }
    return data;
  }
}
