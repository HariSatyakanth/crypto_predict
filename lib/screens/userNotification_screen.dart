import 'package:flutter/material.dart';
import 'package:http/retry.dart';

import 'package:intl/intl.dart';
import 'package:prediction_app/widgets/noInternet.dart';
import 'package:provider/provider.dart';

import '../provider/notificationProivder.dart';

class UserNotification extends StatefulWidget {
  static const routeName = './userNotification';

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  Future? notificationCall;

  @override
  void initState() {
    notificationCall = Provider.of<NotificationProvider>(context, listen: false)
        .getNotification();
    super.initState();
  }

  Widget getTime(DateTime date) {
    List<String> dates =
        DateFormat('MMMM dd/hh:mm aaa').format(date).toString().split('/');
    return Column(
      children: [
        Text(
          dates[0],
          style: TextStyle(fontSize: 13),
        ),
        Text(
          dates[1],
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Notification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: notificationCall,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error == 'No internet') {
              return NoInternet();
            }
            return Center(
                child: Text('Something went wrong please try later.'));
          }
          if (snapshot.data != null &&
              (snapshot.data as List<dynamic>).length > 0) {
            List<dynamic> data = snapshot.data! as List<dynamic>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          data[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data[index]['body']),
                        trailing: getTime(
                            DateTime.tryParse(data[index]['createdAt'])!),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            );
          }
          return Center(
            child: const Text(
              'No Notifications Yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
