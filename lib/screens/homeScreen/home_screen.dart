import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:prediction_app/screens/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/userDataProvider.dart';

import '../appdrawer.dart';
import '../../utils/constants.dart';
import '../helpPdfScreen.dart';
import '../../provider/notificationProivder.dart';

import '../../screens/userNotification_screen.dart';

import '../../provider/coinDataProvider.dart';

class HomeScreen extends StatefulWidget {
  static const routename = './homeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String imagepath = imagePath;

  //late AnimationController animationController;

  late Future<List<Newcoin>?> coinFuture;

  bool init = true;

  late Stream<List<Newcoin>> streamData;

  late var prodata;

  @override
  void initState() {
    tokenRefresh(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Provider.of<NotificationProvider>(context, listen: false)
          .changeNoficicationStatus(true);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
              playSound: true,
            ),
          ),
        );
      }
    });

    super.initState();
  }

  void subscribeToTheTopic(int isSubscribed) {
    if (isSubscribed == 1) {
      print('issubscribed');
      FirebaseMessaging.instance.subscribeToTopic("coinSubscription");
    }
  }

  @override
  void didChangeDependencies() {
    if (init) {
      getData();
      init = false;
    }
    streamData =
        Provider.of<CoinDataProvider>(context, listen: false).getStreamDate;
    prodata = Provider.of<CoinDataProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<void> getData() async {
    await Provider.of<CoinDataProvider>(context, listen: false)
        .getNewCoinsData();
  }

  String getSubDate(String? subStartDate, String? duration) {
    if (subStartDate != null && duration != null) {
      DateTime _now = DateTime.now();
      int dur = int.parse(duration);
      DateTime _date = DateFormat('yyyy-MM-dd').parse(subStartDate);
      _date = DateTime(_date.year, _date.month + dur, _date.day);
      Duration day = _now.difference(_date);
      if (day.inDays < 0) return '';
      return '${day.inDays} days remaining';
    }
    return '';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 4.3),
            child: Consumer<NotificationProvider>(
              builder: (context, notificationData, _) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                      ),
                      onPressed: () {
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .changeNoficicationStatus(false);
                        Navigator.of(context)
                            .pushNamed(UserNotification.routeName);
                      },
                    ),
                    if (notificationData.anynotification)
                      Positioned(
                        top: 12,
                        left: 28,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.purple),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.help,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(HelpPdfViewer.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              color: primarycolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Consumer<UserDataProvider>(
              builder: (context, userdata, _) {
                String? image = userdata.user.image;
                return Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.11,
                            backgroundColor: Colors.transparent,
                            backgroundImage: (image != '' && image != null
                                ? NetworkImage('$imagepath$image')
                                : AssetImage(
                                    'assets/images/avatar.png',
                                  )) as ImageProvider<Object>?,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userdata.user.fullName == ''
                                  ? CircularProgressIndicator()
                                  : Text(
                                      userdata.user.fullName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                              Text(
                                userdata.user.subscription,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                getSubDate(userdata.user.subStartDate,
                                    userdata.user.subDuration),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Welcome to Crypto Predict',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          Consumer<UserDataProvider>(
            builder: (context, user, _) {
              int isSubscribed = user.user.isSubscribed;
              subscribeToTheTopic(isSubscribed);
              return isSubscribed == 0
                  ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Subscription.routeName);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/subscribe.jpeg'))),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Coins of the day',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: getData,
                              child: StreamBuilder<List<Newcoin>>(
                                stream: streamData,
                                builder: (context,
                                    AsyncSnapshot<List<Newcoin>?> snapshot) {
                                  if (snapshot.hasData) {
                                    List<Newcoin>? list =
                                        snapshot.data?.reversed.toList();
                                    return list == null ||
                                            snapshot.data!.isEmpty
                                        ? ListView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            children: [
                                              Center(
                                                child: Text(
                                                    'No data \n Pull to refresh'),
                                              ),
                                            ],
                                          )
                                        : ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return buildCoinCard(list[index]);
                                            },
                                          );
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}

Widget buildCoinCard(Newcoin coin) {
  String coinsymbol = coin.coinSymbol != '' ? "(${coin.coinSymbol})" : '';
  String getDateTime(String dateTime) {
    DateTime datetime = DateTime.parse(dateTime);
    return DateFormat('dd-MM-yyyy HH:MM:ss').format(datetime).toString();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black26, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    getDateTime(coin.tradeStartTime),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coin Name :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${coin.coinName} $coinsymbol'),
                  Text(
                    '${coin.address}',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                    text: 'Platform :  ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                    children: [
                      TextSpan(
                          text: '${coin.platform}',
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Buy Price   :  ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                            children: [
                              TextSpan(
                                  text: '${coin.buyPrice}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Selling prise : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                            children: [
                              TextSpan(
                                  text: '${coin.sellingPrice}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'StopLoss: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                            children: [
                              TextSpan(
                                  text: '${coin.stopLoss}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ]),
                      ),
                    ],
                  ),
                  if (coin.icon != '')
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: CachedNetworkImage(
                        imageUrl: coin.icon,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
