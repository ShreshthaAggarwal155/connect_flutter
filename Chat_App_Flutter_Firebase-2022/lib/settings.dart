import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo', home: MyHomePage(title: 'Settings'));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({required this.title});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            titleTextStyle: TextStyle(
              color: Colors.grey[700],
            ),
            // title: 'Section 1',
            tiles: [
              SettingsTile(
                title: 'Account',
                //subtitle: 'English',
                leading: Icon(Icons.assignment_ind),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Chats',
                //subtitle: 'English',
                leading: Icon(Icons.chat),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Notifications',
                //subtitle: 'English',
                leading: Icon(Icons.notifications),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Blocked list',
                //subtitle: 'English',
                leading: Icon(Icons.block),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'Airplane mode',
                leading: Icon(Icons.airplanemode_active),
                switchValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            titlePadding: EdgeInsets.all(20),
            //title: 'Section 2',
            tiles: [
              SettingsTile(
                title: 'Security',
                subtitle: 'Fingerprint',
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'dark theme',
                leading: Icon(Icons.phone_android),
                switchValue: false,
                onToggle: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
