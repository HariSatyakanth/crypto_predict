import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class PaymentProvider with ChangeNotifier {
  String url = baseUrl;
  String path = basePath;
  Map<String, dynamic> bankDetails = {
    'holderName': '',
    'AccountNumber': '',
    'Ifsc': '',
    'upi': '',
    'depositeCode': '',
    'amount': '',
  };

  Map<String, dynamic> get bankdetails => bankDetails;

  Future<void> newPaymentSub(String? subId, String? subamount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final Uri uri = Uri.http(url, path, {'action': 'newPaymentsub'});
    try {
      await http.post(uri, body: {
        'id': id,
        'subId': subId,
        'subamount': subamount,
        'dateTime': DateTime.now().toString(),
      }).then((response) {
        if (response.statusCode == 200) {
          var res = json.decode(response.body);
         // print(res);
          bankDetails = {
            'holderName': res['bankDetails']['HolderName'] ?? '',
            'AccountNumber': res['bankDetails']['AccountNumber'] ?? '',
            'Ifsc': res['bankDetails']['IFSC'] ?? '',
            'upi': res['bankDetails']['UPI'] ?? '',
            'depositeCode': res['depositeCode'] ?? '',
            'amount': res['amount'] ?? '',
          };
        }
      });
    } on SocketException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkPrevSub(String? packageId) async {
    bool result = false;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('UserId') ?? '';
    final Uri uri = Uri.http(url, path, {'action': 'checkPrevSub'});
    await http.post(uri, body: {
      'id': id,
      'dateTime': DateTime.now().toString(),
      'packageId': packageId
    }).then(
      (responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
         // print(res);
          if (res['preSub'] == 0) {
            result = false;
          } else {
            bankDetails = {
              'holderName': res['bankDetails']['HolderName'] ?? '',
              'AccountNumber': res['bankDetails']['AccountNumber'] ?? '',
              'Ifsc': res['bankDetails']['IFSC'] ?? '',
              'upi': res['bankDetails']['UPI'] ?? '',
              'depositeCode': res['preSub']['Deposite_code'] ?? '',
              'amount': res['preSub']['amount'] ?? '',
            };
            result = true;
          }
        }
      },
    );
    return result;
  }
}
