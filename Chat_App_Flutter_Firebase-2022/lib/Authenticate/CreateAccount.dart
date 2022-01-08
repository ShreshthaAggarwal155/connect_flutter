import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/tabs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Screens/HomeScreen.dart';
import 'google_screen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

/*class GoogleSignInProvider extends ChangeNotifier{
  final GoogleSignIn = GoogleSignIn();
}*/
class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 30,
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  Image.asset('images/logo.png', width: 130, height: 130),
                  SizedBox(
                    height: size.height / 45,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Sign Up!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Name", Icons.account_box, _name),
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "E-mail", Icons.account_box, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Password", Icons.lock, _password),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 25,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 100,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      //primary: Color.fromRGBO(220, 53, 69, 0.8),
                      primary: Colors.blueAccent,
                      onPrimary: Colors.black,
                      minimumSize: Size(50, 50),
                    ),
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.black),
                    label: Text('Sign Up with Google',
                        style: TextStyle(color: Colors.grey[300])),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                      //Navigator.pushNamed(context, GoogleScreen.id);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ConnectTabs()));
                    },
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
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
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ConnectTabs()));
              print("Account Created Sucessfull");
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please enter Fields");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // color: Color.fromRGBO(220, 53, 69, 0.8),
              color: Colors.blueAccent),
          alignment: Alignment.center,
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        style: TextStyle(color: Colors.grey[400]),
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
