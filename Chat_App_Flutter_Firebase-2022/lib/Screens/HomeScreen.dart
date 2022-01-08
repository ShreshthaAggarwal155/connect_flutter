import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  //experimenting true with false
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List groupList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    getAvailableUsers();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  void getAvailableUsers() async {
    await _firestore
        .collection('users')
        //.where("name", isEqualTo: _auth.currentUser!.displayName!)
        .doc(_auth.currentUser!.uid)
        .collection('chatroom')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        //print(groupList);
        isLoading = false;
      });
    });
  }

  /*void getAvailableUsers() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('chatroom')
        .doc('chatRoomId')
        .collection('chats')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }*/

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    int a;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Chats"),
      //   actions: [
      //     IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
      //   ],
      // ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Row(
                  children: [
                    Container(
                      height: size.height / 14,
                      width: size.width,
                      alignment: Alignment.center,
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.15,
                        child: TextField(
                          style: TextStyle(color: Colors.grey[500]),
                          controller: _search,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: onSearch,
                                icon: Icon(Icons.search,
                                    color: Colors.grey[500])),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: onSearch,
                    //   child: Text("Search"),
                    // ),
                  ],
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () async {
                          String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['name']);
                          //String roomId = Uuid().v1();
                          await _firestore
                              .collection('users')
                              //.where("name", isEqualTo: _auth.currentUser!.displayName!)
                              .doc(_auth.currentUser!.uid)
                              .collection('chatroom')
                              .doc(roomId)
                              .set({
                            "id": roomId,
                            "user1": _auth.currentUser!.displayName!,
                            "user1_id": _auth.currentUser!.uid,
                            "user2": userMap!['name'],
                            "uid": userMap!['uid'],
                            "email": userMap!['email'],
                            "name": userMap!['name'],
                            "status": userMap!['status']
                          });
                          /*await _firestore
                              .collection('users')
                              .where("email", isEqualTo: _search.text)
                              .get()
                              .then((value) {
                            setState(() {
                              userMap = value.docs[0].data();
                              isLoading = false;
                            });
                            print(userMap);
                          });*/
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.account_box,
                            color: Colors.lightBlueAccent),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          userMap!['email'],
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        trailing:
                            Icon(Icons.chat, color: Colors.lightBlueAccent),
                      )
                    : Container(),
                /*SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Text('Hi'),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ;
                          },
                        )
                      ],
                    )),*/
                Text(
                  "Previous Chats",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: groupList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            String roomId = chatRoomId(
                                _auth.currentUser!.displayName!,
                                groupList[index]['name']);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: roomId,
                                  userMap: groupList[index].data(),
                                ),
                              ),
                            );
                          },
                          leading: Icon(Icons.account_box, color: Colors.white),
                          title: Text(
                            groupList[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            groupList[index]['email'],
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(Icons.chat, color: Colors.white),
                          //title: Text(groupList[index]['name']),
                        );
                      }),
                ),
              ],
              // ListView.builder(
              // itemCount: groupList.length,
              // itemBuilder: (context, index) {
              //   return ListTile(
              //     leading: Icon(Icons.chat),
              //     title: Text(groupList[index]['email0']),
              //   }
              // },
              // ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }

  //@override
  /*bool isLoading1 = false;
  Widget build1(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading1
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatRoom(
                        userMap: groupList[index]['name'],
                        chatRoomId: groupList[index]['id'],
                      ),
                    ),
                  ),
                  leading: Icon(Icons.chat),
                  title: Text(groupList[index]['email']),
                );
              },
            ),
    );
  }*/
}

/*import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  get membersList => null;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/*class CreateChat extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateChat({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateChat> createState() => _CreateChatState();
}*/

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool chatIdGenerated = false;
  late final List<Map<String, dynamic>> membersList;
  Map<String, dynamic>? userMap;
  //experimenting true with false
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List groupList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    //getAvailableUsers();
    createChatRoom();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  /*void getAvailableUsers() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('chatroom')
        .doc('chatRoomId')
        .collection('chats')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }*/

  Future<String> createChatRoom() async {
    setState(() {
      isLoading = true;
    });

    String chatId = Uuid().v1();

    await _firestore.collection('chatroom').doc(chatId).set({
      "members": widget.membersList,
      "id": chatId,
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chatroom')
          .doc(chatId)
          .set({
        "id": chatId,
      });
    }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }

    /*await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created This Group.",
      "type": "notify",
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);*/
    return chatId;
  }

  /*String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }*/

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    String chatId = "";
    final size = MediaQuery.of(context).size;
    isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        /*onTap: () {
                          String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['name']);
                          //String roomId = Uuid().v1();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },*/
                        onTap: () {
                          //createChatRoom();
                          !chatIdGenerated
                              ? chatId = createChatRoom() as String
                              : setState(() {
                                  chatIdGenerated = true;
                                });

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: chatId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.chat, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }

  //@override
  /*bool isLoading1 = false;
  Widget build1(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading1
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatRoom(
                        userMap: groupList[index]['name'],
                        chatRoomId: groupList[index]['id'],
                      ),
                    ),
                  ),
                  leading: Icon(Icons.chat),
                  title: Text(groupList[index]['email']),
                );
              },
            ),
    );
  }*/
}*/
