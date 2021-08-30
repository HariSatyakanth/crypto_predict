import 'package:flutter/material.dart';

class BankDetailsView extends StatelessWidget {
  final String name;
  final String bankName;
  final String accountNo;
  final String branch;
  const BankDetailsView(
      {Key? key,
      required this.name,
      required this.bankName,
      required this.accountNo,
      required this.branch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            top: -6,
            left: -4,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
                boxShadow: [
                  BoxShadow(color: Colors.white12, spreadRadius: 2.0),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -8,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.white12, offset: Offset(5, 5)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    bankName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    branch,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    accountNo,
                    style: TextStyle(
                        color: Colors.white, fontSize: 22, letterSpacing: 2.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
