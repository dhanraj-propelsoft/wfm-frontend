import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/wfm/masters/Category/category.dart';
import 'package:propel/wfm/masters/Project/project.dart';
import 'auth/Organization/organizations.dart';
import 'package:propel/wfm/task/task_list.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propel/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/Settings/Home.dart';

class MainPage extends StatefulWidget {
  final int index;
  final String page;
  const MainPage({Key key, this.index, this.page}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String name;
  String email;
  int initalindex;
  bool firstOrg = false;
  BottomLoader bl;
  @override
  void initState() {
    _loadUserData();
    super.initState();
    if (widget.index == null) {
      setState(() {
        initalindex = 3;
      });
    } else {
      setState(() {
        initalindex = widget.index;
      });
      if (widget.index == 1) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Category Added Successfully"
                : "Category Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
      if (widget.index == 2) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Project Added Successfully"
                : "Project Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
      if (widget.index == 3) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Task Added Successfully"
                : "Task Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
    }
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var Data = jsonDecode(localStorage.getString('allData'));

    if (Data['firstOrg'] == 0) {
      setState(() {
        firstOrg = false;
      });
    } else {
      setState(() {
        firstOrg = true;
      });
    }

    if (user != null) {
      setState(() {
        name = user['name'];
        email = user['email'];
      });
    }
  }

  TabBar get _tabBar => TabBar(
        indicatorColor: Colors.orangeAccent,
        labelColor: Colors.black,
        tabs: <Widget>[
          Tab(text: 'Org', icon: Icon(Icons.account_balance, size: 20)),
          Tab(text: 'Category', icon: Icon(Icons.account_tree, size: 20)),
          Tab(text: 'Projects', icon: Icon(Icons.layers, size: 20)),
          Tab(text: 'Task', icon: Icon(Icons.assignment, size: 20)),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: initalindex,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Ado unbox",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: (){
            //
            //   },
            // ),
            // PopupMenuButton(itemBuilder: (context)=>[
            //   PopupMenuItem(child: Text("Menu1")),
            //   PopupMenuItem(child: Text("Menu2")),
            //   PopupMenuItem(child: Text("Menu3")),
            // ])
          ],
        ),
        // drawer: Drawer(
        //   elevation: 16.0,
        //   child: Column(
        //     children: <Widget>[
        //       UserAccountsDrawerHeader
        //         (accountName: Text(name.toString(),style: TextStyle(color: Colors.white),),
        //         accountEmail: Text(email.toString(),style: TextStyle(color: Colors.white),),
        //         currentAccountPicture: CircleAvatar(
        //           child: Text(name.toString().substring(0,1).toUpperCase(),style: new TextStyle(
        //             fontSize: 40.0,
        //             color: Colors.grey,
        //           ),),
        //           backgroundColor: Colors.white,
        //           maxRadius: 30,
        //
        //         ),
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.home),
        //         title: Text("Home"),
        //         onTap: (){},
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.person),
        //         title: Text("profile"),
        //         onTap: (){},
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.settings),
        //         title: Text("Setting"),
        //         onTap: (){},
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.exit_to_app),
        //         title: Text("Logout"),
        //         onTap: (){
        //           logout();
        //         },
        //       )
        //     ],
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: firstOrg
            ? FloatingActionButton(
                child: Icon(
                  Icons.post_add_rounded,
                  color: Colors.white,
                ),
                // backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, '/addTask');
                },
                // onPressed: firstOrg?(){
                //   Navigator.pushNamed(context, '/addTask');
                // }:null,
              )
            : null,
        body: TabBarView(
          children: <Widget>[
            Organizations(),
            category(),
            project(),
            TaskList()
          ],
        ),
      ),
    );
  }

  void logout() async {
    BottomLoader bl;

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);

    if (body['status'] == '1') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      localStorage.remove('allData');
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('orgid');
      prefs.remove('unAssignedcategory');
      prefs.remove('unAssignedproject');
      bl.close();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckAuth()));
    }
  }
}
