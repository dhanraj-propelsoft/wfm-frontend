import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool theme = false;
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text("My Settings",style: TextStyle(color: Colors.black),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: Container(
        child: Column(
          children: [
            ExpansionTile(
              title: Text("Theme"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              children: [
                ListTile(
                  title: Text("Enable Dark Theme"),
                  trailing: Switch(
                    value: theme,
                    // onChanged: (bool value) => _onchanged(value),
                    onChanged: (bool value){
                      setState(() {
                        theme = value;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.red,
                  ),
                )
              ],
            ),
            ListTile(
              title: Text("Notifications"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            ListTile(
              title: Text("Message"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            )
          ],
        ),
      ),
    );
  }
}
