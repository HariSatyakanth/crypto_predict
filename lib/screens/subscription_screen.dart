import 'package:flutter/material.dart';
import 'package:prediction_app/provider/paymentProvider.dart';
import 'package:prediction_app/screens/payment/paymentThroughSub.dart';
import 'package:prediction_app/screens/payment/payment_screen.dart';

import 'package:provider/provider.dart';
import '../provider/subscriptionProvider.dart';

class Subscription extends StatefulWidget {
  static const routeName = '/subscription';

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List<Widget> getdetails(String details) {
    return details
        .split(',')
        .map((e) => Text(
              e,
              style: TextStyle(color: Colors.white),
            ))
        .toList();
  }

  final Map<String, dynamic> cardColors = {
    'Platinum': [Colors.blue, Colors.blue.shade300, Colors.blue.shade100],
    'Gold': [Colors.teal, Colors.teal.shade300, Colors.teal.shade100],
    'Silver': [Colors.pink, Colors.pink.shade300, Colors.pink.shade100],
    'other': [Colors.cyan, Colors.cyan.shade300, Colors.cyan.shade100],
  };

  List<Color> getColors(Map<String, dynamic> map, String? subtype) {
    if (map.containsKey(subtype)) {
      return map[subtype!];
    } else {
      return map['other'];
    }
  }

  Widget buildCard(context, Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                colors: getColors(cardColors, data['Subscription']),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 0.8, 1]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '\$ ${data['prise']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  ),
                ),
              ),
              Text(
                data['Subscription'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
              Column(
                children: getdetails(data['details']),
              ),
              GestureDetector(
                onTap: () {
                  late BuildContext dialogcontext;
                  showDialog(
                      context: context,
                      builder: (context) {
                        dialogcontext = context;
                        return AlertDialog(
                          title: const Text('Fetching details'),
                          content: Container(
                            width: 50,
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      });
                  Provider.of<PaymentProvider>(context, listen: false)
                      .checkPrevSub(data['priority'])
                      .then(
                    (result) {
                      result
                          ? Navigator.of(context)
                              .pushNamed(PaymentScreen.routeName)
                              .then((value) => Navigator.pop(dialogcontext))
                          : Navigator.of(context).pushNamed(
                              PaymentThroughSub.routeName,
                              arguments: {
                                  'subdata': data,
                                  'colors': getColors(
                                      cardColors, data['Subscription'])
                                }).then(
                              (value) => Navigator.pop(dialogcontext));
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: const Text('Subscribe'),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getwidget(List<dynamic> data) {
    data = data.reversed.toList();
    return Column(
      children: data.map((e) => buildCard(context, e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Subscriptions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<SubsciptionProvider>(context).fetchSubData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<dynamic> data = snapshot.data! as List<dynamic>;
            return SingleChildScrollView(
              child: getwidget(data),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
/*

Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 40, right: 10, left: 10),
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFffd700),
                      Color(0xFFffe34c),
                      Color(0xFFffeb7f)
                    ], //Color(0xFFE4E2E5), Color(0xFFe5e4e2), Color(0xFFe2e5e4)
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                        '\$ 100',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ),
                  ),
                  Text(
                    'Platinum',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text('1 Year Subscription'),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Voice support'),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 30,
            left: 120,
            right: 120,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: Text('Subscribe')))
      ],
    ); */
