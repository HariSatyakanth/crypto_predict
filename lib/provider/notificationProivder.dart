import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class NotificationProvider extends ChangeNotifier {
  List<dynamic> _notifications = [];
  String url = baseUrl;
  String path = basePath;
  bool _anyNotification = false;
  bool _isLoading = true;
  bool _nointernet = false;

  bool get anynotification => _anyNotification;

  List<dynamic> get notifications => _notifications;

  bool get loading => _isLoading;

  bool get nointernet => _nointernet;

  void _setNointernet(bool nointernet) {
    _nointernet = nointernet;
  }

  void changeNoficicationStatus(bool status) {
    _anyNotification = status;
    notifyListeners();
  }

  void changeLoadingStatus() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void compareNSet(List<dynamic> notifcationData) {
    if (_notifications.length != notifcationData.length) {
      _notifications = notifcationData;
      notifyListeners();
    }
  }

  void disposeData() {
    _notifications = [];
  }

  Future<List<dynamic>> getNotification() async {
    List<dynamic> userNotificatons = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('UserId') ?? '';
    Uri uri = Uri.http(url, path, {'action': 'userNotification'});
    try {
      await http
          .post(uri, body: {'id': id, 'date': DateTime.now().toString()}).then(
        (responce) {
          if (responce.statusCode == 200) {
            var res = json.decode(responce.body);

            userNotificatons = res['notification'] ?? [];
          }
        },
      );
    } on SocketException catch (_) {
      throw 'No internet';
    } catch (e) {
      print(e);
    }
    return userNotificatons;
  }

  Future<void> getpublicNotifications() async {
    _setNointernet(false);
    Uri uri = Uri.http(url, path, {'action': 'publicNotifications'});
    try {
      await http.get(uri).then((responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          print(res['publicNotifications']);
          compareNSet(res['publicNotifications']);
          if (_isLoading) {
            changeLoadingStatus();
          }
        }
      });
    } on SocketException catch (_) {
      changeLoadingStatus();
      _notifications = [];
      _setNointernet(true);
    } catch (e) {
      print(e);
    }
  }
}
