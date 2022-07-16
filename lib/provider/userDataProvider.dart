import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class UserDataProvider extends ChangeNotifier {
  User _user = new User(
    id: '',
    firstName: '',
    lastName: '',
    fullName: '',
    email: '',
    isSubscribed: 0,
    subscription: '',
  );
  String agentId = '';
  String agentName = '';
  String url = baseUrl;
  String path = basePath;
  String? _image;
  List<dynamic> agentData = [];
  String playStoreLink = '';

  void image(String image) {
    _image = image;
    notifyListeners();
  }

  void setuser(User user) {
    _user = user;
    notifyListeners();
  }

  String get agentid => agentId;

  String get agentname => agentName;

  String? get imagePath => _image;

  User get user => _user;

  String get userRefereral => _user.referal!;

  int get isSubscribed => _user.isSubscribed;

  void disposeData() {
    _image = '';
    _logoutUser();
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserId') ?? '';
  }

  List<String> encript(String password) {
    int length = 32;
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String salt = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String hashpass = sha1.convert(utf8.encode(password)).toString();
    salt = md5.convert(utf8.encode(salt)).toString();
    String pass = sha1.convert(utf8.encode(salt + hashpass)).toString();
    return [salt, pass];
  }

  Future<void> fetechUserData() async {
    Uri uri = Uri.http(url, path, {'action': 'fectchUserData'});
    String id = await getUserId();
    if (id != '') {
      try {
        await http.post(uri, body: {
          'id': id,
        }).then((responce) async {
          // print(responce.statusCode);
          if (responce.statusCode == 200) {
            var res = json.decode(responce.body);
            agentId = res['data']['agent_id'] ?? '';
            agentName = res['data']['Name'] ?? '';
            print('From provider $res');
            playStoreLink = res['playstoreLink'] ?? '';
            await Future(() {
              return User.fromJson(res['data']);
            }).then((value) => setuser(value));
          }
        });
      } on SocketException catch (_) {
        throw 'No Internet...';
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> login(String email, String password) async {
    Uri uri = Uri.http(url, path, {'action': 'login'});
    String errorString = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String pass = sha1.convert(utf8.encode(password)).toString();
    try {
      await http.post(uri, body: {
        'email': '$email',
        'password': '$pass',
      }).then((responce) async {
        if (responce.statusCode == 200) {
          final res = json.decode(responce.body);
          if (res['success'] == 1) {
            preferences.setString(
                'UserId', res['userId']); //setting user id to sharedpreferance
            await fetechUserData();
            // FirebaseMessaging.instance.getToken().then((token) {
            //   if (token != null) {
            //     userToken(token);
            //   }
            // });
            errorString = 'success';
          } else {
            errorString = res['message'] ?? 'error';
          }
        } else {
          errorString = 'failed to login try again';
        }
      });
    } on SocketException catch (_) {
      errorString = 'Please check your network connetion and retry';
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<void> userToken(String _token) async {
    String url = baseUrl;
    String path = basePath;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('UserId');
    final Uri uri = Uri.http(url, path, {'action': 'setUserToken'});
    if (id != null && id != '') {
      try {
        if (_token != '') {
          await http.post(uri, body: {
            'id': id,
            'token': _token,
          }).then((response) {
            if (response.statusCode == 200) {
              // print(json.decode(response.body));
            }
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> signUp(
      String firstName,
      String lastName,
      String email,
      String password,
      String mobileNumber,
      String referal,
      String agentId) async {
    String errorString = '';
    Uri uri = Uri.http(url, path, {'action': 'signUp'});
    List<String> pass = encript(password);
    try {
      await http.post(uri, body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNumber': mobileNumber,
        'salt': pass[0],
        'password': pass[1],
        'referal': referal,
        'agentId': agentId,
      }).then((responce) async {
        // print(responce.statusCode);
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          //print(res);
          if (res['success'] == 1) {
            if (_image != null && _image != '') {
              await uploadImage(res['lastId'].toString())
                  .then((error) => errorString = error);
            }
          } else {
            errorString = res['message'] ?? 'Error';
          }
        } else {
          errorString = 'Error conneting to database please check the internet';
        }
      });
    } on SocketException catch (_) {
      errorString = 'Please check your network connetion and retry';
    }
    return errorString;
  }

  Future<String> uploadImage(String id) async {
    String errorString = '';
    String imageName =
        DateFormat('yyyyMMddhms').format(DateTime.now()).toString();
    Uri uri = Uri.parse('http://' + url + path + '?action=imageUpload');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath("photo", _image!));
    request.fields['id'] = id;
    request.fields['imageName'] = imageName;
    try {
      await request.send().then((response) async {
        await http.Response.fromStream(response).then((value) {
          var res = json.decode(value.body);
          // print(res['success']);
          if (res['success'] == 1) {
            // print(res);
          } else {
            errorString = res['message'] ?? '';
          }
        });
      });
    } on SocketException catch (_) {
      errorString = 'No Internet';
    }
    return errorString;
  }

  Future<void> updateUser(String firstName, String lastName, String email,
      String mobileNumber, String nric, String address, String postCode) async {
    String id = await getUserId();
    Uri uri = Uri.http(url, path, {'action': 'updateUser'});
    try {
      await http.post(uri, body: {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'emailId': email,
        'mobileNumber': mobileNumber,
        'nric': nric,
        'address': address,
        'postCode': postCode,
      }).then((responce) async {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          // print(res);
          if (_image != null && _image != '') {
            await uploadImage(id);
          }
          fetechUserData();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _logoutUser() async {
    String id = await getUserId();
    Uri uri = Uri.http(url, path, {'action': 'logOutUser'});
    try {
      await http.post(uri, body: {
        'id': id,
      }).then((responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          //print(res);
        }
      });
    } on SocketException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> getAgentData() async {
    Uri uri = Uri.http(url, path, {'action': 'getAgents'});
    try {
      await http.get(uri).then((responce) {
        if (responce.statusCode == 200) {
          var res = json.decode(responce.body);
          //print(res);
          agentData = res['agentData'] ?? [];
        }
      });
    } on SocketException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return agentData;
  }

  String _forgotPasswordError(bool isMailExists, bool isMailSent) {
    if (!isMailExists) {
      return 'No such mail Exists \nPlease recheck the mail';
    } else if (isMailExists && !isMailSent) {
      return 'Something went wrong Please try again later';
    }
    return '';
  }

  Future<String?> forgotPassword(String email) async {
    String? error;
    Uri uri = Uri.http(url, path, {'action': 'forgetPassword'});
    try {
      await http.post(uri, body: {
        'email': email,
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print(data);
          error = _forgotPasswordError(data['emailExists'], data['isMailSent']);
        } else {
          error = 'Something went wrong please try again later';
        }
      });
    } catch (e) {
      error = 'Something went wrong please try again later';
      print(e);
    }
    return error;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    bool isValid = false;
    Uri uri = Uri.http(url, path, {'action': 'verifyOtp'});
    print('infuture');
    try {
      await http.post(uri, body: {
        'email': email,
        'otp': otp,
      }).then(
        (response) {
          if (response.statusCode == 200) {
            var data = json.decode(response.body);
            isValid = data['result'];
          }
        },
      );
    } catch (e) {
      print(e);
    }
    return isValid;
  }

  Future<void> resetPassword(String password, String userEmail) async {
    List<String> pass = encript(password);
    Uri uri = Uri.http(url, path, {'action': 'resetPassword'});
    try {
      await http.post(uri, body: {
        'salt': pass[0],
        'pass': pass[1],
        'email': userEmail,
      }).then((responce) {
        if (responce.statusCode == 200) {
          print(responce.body);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
