import 'package:flutter/material.dart';
import 'package:prediction_app/screens/homeScreen/home_screen.dart';
import 'package:prediction_app/screens/profile_screen.dart';
import 'package:prediction_app/screens/subscription_screen.dart';
import 'package:prediction_app/screens/users.dart';
import 'package:prediction_app/screens/webView.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../provider/userDataProvider.dart';
import './login_screen.dart';
import './referal_screen.dart';
import './publicNotifications_screen.dart';
import '../utils/constants.dart';
import '../screens/myWallet_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserDataProvider>(context, listen: false);
    return Drawer(
      elevation: 20.0,
      child: Column(
        children: <Widget>[
          Consumer<UserDataProvider>(builder: (context, userData, _) {
            return DrawerHeader(
              decoration: BoxDecoration(color: primarycolor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email', //userData.user.fullName
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, ProfileScreen.routeName)
                              .then((_) => userPro.image(''));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    userData.user.email,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
            /*  return UserAccountsDrawerHeader(
            accountName: Text(userData.user.firstName),
            accountEmail: Text('Edit Profile',style: TextStyle(color: Colors.blueAccent),),// Text(userData.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Text('Profile'),   
            ),
           onDetailsPressed: (){
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          );*/
          }),
          ListTile(
            //selected: _currentSelectedIndex == 0,
            // selectedTileColor: _currentSelectedIndex == 0
            //     ? Colors.orange.shade100
            //     : Colors.white,
            title: new Text('Home'),
            leading: new Icon(Icons.home, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              if (_currentSelectedIndex == 0) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushNamed(context, HomeScreen.routename)
                    .then((_) => Navigator.of(context).pop());
              }
            },
          ),
          // ListTile(
          //   //selected: _currentSelectedIndex == 1,
          //   // selectedTileColor: _currentSelectedIndex == 1
          //   //     ? Colors.orange.shade100
          //   //     : Colors.white,
          //   title: new Text('History'),
          //   leading:
          //       new Icon(Icons.history, color: primarycolor.withOpacity(0.8)),
          //   onTap: () {
          //     _currentSelectedIndex = 1;
          //     Navigator.pushNamed(context, HistoryScreen.routeName)
          //         .then((_) => Navigator.of(context).pop());
          //   },
          // ),
          ListTile(
            //selected: _currentSelectedIndex == 2,
            // selectedTileColor: _currentSelectedIndex == 2
            //     ? Colors.orange.shade100
            //     : Colors.white,
            title: new Text('Announcements'),
            leading:
                new Icon(Icons.message, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              _currentSelectedIndex = 2;
              Navigator.pushNamed(context, PublicNotification.routeName)
                  .then((_) => Navigator.of(context).pop());
            },
          ),
          ListTile(
            title: new Text('My Wallet'),
            leading: new Icon(Icons.account_balance_wallet_rounded,
                color: primarycolor.withOpacity(0.8)),
            onTap: () {
              Navigator.pushNamed(context, MyWallet.routeName);
            },
          ),
          ListTile(
            //selected: _currentSelectedIndex == 3,
            // selectedTileColor: _currentSelectedIndex == 3
            //     ? Colors.orange.shade100
            //     : Colors.white,
            title: new Text('Refer & Earn'),
            leading:
                new Icon(Icons.people, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              _currentSelectedIndex = 3;
              Navigator.pushNamed(context, ReferalScreen.routeName)
                  .then((_) => Navigator.of(context).pop());
            },
          ),
          ListTile(
            title: new Text('Members'),
            leading: Icon(Icons.person, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              Navigator.pushNamed(context, UsersScreen.routeName);
            },
          ),
          ListTile(
            title: new Text('Crypto News'),
            leading:
                Icon(Icons.subtitles, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              Navigator.pushNamed(context, WebViewContainer.routeName,
                  arguments: 'http://token.taslasoft.com/member');
            },
          ),
          ListTile(
            title: new Text('Subscriptions'),
            leading: Icon(Icons.loop, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              Navigator.pushNamed(context, Subscription.routeName);
            },
          ),
          ListTile(
            title: new Text('Stacking'),
            leading: Icon(Icons.circle, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              Navigator.pushNamed(context, WebViewContainer.routeName,
                  arguments: 'http://token.taslasoft.com/member/stacking');
            },
          ),
          /* ListTile(
            title: new Text('Help & Feedback'),
            leading: Icon(Icons.feedback),
          ),
          ListTile(
            title: new Text('About'),
            leading: Icon(Icons.youtube_searched_for_outlined),
          ),
         */
          ListTile(
            title: new Text('Logout'),
            leading:
                Icon(Icons.exit_to_app, color: primarycolor.withOpacity(0.8)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                        'You will not recive any notifications if you logout'),
                    actions: [
                      TextButton(
                        child: Text('yes'),
                        onPressed: () async {
                          userPro.disposeData();
                          SharedPreferences pre =
                              await SharedPreferences.getInstance();
                          pre.setString('UserId', '');
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.routename, (route) => false);
                        },
                      ),
                      TextButton(
                        child: Text('cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
