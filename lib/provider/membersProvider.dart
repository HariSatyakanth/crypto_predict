import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class MembersProvider with ChangeNotifier {
  String url = baseUrl;
  String path = basePath;

  Future<List<dynamic>> getMembers() async {
    List<dynamic> data = [];
    final Uri uri = Uri.http(url, path, {'action': 'getMembers'});
    try {
      await http.get(uri).then(
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
