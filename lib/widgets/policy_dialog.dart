import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

class PolicyDialog extends StatelessWidget {
  final double radius;
  final String fileName;

  PolicyDialog({
    Key? key,
    this.radius = 8,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future:
                  Future.delayed(Duration(milliseconds: 150)).then((_) async {
                return await rootBundle.loadString('assets/policies/$fileName');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      child: snapshot.data != null
                          ? Text(
                              snapshot.data as String,
                            )
                          : Text(''),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              primary: Theme.of(context).buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Text(
                "CLOSE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textButtoncolor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
