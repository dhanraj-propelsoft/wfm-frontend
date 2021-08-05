import 'package:flutter/material.dart';
import 'package:propel/Settings/MySettings.dart';
import 'package:propel/Settings/OrganizationSettings.dart';
import 'package:propel/Settings/Profile.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/splash_img.jpg'),
                  ),
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Nova P Felix")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("9443447755")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("felix@propelsoft.in"))
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_sharp)
                ],
              ),
            ),
            Divider(),
            ListTile(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => MySettings(
                        )));
              },
              title: Text("My Setting"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            ListTile(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => OrganizationSettings(
                        )));
              },
              title: Text("Organizations Setting"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            ListTile(
              title: Text("Refer a Friends"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            Image(width: 200,
                height: 200,
                image: AssetImage('/about_image.png'))
            // AssetImage('/about_image.png'),

          ],
        ),
      ),
    );
  }
}
