import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../models/predictedNumbersModel.dart';

class PredictedNumbersProvider extends ChangeNotifier {
  String url = baseUrl;
  String path = basePath;
  PredictedNumbersModel preNumbers = PredictedNumbersModel(
      date: DateTime.now(),
      prime: '0',
      primePer: '0.0',
      second: '0',
      secondPer: '0.0',
      third: '0',
      thirdPer: '0.0');
  String type = 'Generic';

  void setType(String typ) {
    type = typ;
  }

  String get whichType => type;

  PredictedNumbersModel get predictedNumbers => preNumbers;

  PredictedNumbersModel _getEmptyModel() {
    return PredictedNumbersModel(
        date: DateTime.now(),
        prime: '0',
        primePer: '0.0',
        second: '0',
        secondPer: '0.0',
        third: '0',
        thirdPer: '0.0');
  }

  Future<PredictedNumbersModel> getPrdictedNumbers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final Uri uri = Uri.http(url, path, {'action': 'getPredictedNumbers'});
    try {
      await http.post(uri, body: {
        'id': id,
        'type': type,
      }).then(
        (responce) {
          if (responce.statusCode == 200) {
            final res = json.decode(responce.body);
            //print('from provider $res');
            if (res['success'] == 1) {
              preNumbers = PredictedNumbersModel.fromJson(res['data']);
            } else {
              preNumbers = _getEmptyModel();
            }
          } else {
            preNumbers = _getEmptyModel();
          }
        },
      );
    } on SocketException catch (_) {
      preNumbers = _getEmptyModel();
      throw 'No Interet';
    } catch (e) {
      print(e);
    }

    return preNumbers;
  }
}
