import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.27,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                'assets/images/nointernet2.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Please check your network connetion and retry later.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
