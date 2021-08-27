import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:propel/wfm/task/add_task.dart';
import 'package:propel/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propel/wfm/masters/Project/add_project.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Propel WFM',
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
    }
    return Scaffold(
      body: child,
    );
  }
}






