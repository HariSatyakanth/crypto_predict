import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../provider/userDataProvider.dart';
import './appdrawer.dart';
import '../provider/userDataProvider.dart';

class ReferalScreen extends StatelessWidget {
  static const routeName = './referalScreen';

  _onShare(BuildContext context, String referalCode) async {
    /* final ByteData bytes =
        await rootBundle.load('assets/images/numerology.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/numerology.png').create();
    file.writeAsBytesSync(list);*/

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    List<String> imagePaths = []; //file.path
    String playstoreLink =
        Provider.of<UserDataProvider>(context, listen: false).playStoreLink;

    String text =
        'install the apply\n$playstoreLink \n Use This Referal code $referalCode';
    String subject = 'Share and earn';

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    String referalCode =
        Provider.of<UserDataProvider>(context, listen: false).userRefereral;
    return Scaffold(
      //drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Refer and Earn'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/referAndEarn.png',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Refer and Earn',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Send a referral to link to you friends vis SMS/Email/Whatsapp...',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your Referal code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.black87.withOpacity(0.5)),
              ),
              child: Text(
                referalCode,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 20),
                  padding: EdgeInsets.all(10),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                onPressed: () {
                  _onShare(context, referalCode);
                },
                child: const Text('Refer Now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
