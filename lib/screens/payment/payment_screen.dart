

import 'package:flutter/material.dart';
import 'package:prediction_app/provider/paymentProvider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = './paymentScreen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Widget _getText(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> bankDetails =
        Provider.of<PaymentProvider>(context, listen: false).bankDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Payable amount ${bankDetails['amount']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Note',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: '1. You',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                            text: ' MUST ',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: 'transfer exact amount as show above')
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: '2. Note down the',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                          text: ' Deposite Code ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(text: 'And give the code while transaction'),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: '3. The Deposit code is valid for',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                            text: ' 6 hours ',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'Once it expires, we do not guarantee to retrive your deposite amount')
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: '4. This code is valid for 1 transaction only.',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                            text: ' For your next deposit,we will generate '),
                        TextSpan(
                          text: 'New Deposite code',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Bank Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    children: [
                      _getText('Desposite code'),
                      _getText(bankDetails['depositeCode']),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    children: [
                      _getText('Account Holder Name'),
                      _getText(bankDetails['holderName'])
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    children: [
                      _getText('Account Number'),
                      _getText(bankDetails['AccountNumber'])
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    children: [
                      _getText('IFSC'),
                      _getText(bankDetails['Ifsc']),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'or Pay Using Upi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    _getText('Upi Id'),
                    _getText(bankDetails['upi']),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
