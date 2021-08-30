import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prediction_app/widgets/noInternet.dart';

import '../utils/constants.dart';

class HelpPdfViewer extends StatefulWidget {
  static const routeName = './helpPdfView';

  @override
  _HelpPdfViewerState createState() => _HelpPdfViewerState();
}

class _HelpPdfViewerState extends State<HelpPdfViewer> {
  Uri uri = Uri.http(baseUrl, helpPdfPath);
  Uint8List? pdfdata;
  Completer<File> completer = Completer();
  String? filepath;

  /* Future<String> loadAsset() async {
    String path = 'assets/pdfs/qna.pdf';
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    final filename = 'myoffice.pdf'; //basename(path);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
    await completer.future.then((value) => filepath = value.path);
    return filepath;
  }*/

  Future<String?> loadNetwork() async {
    String? filePath;
    try {
      await http.get(uri).then((response) async {
        final bytes = response.bodyBytes;
        pdfdata = bytes;
        final filename = basename('http://$baseUrl$helpPdfPath');
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);

        await completer.future.then((value) {
          filePath = value.path;
        });
      });
    } on SocketException catch (_) {
      print('no internet');
      filePath = '';
      throw 'No internet';
    } catch (e) {
      print(e);
    }
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    final Completer<PDFViewController> _controller =
        Completer<PDFViewController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: FutureBuilder(
        future: loadNetwork(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              snapshot.data == '' ||
              snapshot.data == null) {
            if (snapshot.error == 'No internet') {
              return NoInternet();
            }
            return Center(
              child: Text('Something went wrong please try later.'),
            );
          }
          return PDFView(
            nightMode: true,
            filePath: snapshot.data as String,
            pdfData: pdfdata,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            fitPolicy: FitPolicy.BOTH,
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onError: (error) {
              print('from pdf viewer');
              print(error.toString());
            },
            onPageError: (page, error) {
              print('from pdf viewer');
              print('$page: ${error.toString()}');
            },
          );
        },
      ),
    );
  }
}
