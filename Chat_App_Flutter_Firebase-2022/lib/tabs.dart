import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(ConnectTabs());
}

class ConnectTabs extends StatefulWidget {
  @override
  State<ConnectTabs> createState() => _ConnectTabsState();
}

class _ConnectTabsState extends State<ConnectTabs> {
  bool isLoading = false;
  double MyLatitude = 0;
  double MyLongitude = 0;

  Map<String, dynamic> userMap = {};

  List userLocations = [];

  Map<String, dynamic> userloc = {};

  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    print("Hello world");
    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) => {
              setState(() {
                userMap = value.docs[0].data();
                isLoading = false;
                print(value);
              })
            });
  }

  void findUsersLocation() async {
    setState(() {
      isLoading = true;
    });
    print("Hello world");
    await _firestore.collection('location').get().then((value) => {
          setState(() {
            List locations = [];
            for (int i = 0; i < value.docs.length; i++) {
              print(value.docs[i].data());
              userloc = value.docs[i].data();

              String mail = userloc['user'];
              double longitude = userloc['longitude'];
              double latitude = userloc['latitude'];
              print(mail);
              print(longitude);
              locations.add({
                "email": mail,
                "longitude": longitude.toString(),
                "latitude": latitude.toString(),
                "distance": Geolocator.distanceBetween(
                    MyLatitude, MyLongitude, latitude, longitude)
              });
            }
            userLocations = locations;
            isLoading = false;
            // print(userLocations);
          })
        });
  }

  List<Widget> generateNearby() {
    List<Widget> nearby = [];
    int distance = 0;
    userLocations.toSet().toList();
    print(userLocations.length);
    for (int i = 0; i < userLocations.length; i++) {
      distance = userLocations[i]['distance'].toInt();
      distance != 0
          ? nearby.add(
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {},
                  // ignore: prefer_const_constructors
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.black,
                  ),
                  title: Text(userLocations[i]['email']),
                  subtitle: Text(distance.toString() + " mts away"),
                  tileColor: Colors.lightBlueAccent,
                  trailing: Icon(
                    Icons.chat,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : print("Hello");
    }

    return nearby;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future getCurrentUser() async {
      User? user = await _auth.currentUser;

      if (user != null) {
        print(user.email);
        return user.email;
      }
    }

    void getLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(position);

        await _firestore
            .collection('location')
            .doc(_auth.currentUser!.uid)
            .set({
          "longitude": position.longitude,
          "latitude": position.latitude,
          "user": await getCurrentUser()
        });
        MyLatitude = position.latitude;
        MyLongitude = position.longitude;
      } catch (e) {
        print(e);
      }
    }

    List<PopupMenuItem<Widget>> dropDownItems = [
      PopupMenuItem(
          child: GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage())),
        child: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      )),
      PopupMenuItem(
          child: TextButton(
              onPressed: () {
                getLocation();
              },
              child: Text("Enable"))),
      PopupMenuItem(
          child: TextButton(
        child: Text("Find"),
        onPressed: () {
          findUsersLocation();
        },
      )),
      PopupMenuItem(
          child: IconButton(
        color: Colors.blue,
        icon: Icon(Icons.logout),
        onPressed: () => logOut(context),
        // async {
        //   await _firestore
        //       .collection('location')
        //       .doc(_auth.currentUser!.uid)
        //       .set({
        //     "longitude": '0.0',
        //     "latitude": '0.0',
        //     "user": await getCurrentUser()
        //   });
        //   logOut(context);
        // }),
      )),
    ];
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            // backgroundColor: Color.fromRGBO(232, 78, 54, 1),
            backgroundColor: Colors.blueAccent,
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => dropDownItems,
                onSelected: (item) {
                  print(item);
                },
              )
            ],
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Around You',
                ),
                Tab(
                  text: 'Chat',
                ),
                Tab(text: 'Friends'),
              ],
            ),
            title: const Text('Connect'),
          ),
          body: TabBarView(
            children: [
              Scaffold(
                  backgroundColor: Colors.black,
                  body: isLoading
                      ? Center(
                          child: Container(
                            height: size.height / 20,
                            width: size.height / 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Scrollbar(
                            child: ListView(
                                itemExtent: 100, children: generateNearby()),
                          ),
                        )),
              HomeScreen(),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
