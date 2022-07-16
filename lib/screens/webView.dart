import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  static const String routeName = '/webview';

  WebViewContainer();
  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _key = UniqueKey();
  late bool isLoading;
  @override
  void initState() {
    isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? _url = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Crypto News'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
                onWebResourceError: (WebResourceError error) {
                  print('error=================>${error.errorType}');
                  print('error=================>${error.description}');
                },
                onPageFinished: (str) {
                  setState(() {
                    isLoading = false;
                  });
                },
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: _url),
            if (isLoading) Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
