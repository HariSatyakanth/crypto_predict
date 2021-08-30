import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:prediction_app/widgets/noInternet.dart';
import 'package:provider/provider.dart';

import '../provider/notificationProivder.dart';

class PublicNotification extends StatefulWidget {
  static const routeName = './publicNotifications';
  @override
  _PublicNotificationState createState() => _PublicNotificationState();
}

class _PublicNotificationState extends State<PublicNotification> {
  late var prodata;
  @override
  void initState() {
    startTimer(true);
    prodata = Provider.of<NotificationProvider>(context, listen: false);
    super.initState();
  }

  late Timer timer;

  void startTimer(bool init) {
    int duration = 30;
    if (init) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getpublicNotifications();
      duration += 15;
    }
    timer = Timer.periodic(Duration(seconds: duration), (timer) {
      duration = 30;
      Provider.of<NotificationProvider>(context, listen: false)
          .getpublicNotifications();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    prodata.disposeData();
    super.dispose();
  }

  Widget getTime(DateTime date) {
    List<String> dates =
        DateFormat('MMMM dd/hh:mm aaa').format(date).toString().split('/');
    return Column(
      children: [
        Text(
          dates[0],
          style: TextStyle(fontSize: 11),
        ),
        Text(
          dates[1],
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationData, _) {
          if (notificationData.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (notificationData.nointernet) {
            return NoInternet();
          }
          if (notificationData.notifications.isEmpty) {
            return const Center(
              child: Text(
                'No Notification Yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            reverse: true,
            itemCount: notificationData.notifications.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 0, bottom: 12, left: 5, right: 20),
                decoration: BoxDecoration(
                  color: Color(_getColorFromHex(
                          notificationData.notifications[index]['color']))
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationData.notifications[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              notificationData.notifications[index]['body'],
                            ),
                          ),
                          getTime(DateTime.tryParse(notificationData
                              .notifications[index]['createdAt'])!),
                        ],
                      ),
                      if (notificationData.notifications[index]['image'] !=
                          null)
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                imagePath +
                                    notificationData.notifications[index]
                                        ['image'],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
//  keytool -genkey -v -keystore D:\key\crypto-predict.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
