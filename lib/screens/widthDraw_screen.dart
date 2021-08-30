import 'package:flutter/material.dart';
import '../provider/bankDetails.dart';
import 'package:provider/provider.dart';
import './profileBankDetails.dart';
import '../widgets/bankDetailsView.dart';
import '../utils/showAlert.dart';
import '../widgets/noInternet.dart';

class WithDraw extends StatefulWidget {
  static const routeName = '/widthDrawScreen';

  const WithDraw({Key? key}) : super(key: key);

  @override
  _WithDrawState createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  var future;
  late Future bankDetails;
  String totalBal = '0';
  bool _enable = true;
  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    future = Provider.of<BankDetails>(context, listen: false);
    bankDetails = future.getBankDetails();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    totalBal = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  // void checkData() {
  //   Provider.of<BankDetails>(context).getBankDetails().then((data) {
  //     if(data['Name'])
  //   });
  // }

  void onBankDetailsUpdate() {
    setState(
      () {
        future.changeCallStatus();
        bankDetails = future.getBankDetails();
      },
    );
  }

  String obscureText(String accountNo) {
    return '*' * (accountNo.length - 4) +
        accountNo.substring(accountNo.length - 4);
  }

  void _onSubmited() {
    double? _amount = double.tryParse(myController.text);
    String bal = totalBal.replaceAll(RegExp(r'\$'), '');
    double? _totalbal = double.tryParse(bal);
    print(_amount);
    if (_amount == null ||
        _totalbal == null ||
        _totalbal < _amount ||
        _amount.isNegative) {
      ShowAlert().showAlert(context, 'Alert',
          'Please enter the amount less than the total avalible balance');
    } else {
      future.addNewWithdraw(totalBal.replaceAll(RegExp(r'\$'), '')).then(
        (responce) {
          String message;
          if (responce) {
            message = 'Request for withdraw is sent';
          } else {
            message = 'Request has already made please wait 24 hours';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WithDraw'),
      ),
      body: FutureBuilder(
        future: bankDetails,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error == 'No internet') {
              return NoInternet();
            }
            return Center(
              child: Text('Something went wrong please try later'),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
            if (data['name'] == '' && data['account_no'] == '') {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please Provider Your Bank Details to WithDraw amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      future.changeCallStatus();
                      Navigator.of(context)
                          .pushNamed(ProfileBankDetails.routeName,
                              arguments: true)
                          .then(
                        (_) {
                          onBankDetailsUpdate();
                        },
                      );
                    },
                    child: Text('Give Bank Details'),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Drawable Amount $totalBal',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  BankDetailsView(
                    name: data['name'],
                    accountNo: obscureText(data['account_no']),
                    bankName: data['bank_name'],
                    branch: data['branch'],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: myController,
                      decoration: InputDecoration(
                        helperText: 'Enter the amount',
                      ),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _enable
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.5, 50),
                          ),
                          onPressed: () {
                            _onSubmited();
                          },
                          child: Text(
                            'Withdraw',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: RichText(
                      text: TextSpan(
                        text: 'Note :',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                        children: [
                          TextSpan(
                            text:
                                ' Amount withdraw will be processed and takes 24 hours.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
