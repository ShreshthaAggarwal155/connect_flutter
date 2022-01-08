import 'package:chat_app/main.dart';
import 'package:chat_app/Authenticate/Autheticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

const timeDilation = 3.0;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
      upperBound: 1,
    );

    controller.forward();
    // animation.addStatusListener((status) {});

    controller.addListener(() {
      setState(() {});
      print(controller.value);
      print(animation.value);
    });

    // animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(animation.value),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/connect_logo.png'),
                        height: 60, /*controller.value*/
                      ),
                    ),
                    SizedBox(
                      width: 250.0,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 50.0,
                          fontFamily: 'Bobbers',
                          color: Colors.grey,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText('Connect'),
                          ],
                          repeatForever: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => Authenticate())),
                        child: Text(
                          "Skip >>",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ])),
    );
  }
}
