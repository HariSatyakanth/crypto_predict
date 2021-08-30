import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediction_app/utils/constants.dart';
import 'package:prediction_app/widgets/noInternet.dart';
import '../provider/walletProvider.dart';
import 'package:provider/provider.dart';
import './widthDraw_screen.dart';

class MyWallet extends StatefulWidget {
  static const routeName = '/myWallet';
  const MyWallet({Key? key}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var prodata;
  var walletFuture;

  bool _inRout = true;

  String getImageLocation(String? type) {
    switch (type) {
      case 'Platinum':
        return 'assets/images/platinumStar.png';
      case 'Gold':
        return 'assets/images/goldStar.png';
      case 'Silver':
        return 'assets/images/silverStar.png';
    }
    return 'assets/images/bronzStar.png';
  }

  IconData _getIcons(String? type) {
    switch (type) {
      case 'Pending':
      case 'Approved':
      case 'KIV':
        return Icons.priority_high;
      case 'Successful':
        return Icons.done;
      case 'Disapproved':
        return Icons.clear;
    }
    return Icons.priority_high;
  }

  Color getColors(String? type) {
    switch (type) {
      case 'Platinum':
      case 'Gold':
      case 'Silver':
        return Colors.transparent;
      case 'Pending':
      case 'Approved':
      case 'KIV':
        return Colors.yellow.shade600;
      case 'Successful':
        return Colors.green;
      case 'Disapproved':
        return Colors.red;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    prodata = Provider.of<WalletProvider>(context, listen: false);
    walletFuture = prodata.getWalletData(_inRout);
    super.initState();
  }

  void _onClick() {
    setState(() {
      _inRout = !_inRout;
      walletFuture = prodata.getWalletData(_inRout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: primarycolor,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/wallet.png'),
                  ),
                ),
              ),
              Text(
                'Total Balance',
                style: TextStyle(
                    fontSize: 15, color: Colors.white.withOpacity(0.7)),
              ),
              Consumer<WalletProvider>(
                builder: (context, snapshot, _) {
                  return Column(
                    children: [
                      Text(
                        snapshot.totBal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.orangeAccent),
                        label: Text(
                          'Withdraw',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(WithDraw.routeName,
                              arguments: snapshot.totBal);
                        },
                        icon: Icon(Icons.south_west, color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width / 2.3,
                                      20),
                                  primary: _inRout
                                      ? primarycolor
                                      : Colors.transparent),
                              onPressed: _onClick,
                              child: Text('Received'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: !_inRout
                                    ? primarycolor
                                    : Colors.transparent,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width / 2.3,
                                    20),
                              ),
                              onPressed: _onClick,
                              child: Text('Sent'),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder(
                          future: walletFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  widthFactor: 20,
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              if (snapshot.error == 'No internet') {
                                return NoInternet();
                              }
                              return Center(
                                child: Text(
                                    'Something went wrong please try later'),
                              );
                            }
                            if (snapshot.data != null &&
                                (snapshot.data as List<dynamic>).isNotEmpty) {
                              List<dynamic> data =
                                  snapshot.data as List<dynamic>;
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return _dataBuilder(data[index]);
                                },
                              );
                            }
                            return Center(
                              child: Text('No data to view'),
                            );
                          },
                        ),
                      )
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

  Widget _dataBuilder(singledata) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: getColors(singledata['type']),
        child: _inRout
            ? Image.asset(getImageLocation(singledata['type']))
            : Icon(
                _getIcons(singledata['type']),
                color: Colors.white,
                size: 28,
              ),
      ),
      title: Text(
        singledata['title'],
        style: TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        DateFormat.yMMMd()
            .format(DateTime.parse(singledata['time']))
            .toString(),
        style: TextStyle(
          fontSize: 13,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
      trailing: _inRout
          ? Text(singledata["amount"],
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.w600))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  singledata["amount"],
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                Text(singledata['type'])
              ],
            ),
    );
  }
}
