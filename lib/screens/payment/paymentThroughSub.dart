import 'package:flutter/material.dart';
import 'package:prediction_app/provider/paymentProvider.dart';
import 'package:prediction_app/provider/userDataProvider.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:prediction_app/utils/showAlert.dart';
import 'package:provider/provider.dart';

import '../../widgets/policy_dialog.dart';
import '../../models/user.dart';
import 'payment_screen.dart';

class PaymentThroughSub extends StatefulWidget {
  static const routeName = '/paymentThroughSub';

  @override
  _PaymentThroughSubState createState() => _PaymentThroughSubState();
}

class _PaymentThroughSubState extends State<PaymentThroughSub> {
  late Map<String, dynamic> selectedSubData;
  bool terms = false;
  bool privacy = false;
  late User user;

  List<Widget> getdetails(String details) {
    return details
        .split(',')
        .map((e) => Text(
              e,
              style: TextStyle(color: Colors.white),
            ))
        .toList();
  }

  @override
  void initState() {
    user = Provider.of<UserDataProvider>(context, listen: false).user;
    super.initState();
  }

  /* void callBackFromPaymentSuccess(subId, subamount) {
    Provider.of<PaymentProvider>(context, listen: false)
        .paymentDone(subId, subamount)
        .then((_) {
      Provider.of<UserDataProvider>(context, listen: false)
          .fetechUserData()
          .then((_) => Navigator.of(context).pop());
    });
  }*/

  void callBackFromPaymentFailure(String message) {
    Navigator.of(context).pop();
    ShowAlert().showAlert(context, 'Alert', message);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    selectedSubData = data['subdata'];
    List<Color> _colors = data['colors'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 60, right: 10, left: 10),
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors:
                      _colors, //Color(0xFFE4E2E5), Color(0xFFe5e4e2), Color(0xFFe2e5e4)
                  begin: Alignment.center,
                  end: Alignment.center,
                  stops: [0.4, 0.6, 1]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      '${selectedSubData['Subscription']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  '\$ ${selectedSubData['prise']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                Column(
                  children: getdetails(selectedSubData['details']),
                ),
                Spacer(),
                Row(
                  children: [
                    Checkbox(
                      value: terms,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            terms = value;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 5),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                PolicyDialog(fileName: 'TNC.txt'),
                          );
                        },
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: privacy,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            privacy = value;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              PolicyDialog(fileName: 'privacyPolicy.txt'),
                        );
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    if (terms && privacy) {
                      Provider.of<PaymentProvider>(context, listen: false)
                          .newPaymentSub(selectedSubData['priority'],
                              selectedSubData['prise'])
                          .then((_) {
                        Navigator.of(context)
                            .pushNamed(PaymentScreen.routeName);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please accept Terms & Conditions and Privacy Policy'),
                        ),
                      );
                    }
                  },
                  child: const Text('Subscribe'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
