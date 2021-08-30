import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../payment/payment_screen.dart';
import '../payment/paymentThroughSub.dart';
import '../../models/user.dart';
import '../../provider/paymentProvider.dart';
import '../../provider/subscriptionProvider.dart';
import '../../provider/userDataProvider.dart';

class SubscriptionCards extends StatefulWidget {
  @override
  _SubscriptionCardsState createState() => _SubscriptionCardsState();
}

class _SubscriptionCardsState extends State<SubscriptionCards>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late User user;
  var subscriptionFuture;
  late int currentSubpro;

  void findSubType(List<dynamic> sub) {
    sub.forEach((element) {
      if (element['Subscription'] == user.subscription) {
        currentSubpro = int.tryParse(element['priority']) ?? 100;
      }
    });
  }

  Map<String, dynamic> getopaNText(Map<String, dynamic> sub) {
    DateTime userDate = DateTime.parse(user.subStartDate!);
    Map<String, dynamic> opaNText = {
      'opacity': 0.0,
      'text': '',
    };
    if (sub['Subscription'] == user.subscription) {
      opaNText['opacity'] = 0.0;
      opaNText['text'] =
          '${DateFormat.yMMMd().format(DateTime(userDate.year, userDate.month + int.parse(sub['Duration']), userDate.day))}';
    } else if (int.tryParse(sub['priority'])! > currentSubpro) {
      opaNText['opacity'] = 1.0;
      opaNText['text'] = '';
    } else if (int.tryParse(sub['priority'])! < currentSubpro) {
      opaNText['opacity'] = 0.0;
      opaNText['text'] = 'upgrade';
    }
    return opaNText;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    subscriptionFuture =
        Provider.of<SubsciptionProvider>(context, listen: false).fetchSubData();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserDataProvider>(context).user;
    return FutureBuilder(
      future: subscriptionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != []) {
          List<dynamic> data = snapshot.data! as List<dynamic>;
          findSubType(data);
          return ListView.builder(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final int count = data.length > 10 ? 10 : data.length;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController!.forward();
              return SingleSub(
                key: ValueKey(index),
                subData: data[index],
                animation: animation,
                animationController: animationController,
                opaNText: user.isSubscribed == 0
                    ? {
                        'opacity': 0.0,
                        'text': 'upgrade',
                      }
                    : getopaNText(data[index]),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

class SingleSub extends StatelessWidget {
  final Key? key;
  final Map<String, dynamic> subData;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;
  final Map<String, dynamic> opaNText;

  SingleSub({
    this.key,
    required this.subData,
    this.animationController,
    this.animation,
    required this.opaNText,
  });

  final Map<String, dynamic> cardImages = {
    'Platinum': 'assets/images/platinumStar.png',
    'Gold': 'assets/images/goldStar.png',
    'Silver': 'assets/images/silverStar.png',
    'other': 'assets/images/bronzStar.png',
  };

  final Map<String, dynamic> cardColors = {
    'Platinum': [Colors.blue, Colors.blue.shade300, Colors.blue.shade100],
    'Gold': [Colors.teal, Colors.teal.shade300, Colors.teal.shade100],
    'Silver': [Colors.pink, Colors.pink.shade300, Colors.pink.shade100],
    'other': [Colors.cyan, Colors.cyan.shade300, Colors.cyan.shade100],
  };

  getImageColor(Map<String, dynamic> map, String? subtype) {
    if (map.containsKey(subtype)) {
      return map[subtype!];
    } else {
      return map['other'];
    }
  }

  List<Widget> getdetails(String details) {
    return details
        .split(',')
        .map((e) => Text(
              '• $e',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                letterSpacing: 0.2,
                color: Colors.white,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      key: key,
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          key: key,
          opacity: animation as Animation<double>,
          child: Transform(
            key: key,
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: Stack(
              key: key,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed(PaymentThroughSub.routeName,
                    //     arguments: subData);
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
                        .checkPrevSub(subData['priority'])
                        .then((result) {
                      result
                          ? Navigator.of(context)
                              .pushNamed(PaymentScreen.routeName)
                              .then((value) => Navigator.pop(dialogcontext))
                          : Navigator.of(context).pushNamed(
                              PaymentThroughSub.routeName,
                              arguments: {
                                  'subdata': subData,
                                  'colors': getImageColor(
                                      cardColors, subData['Subscription'])
                                }).then(
                              (value) => Navigator.pop(dialogcontext));
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.only(
                        top: 50, left: 10, right: 7, bottom: 10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(40),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: getImageColor(
                              cardColors, subData['Subscription'])),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1.1, 4.0),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subData['Subscription'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...getdetails(subData['details']),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                opaNText['text'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 * 0.5,
                    height: MediaQuery.of(context).size.width / 3 * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white60.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: -2,
                  left: -6,
                  child: SizedBox(
                    width: 70,
                    height: 60,
                    child: Image.asset(
                      getImageColor(cardImages, subData['Subscription']),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

/*
 BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: opaNText['opacity'],
                        sigmaY: opaNText['opacity']),
 
 */
