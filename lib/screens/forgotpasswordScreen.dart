import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:prediction_app/screens/resetPasswordScreen.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:prediction_app/utils/showAlert.dart';

import 'package:provider/provider.dart';

import '../provider/userDataProvider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotpassword';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  var userProvider;
  bool isSendMail = false;

  void verify() {
    if (_otpController.value.text != '' && _emailController.value.text != '') {
      userProvider
          .verifyOtp(_emailController.value.text, _otpController.value.text)
          .then((isvalid) {
        if (isvalid) {
          print('valid');
          Navigator.of(context).pushReplacementNamed(
              ResetPasswordScreen.routeName,
              arguments: _emailController.value.text);
        } else {
          ShowAlert().showAlert(context, 'Alert', 'Invalid otp');
        }
      });
    }
  }

  bool _vaildateEmail(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email)) {
      return true;
    }
    return false;
  }

  void sendOtp() async {
    print('send otp');
    userProvider.forgotPassword(_emailController.value.text).then((error) {
      if (error != null && error != '') {
        ShowAlert().showAlert(context, 'alert', error);
      } else {
        setState(() {
          isSendMail = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();

    super.dispose();
  }

  Widget emailField() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Enter the email associated with your account.\n',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                children: [
                  TextSpan(
                      text: 'We will send a verification code to your mail.',
                      style: TextStyle(color: Colors.black54, fontSize: 16))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                hintText: 'Enter your email',
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              if (_vaildateEmail(_emailController.value.text)) {
                sendOtp();
              } else {
                print('Invalid mail.');
              }
            },
            child: Text('Send Email'),
          ),
        ],
      ),
    );
  }

  Widget otpField() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'An email with verification code has been sent to your mail.\n',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Please enter the otp below.',
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'Enter otp',
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              verify();
            },
            child: Text('Verify otp'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Forgot password'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primarycolor,
            ),
            child: Icon(
              Icons.email,
              size: 100,
              color: Colors.white,
            ),
          ),
          isSendMail ? otpField() : emailField()
        ],
      ),
    );
  }
}
