import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prediction_app/provider/coinDataProvider.dart';
import 'package:prediction_app/provider/membersProvider.dart';
import 'package:prediction_app/provider/walletProvider.dart';
import 'package:prediction_app/screens/users.dart';
import 'package:prediction_app/screens/usersUsers.dart';
import 'package:prediction_app/screens/webView.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:provider/provider.dart';

import './provider/predictedNumbersProvider.dart';
import './screens/homeScreen/home_screen.dart';
import './screens/subscription_screen.dart';
import './screens/login_screen.dart';
import './provider/userDataProvider.dart';
import './provider/resultProvider.dart';
import './provider/paymentProvider.dart';
import './screens/profile_screen.dart';
import './screens/history_screen.dart';
import './provider/subscriptionProvider.dart';
import './provider/histioryDataProvider.dart';
import './screens/payment/paymentThroughSub.dart';
import './screens/referal_screen.dart';
import './screens/payment/payment_screen.dart';
import './screens/helpPdfScreen.dart';
import './screens/userNotification_screen.dart';
import './provider/notificationProivder.dart';
import './screens/publicNotifications_screen.dart';
import './screens/myWallet_screen.dart';
import './provider/walletProvider.dart';
import './screens/profileBankDetails.dart';
import './provider/bankDetails.dart';
import './screens/widthDraw_screen.dart';
import 'screens/forgotpasswordScreen.dart';
import './screens/resetPasswordScreen.dart';
import './provider/coinDataProvider.dart';

AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

tokenRefresh(context) {
  FirebaseMessaging.instance.onTokenRefresh.listen(
    (newtoken) async {
      Provider.of<UserDataProvider>(context, listen: false).userToken(newtoken);
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeData theme = ThemeData(
    fontFamily: 'Poppins',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(elevatedButtonColor),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: primarycolor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textButtoncolor),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
            create: (_) => UserDataProvider()),
        ChangeNotifierProvider<ResultProvider>(
          create: (_) => ResultProvider(),
        ),
        ChangeNotifierProvider<SubsciptionProvider>(
          create: (_) => SubsciptionProvider(),
        ),
        ChangeNotifierProvider<HistoryDataProvider>(
          create: (_) => HistoryDataProvider(),
        ),
        ChangeNotifierProvider<PredictedNumbersProvider>(
          create: (_) => PredictedNumbersProvider(),
        ),
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<WalletProvider>(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider<BankDetails>(
          create: (_) => BankDetails(),
        ),
        ChangeNotifierProvider<CoinDataProvider>(
          create: (_) => CoinDataProvider(),
        ),
        ChangeNotifierProvider<MembersProvider>(
          create: (_) => MembersProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        title: 'Crypto Predict',
        color: primarycolor,
        theme: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(primary: primarycolor, secondary: accentcolor)),
        routes: {
          HomeScreen.routename: (ctx) => HomeScreen(),
          LoginScreen.routename: (ctx) => LoginScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          Subscription.routeName: (ctx) => Subscription(),
          HistoryScreen.routeName: (ctx) => HistoryScreen(),
          PaymentThroughSub.routeName: (ctx) => PaymentThroughSub(),
          ReferalScreen.routeName: (ctx) => ReferalScreen(),
          PaymentScreen.routeName: (ctx) => PaymentScreen(),
          HelpPdfViewer.routeName: (ctx) => HelpPdfViewer(),
          UserNotification.routeName: (ctx) => UserNotification(),
          PublicNotification.routeName: (ctx) => PublicNotification(),
          MyWallet.routeName: (ctx) => MyWallet(),
          ProfileBankDetails.routeName: (ctx) => ProfileBankDetails(),
          WithDraw.routeName: (ctx) => WithDraw(),
          ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
          ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
          UsersScreen.routeName: (ctx) => UsersScreen(),
          WebViewContainer.routeName: (ctx) => WebViewContainer(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /* @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .changeNoficicationStatus(true);
    });

    super.initState();
  }*/
  // @override
  // void initState() {

  //   super.initState();
  // }

  Widget splash() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      //color: Colors.purple.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bitcoin.png')),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Powered by Taslasoft',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> wait() {
    return Future.delayed(Duration(seconds: 3));
  }

  Widget handleNetworkError() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/nointernet.png')),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'No Internet...',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: const Text(
                  'Please make sure you have good network and try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 100),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  side: BorderSide(color: Colors.white, width: 1),
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Retry'),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait(
          [userProvider.getUserId(), userProvider.fetechUserData(), wait()],
        ),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return splash();
          } else if (snapshot.hasError) {
            return handleNetworkError();
          }
          List<dynamic> data = snapshot.data as List<dynamic>;
          return data[0] == '' ? LoginScreen() : HomeScreen();
        }),
      ),
    );
  }
}

/*ThemeData(
          primaryColor: Colors.yellow[900],
          accentColor: Colors.orangeAccent[400],
          fontFamily: 'Poppins',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(elevatedButtonColor),
            ),
          ),

          iconTheme: IconThemeData(color: Colors.white),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(textButtoncolor),
            ),
          ),
        ), */
