import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MembersProvider with ChangeNotifier {
  String url = baseUrl;
  String path = basePath;

  Future<List<dynamic>> getMembers(String? userId) async {
    List<dynamic> data = [];
    String id;
    if (userId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('UserId') ?? '';
    } else {
      id = userId;
    }
    final Uri uri = Uri.http(url, path, {'action': 'getMembers'});
    try {
      await http.post(uri, body: {
        'id': id,
      }).then(
        (response) {
          if (response.statusCode == 200) {
            print(response.body);
            var res = json.decode(response.body);
            data = res['members'];
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return data;
  }
}
