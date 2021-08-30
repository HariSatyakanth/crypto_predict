import 'package:flutter/material.dart';

class NotSubscribed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/NoIdea.jpg'),
              fit: BoxFit.contain),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Confused about which numbers to buy!!',
          style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.5)),
        ),
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: const Text(
          'Subscribe to one of the packages below, get your predicted numbers.',
        ),
      ),
      SizedBox(height: 5),
    ]);
  }
}
