import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';


class HistoryDataProvider with ChangeNotifier {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  String url = baseUrl;
  String path = basePath;

  List<dynamic> historyData = [];

  void setDate(DateTime? startdate, DateTime? enddate) {
    if (startdate != null && enddate != null) {
      _startDate = startdate;
      _endDate = enddate;
      notifyListeners();
    }
  }

  DateTime get startdate => _startDate;
  DateTime get enddate => _endDate;

  Future<List<dynamic>> getHistoryData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final Uri uri = Uri.http(url, path, {'action': 'historyData'});
    try {
      await http.post(uri, body: {
        'id': id,
        'startDate': _startDate.toString(),
        'endDate': _endDate.toString(),
      }).then(
        (response) {
         // print(response.statusCode);
          if (response.statusCode == 200) {
            var res = json.decode(response.body);
            if (res['success'] == 1) {
              //print(res['rows']);
              historyData = res['rows'] ?? [];
            }
          }
        },
      );
    } on SocketException catch (_) {
      throw 'No internet';
    } catch (e) {
      print(e);
    }
    return historyData;
  }

  /* Future<void> getNotification() async {
    Uri uri = Uri.http(url, path, {'action': 'androidNotification'});
    try {
      await http.get(uri).then((responce) {
        if (responce.statusCode == 200) {
          print('this is responce');
          print(responce.body);
         // print(json.decode(responce.body));
        }
      });
    } catch (e) {
      print(e);
    }
  }*/
}
