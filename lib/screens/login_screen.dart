import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prediction_app/screens/forgotpasswordScreen.dart';
import 'package:provider/provider.dart';

import 'homeScreen/home_screen.dart';
import '../provider/userDataProvider.dart';
import '../widgets/custom_shape.dart';
import '../utils/image_picker.dart';
import '../utils/showAlert.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  static const routename = './login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late dynamic prodata;
  dynamic imageProdata;
  bool _showPassword = false;
  bool _isSignIn = true;
  bool isLoading = false;
  GlobalKey<FormState> _fromkey = new GlobalKey();
  String firstName = '';
  String lastName = '';
  String userEmail = '';
  String userPassword = '';
  String mobileNumber = '';
  String agentId = '';
  late String referal;
  List<Map<String, dynamic>> agentData = [];

  void changeLoadingStatus() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _login() {
    FocusScope.of(context).unfocus();
    prodata.login(userEmail, userPassword).then(
      (responce) {
        changeLoadingStatus();
        if (responce == 'success') {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
        } else {
          ShowAlert().showAlert(context, 'Alert', responce);
        }
      },
    );
  }

  void _signUp() {
    prodata
        .signUp(firstName, lastName, userEmail, userPassword, mobileNumber,
            referal, agentId)
        .then((res) {
      if (res == '') {
        _fromkey.currentState!.reset();
        setState(() {
          _isSignIn = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registed Succesfully\nPlease login'),
          duration: Duration(seconds: 3),
        ));
      } else {
        ShowAlert().showAlert(context, 'Alert', res);
      }
      changeLoadingStatus();
    });
  }

  void validate() {
    if (_fromkey.currentState!.validate()) {
      if (_isSignIn || (!_isSignIn && agentId != '')) {
        _fromkey.currentState!.save();
        changeLoadingStatus();
        _isSignIn ? _login() : _signUp();
      } else {
        ShowAlert().showAlert(context, 'Alert', 'Select an Agent');
      }
    }
  }

  _getAgents() {
    prodata.getAgentData().then((List<dynamic> data) {
      if (data.isNotEmpty) {
        data.forEach((element) {
          agentData.add(element);
        });
      }
    });
  }

  String _displayStringForOption(Map<String, dynamic> option) =>
      '${option['Name']}(${option['agent_id']})';

  @override
  void initState() {
    prodata = Provider.of<UserDataProvider>(context, listen: false);
    _getAgents();
    //FirebaseMessaging.instance.unsubscribeFromTopic("resultNotfication");
    //tokenRefresh(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          clipShape(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Form(
                    key: _fromkey,
                    child: AnimatedSize(
                      vsync: this,
                      duration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'One Dollar Trade',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            _isSignIn ? 'Login' : 'SignUp',
                            style: TextStyle(fontSize: 15),
                          ),
                          if (!_isSignIn)
                            SizedBox(
                              height: 10,
                            ),
                          if (!_isSignIn)
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'First Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (userName) {
                                if (userName!.isEmpty) {
                                  return 'Enter First Name';
                                }
                                return null;
                              },
                              onSaved: (name) {
                                firstName = name ?? '';
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isSignIn)
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (userName) {
                                if (userName!.isEmpty) {
                                  return 'Enter Last Name';
                                }
                                return null;
                              },
                              onSaved: (name) {
                                lastName = name ?? '';
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (email) {
                              if (email!.isEmpty) {
                                return 'Enter email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(email)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (email) {
                              userEmail = email ?? '';
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isSignIn)
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: 'Mobile Number',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (number) {
                                mobileNumber = number ?? '';
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter password',
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: _showPassword
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            obscureText: !_showPassword,
                            validator: (password) {
                              if (password!.isEmpty) {
                                return 'Enter password';
                              } else if (password.length < 8) {
                                return 'Password must be more than 8 characters.';
                              }
                              return null;
                            },
                            onSaved: (password) {
                              userPassword = password ?? '';
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isSignIn)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Referal (Optional)',
                                ),
                                onSaved: (ref) {
                                  referal = ref ?? '';
                                },
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isSignIn)
                            //autocomplete
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Select An Agent')),
                          if (!_isSignIn)
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Autocomplete<Map<String, dynamic>>(
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return agentData; //Iterable< Map<String, dynamic>>.empty()
                                    }
                                    return agentData.where(
                                      (Map<String, dynamic> option) {
                                        return option
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      },
                                    );
                                  },
                                  onSelected: (selection) {
                                    agentId = selection['agent_id'] ?? '';
                                  }),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: _isSignIn
                                        ? Text('Login')
                                        : Text('SignUp'),
                                  ),
                                  onPressed: validate,
                                ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ForgotPasswordScreen.routeName);
                            },
                            child: Text('Forgot Password?'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                                _fromkey.currentState!.reset();
                              });
                            },
                            child: _isSignIn
                                ? Text('Do not have an account Sign Up here')
                                : Text('Already Have an account Sign In'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Powered by Taslasoft',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget clipShape() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[200]!,
                    Colors.orange[100]!,
                    Colors.purple[100]!,
                    Colors.purple[300]!
                  ],
                  //colors: [Colors.pinkAccent, Colors.purple[200]]
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[200]!,
                    Colors.purple[100]!,
                    Colors.orange[200]!,
                    Colors.orange[300]!
                  ],
                  //colors: [Colors.purple[300], Colors.pinkAccent[400]],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: _height * 0.1,
          left: _width * 0.34,
          child: GestureDetector(
            onTap: () {
              if (!_isSignIn) {
                Imagepicker().showPicker(context);
              }
            },
            child: Consumer<UserDataProvider>(
              builder: (context, userData, _) {
                return AnimatedOpacity(
                  opacity: _isSignIn ? 0.0 : 1.0,
                  duration: Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Container(
                    height: _height * 0.15,
                    width: _height * 0.15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.0,
                            color: Colors.black26,
                            offset: Offset(1.0, 10.0),
                            blurRadius: 20.0),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:
                        userData.imagePath != null && userData.imagePath != ''
                            ? CircleAvatar(
                                radius: ((5 * _height * 0.15) / 8) -
                                    18, //formula for radius = (w * w + h / 8) +h /2 since width and height are same <-
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(
                                  File(userData.imagePath!),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.purple[200],
                                ),
                              ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

//Drop dowm for agents
/*
 List<DropdownMenuItem<String>> dropDownlist = [
    DropdownMenuItem<String>(
      value: '0',
      child: Text('Choose Agent'),
    )
  ];
  _getAgents() {
    prodata.getAgentData().then((List<dynamic> data) {
      if (data != null || data.isNotEmpty) {
        data.forEach(
          (element) {
            dropDownlist.add(
              DropdownMenuItem<String>(
                value: element['agent_id'],
                child: Text('${element['Name']}(${element['agent_id']})'),
              ),
            );
          },
        );
      }
    });
  }
 Padding(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == '0') {
                                    return 'Please select an agent';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  agentId = value;
                                },
                                hint: Text('Choose Agent'),
                                isExpanded: true,
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 15),
                                onChanged: (String newValue) {
                                  if (newValue != dropdownValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  }
                                },
                                items: dropDownlist,
                              ),
                            ), */
