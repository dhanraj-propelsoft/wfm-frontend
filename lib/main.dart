import 'package:flutter/material.dart';
import 'main_page.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:propel/wfm/task/add_task.dart';
import 'package:propel/wfm/task/task_details.dart';
import 'package:propel/wfm/task/task_list.dart';
import 'package:propel/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propel/wfm/masters/Project/add_project.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  bool theme = true;

  _getTheme() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    theme = localStorage.getBool('theme');

  }

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Propel WFM',
      // theme: ThemeData(
      //   primarySwatch: Colors.orange,
      //   // primaryColor: Colors.pink[800], //Changing this will change the color of the TabBar
      //   // accentColor: Colors.red,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      // theme: ThemeData.dark(),
      theme: theme?ThemeData.light():ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Splash2(),
      routes: <String,WidgetBuilder>{
        '/addTask':(BuildContext context)=>new AddTask(),
        '/addProject':(BuildContext context)=>new AddProject(),
      },

    );
  }
}

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new CheckAuth(),
      // title: Text('Ado Unbox',textScaleFactor: 2,style: TextStyle(color: Colors.orange,fontSize: 20.0),),
      image: Image(image: AssetImage('assets/splash_img.jpg')),
      loadingText: Text("Loading"),
      photoSize: 120.0,
      loaderColor: Colors.orange,
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {

  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }
  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = MainPage();
    } else {
      child = LoginPage();
      // child = Setting();
    }
    return Scaffold(
      body: child,
    );
  }
}






