import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class SubsciptionProvider with ChangeNotifier {
  String url = baseUrl;
  String path = basePath;
  List<dynamic> _subsciptionData = [];

  List<Map<String, dynamic>> get subscriptiondata =>
      _subsciptionData as List<Map<String, dynamic>>;

  Future<List<dynamic>> fetchSubData() async {
    Uri uri = Uri.http(url, path, {'action': 'fetchSubData'});
    try {
      await http.get(uri).then((responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          if (res['success'] == 1) {
            List<dynamic> data = res['subData'] ?? [];
           // print('from provider $data');
            _subsciptionData = data;
          }
        } else {
          _subsciptionData = [];
        }
      });
    } on SocketException catch (_) {
      print('no internet');
      _subsciptionData = [];
    } catch (e) {
      print(e);
    }
    return _subsciptionData;
  }
}
