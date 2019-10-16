import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:workmanager/workmanager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print(
      "The background fetch was triggered  " + task + " time: " + DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return Future.value(true);
  });
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();

    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    if (Platform.isAndroid) {
      Workmanager.registerOneOffTask(
        "2",
        'Test',
        //inputData: inputData,
        initialDelay: Duration(seconds: 5),
      );
    }

    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/sample.pdf');

    setState(() => _isLoading = false);
  }

  changePDF(value) async {
    setState(() => _isLoading = true);
    if (value == 1) {
      document = await PDFDocument.fromAsset('assets/sample2.pdf');
    } else if (value == 2) {
      document = await PDFDocument.fromURL("http://conorlastowka.com/book/CitationNeededBook-Sample.pdf");
    } else {
      document = await PDFDocument.fromAsset('assets/sample.pdf');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(height: 36),
              ListTile(
                title: Text('Load from Assets'),
                onTap: () {
                  changePDF(1);
                },
              ),
              ListTile(
                title: Text('Load from URL'),
                onTap: () {
                  changePDF(2);
                },
              ),
              ListTile(
                title: Text('Restore default'),
                onTap: () {
                  changePDF(3);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('FlutterPluginPDFViewer'),
        ),
        body: Center(child: _isLoading ? Center(child: CircularProgressIndicator()) : PDFViewer(document: document)),
      ),
    );
  }
}
