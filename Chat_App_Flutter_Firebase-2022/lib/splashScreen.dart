import 'dart:async';
import 'package:chat_app/Authenticate/LoginScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplashScreen> {
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromRGBO(232, 78, 54, 1),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: Image.asset('images/Connect.jpg')),
                // CircularProgressIndicator(
                //   backgroundColor: Colors.white,
                //   strokeWidth: 1,
                // )
              ]),
        ));
  }
}
