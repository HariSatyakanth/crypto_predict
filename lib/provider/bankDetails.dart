import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class BankDetails extends ChangeNotifier {
  String url = baseUrl;
  String path = basePath;
  bool doNotCall = false;

  void changeCallStatus() {
    doNotCall = !doNotCall;
  }

  Map<String, dynamic> bankData = {
    'name': '',
    'account_no': '',
    'bank_name': '',
    'branch': '',
  };

  Future<String> _getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    return id;
  }

  Future<Map<String, dynamic>> getBankDetails() async {
    Map<String, dynamic>? userBankDetails;
    if (!doNotCall) {
      String id = await _getId();
      Uri uri = Uri.http(url, path, {'action': 'getUserBankDetails'});
      try {
        await http.post(uri, body: {'id': id}).then(
          (responce) {
            if (responce.statusCode == 200) {
              var data = json.decode(responce.body);
              if (data['success']) {
                userBankDetails = data['data'];
                print(userBankDetails);
              }
            } else {
              throw 'error';
            }
          },
        );
      } on SocketException catch (_) {
        throw 'No internet';
      } catch (e) {
        print(e);
      }
    }
    return userBankDetails ?? bankData;
  }

  Future<void> updateBankDetails(
      String name, String accountNo, String bankName, String branch) async {
    Uri uri = Uri.http(url, path, {'action': 'updateUserBankDetails'});
    String id = await _getId();
    try {
      await http.post(uri, body: {
        'id': id,
        'name': name,
        'account_no': accountNo,
        'bank_name': bankName,
        'branch': branch,
      }).then((responce) {
        if (responce.statusCode == 200) {
          var data = json.decode(responce.body);
          print(data);
        }
      });
    } on SocketException catch (_) {
      throw 'No internet';
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addNewWithdraw(String amount) async {
    bool _noPreviousRequest = true;
    Uri uri = Uri.http(url, path, {'action': 'addNewWithdraw'});
    String id = await _getId();
    try {
      await http.post(uri, body: {
        'id': id,
        'amount': amount,
      }).then(
        (responce) {
          if (responce.statusCode == 200) {
            var data = json.decode(responce.body);
            _noPreviousRequest = data['success'];
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return _noPreviousRequest;
  }
}
