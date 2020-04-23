import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Notifications",
      home: MainApp(),
    );
  }
}


class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
    String _title = '';
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    setUpMessaging();
  }

  void setUpMessaging() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() {
        _title = message['notification']['title'];
        _message = message['notification']['body'];

      });

    }, onResume: (Map<String, dynamic> message) async {

    }, onLaunch: (Map<String, dynamic> message) async {

    });

    FlutterError.onError = null;
    _firebaseMessaging.getToken().then((token) => print("tokenkey: " + token));
    _firebaseMessaging.subscribeToTopic("");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Notifications"),
        
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: Text("Waiting for notifications"),


        ),
      ),
    );
  }
}