import 'package:flutter/material.dart';
import 'package:prediction_app/provider/userDataProvider.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:prediction_app/utils/showAlert.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/resetPassScreen';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? userEmail;
  bool newPass = false;
  bool confNewPass = true;
  String? newPassword;
  String? conformPassword;
  var userProvider;

  void _onSaved() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (newPassword == conformPassword) {
        userProvider.resetPassword(newPassword, userEmail).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset is successful'),
            ),
          );
          Navigator.of(context).pop();
        });
      } else {
        ShowAlert().showAlert(context, 'Alert', 'Both password must be same');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserDataProvider>(context);
    userEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Reset Password'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primarycolor,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              size: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: newPass,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'New Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                newPass = !newPass;
                              });
                            },
                            icon: newPass
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                        validator: (pass) {
                          if (pass == null || pass == '') {
                            return 'Enter password';
                          } else if (pass.length < 6) {
                            return 'Chosse a password having length greater than 6';
                          }
                          return null;
                        },
                        onSaved: (pass) {
                          newPassword = pass;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: confNewPass,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: 'Conform New Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  confNewPass = !confNewPass;
                                });
                              },
                              icon: confNewPass
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            )),
                        validator: (confpass) {
                          if (confpass == null || confpass == '') {
                            return 'Enter password';
                          } else if (confpass.length < 6) {
                            return 'Chosse a password having length greater than 6';
                          }
                          return null;
                        },
                        onSaved: (confPass) {
                          conformPassword = confPass;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _onSaved,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
