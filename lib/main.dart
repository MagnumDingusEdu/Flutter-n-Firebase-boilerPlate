import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Notifications",
      color: Colors.red,
      theme: ThemeData(
        accentColor: Colors.red,
        brightness: Brightness.dark,
      ),
      home: MainApp(),
      debugShowCheckedModeBanner: false,
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
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: _title,
              description: _message,
            ),
          );
        },
        onResume: (Map<String, dynamic> message) async {},
        onLaunch: (Map<String, dynamic> message) async {});

    FlutterError.onError = null;
    _firebaseMessaging.getToken().then((token) => print("tokenkey: " + token));
    _firebaseMessaging.subscribeToTopic("hello");
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            title: Text(
              'Confirm Exit',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.0),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Are you sure you want to exit?\n"),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 16.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Stay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Leave',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Firebase Notifications"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(child: Text("Waiting for notifications....")),
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  String title, description;

  CustomDialog({
    @required this.title,
    @required this.description,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: Consts.padding,
                left: Consts.padding,
                right: Consts.padding,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Consts.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                radius: Consts.avatarRadius,
              ),
            ),
            //...bottom card part,
            //...top circlular image part,
          ],
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 40.0;
}

Widget _button(String text, void function(), bool canc) {
  return RaisedButton(
    highlightElevation: 0.0,
    splashColor: Colors.grey,
    elevation: 20.0,
    color: canc ? Colors.white : Colors.red,
    shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          color: canc ? Colors.black : Colors.white,
          fontSize: 20),
    ),
    onPressed: () {
      function();
    },
  );
}
