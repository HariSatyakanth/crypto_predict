import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/result.dart';
import '../utils/constants.dart';

class ResultProvider extends ChangeNotifier {
  Result _result = Result(
      date: '-',
      firstPrize: '-',
      secondPrize: '-',
      thirdPrize: '-',
      consolationPrizes: ['-'],
      drawNumber: '-',
      specialPrize: ['-']);
  String url = baseUrl;
  String path = basePath;
  DateTime? _seletedDate;
  List<String> _matchedNumbers = [];

  void setDate(DateTime date) {
    _seletedDate = date;
  }

  DateTime? get date => _seletedDate;

  void setResult(Result result) {
    _result = result;
  }

  Result get result => _result;

  List<String> getEmptyResult() {
    return List.generate(8, (_) => '-');
  }

  Result _getEmptyResultModel() {
    return Result(
        date: '-',
        firstPrize: '-',
        secondPrize: '-',
        thirdPrize: '-',
        consolationPrizes: getEmptyResult(),
        drawNumber: '-',
        specialPrize: getEmptyResult());
  }

  List<String> get matchedNumbers => _matchedNumbers;

  _setMatchedNumbers(List<dynamic> data) {
    _matchedNumbers.clear();
    data.forEach((e) => _matchedNumbers.add(e));
  }

  Future<Result> getResult() async {
    final Uri uri = Uri.http(url, path, {'action': 'getResultsData'});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final DateTime date = _seletedDate ?? DateTime.now();
    try {
      await http.post(uri, body: {
        'id': id,
        'dateTime': DateFormat('yyyy-MM-dd').format(date).toString(),
      }).then((responce) async {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          print(res);
          if (res['message'] == 'success') {
            print(res['matchedNumbers']);
            //_matchedNumbers = res['matchedNumbers'] as List<String>;
            _setMatchedNumbers(res['matchedNumbers']);
            _result = Result.fromJson(res['data']);

            // await Future(() {
            //   return Result.fromJson(res['data']);
            // }).then((value) async {
            //   _result = value;
            // });
          } else {
            setResult(_getEmptyResultModel());
          }
        } else {
          setResult(_getEmptyResultModel());
        }
      });
    } on SocketException catch (_) {
      print('no Internet');
      throw 'No Internet';
    } catch (e) {
      print(e);
    }
    return _result;
  }

  /*Future<List<String>> getPrdictedNumbers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId');
    final Uri uri = Uri.http(url, path, {'action': 'getPredictedNumbers'});
    await http.post(uri, body: {
      'id': id,
    }).then((responce) {
      if (responce.statusCode == 200) {
        final res = json.decode(responce.body);
        if (res['success'] == '1') {
          print('get numbers ${res['data']}');
          numbers(res['data']);
        }
      }
    });
    return _predictedNumbers['numbers'];
  }*/
}

/* _getMatchedNumbers() {
    List<String> resultNumbers = [
      _result.firstPrize,
      _result.secondPrize,
      _result.thirdPrize,
      ..._result.specialPrize,
      ..._result.consolationPrizes
    ];
    try {
      if (_predictedNumbers != null &&
          _predictedNumbers['numbers'] != null &&
          _predictedNumbers['numbers'].isNotEmpty) {
        if (DateFormat.yMd()
                .format(DateTime.tryParse(_predictedNumbers['date'])) ==
            DateFormat.yMd().format(DateTime.tryParse(_result.date))) {
          print('in compare');
          var thisnumbers = resultNumbers
              .where(
                  (element) => _predictedNumbers['numbers'].contains(element))
              .toList();
          _matchedNumbers = thisnumbers;
        }
      }
    } catch (e) {
      print(e);
    }
  }*/

/* void numbers(Map<String, dynamic> numbers) {
    _predictedNumbers = {
      'date': numbers['pdate'],
      'numbers': numbers['Numbers'].split(',') as List<String>,
    };
  }*/

//List<String> geSt predictedNumbers => _predictedNumbers['numbers'];
