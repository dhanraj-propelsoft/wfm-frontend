import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'dart:convert';
import 'package:propel/wfm/masters/Project/add_project.dart';
import 'package:propel/wfm/masters/Project/add_project.dart';
import 'package:propel/wfm/masters/Project/update_project.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';

class project extends StatefulWidget {
  @override
  _projectState createState() => _projectState();
}

class _projectState extends State<project> {
  BottomLoader bl;
  bool isSwitched;
  List switchList;
  Future myFuture;
  int seletedOrg;
  int OrganizationId;
  bool unAssignedcategory;
  bool firstorg = false;

  bool unAssignedProject = true;


  get_orgId() async{

    final prefs = await SharedPreferences.getInstance();
    seletedOrg = prefs.getInt('orgid') ?? 0;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    if(seletedOrg == 0){
      OrganizationId = Data['firstOrg'];
    }else{
      OrganizationId = seletedOrg;
    }
    if(OrganizationId != 0){
      setState(() {
        firstorg = true;
      });
    }
    return OrganizationId;
  }


  Future<List> projectData() async {
    final orgId = await get_orgId();
    var res = await Network().projectList('/projectList/$orgId');
    var body = json.decode(res.body);
    print(body);
    if(body['status'] == 1){
      var result = body['data'];
      setState(() {
        isSwitched = body['selectall'];
        switchList = result;
        // unAssignedProject = prefs.getBool('unAssignedproject') == null?true:prefs.getBool('unAssignedproject');
      });
      return result;
    }
  }

  Future<List> _onchanged(bool value,int index,int id) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {'id' : id,'status':value?1:0};

    var res = await Network().ProjectStore(data, '/ProjStatusChg');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      Fluttertoast.showToast(

          msg: body['data'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
      myFuture = projectData();
      bl.close();
    }

  }

  Future<List> _selectall(bool value) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    final user = await projectData();
    var data = {'status':value,'id':user};
    var res = await Network().ProjectStore(data, '/ProjSelectAll');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      Fluttertoast.showToast(
          msg: body['data'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
      myFuture = projectData();
      setState(() {
        isSwitched = value;
      });
      bl.close();
    }

  }

  Future<List> _unAssigned(bool value) async {

    setState(() {
      unAssignedProject = value;
    });

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setBool('unAssignedproject', unAssignedProject);

  }

  @override
  void initState() {
    myFuture = projectData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: myFuture,
          builder: (context,snapshot){
            if(snapshot.hasError){
              print('Error in Loading'+snapshot.error.toString());
            }
            if(snapshot.hasData){
              if(snapshot.data.length == 0){
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 05, right: 05),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: SizedBox(
                                  // width: 20.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20)),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.add, color: Colors.white),
                                          Text('Add Project', style: TextStyle(
                                            color: Colors.white,),),
                                        ],
                                      ),

                                      onPressed: firstorg?(){
                                          Navigator.of(context).push(
                                          MaterialPageRoute(
                                          builder: (context) =>
                                          AddProject()));
                                      }:null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Center(
                              child: Text("Project is Empty")
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }else {
                return Scaffold(
                  body: Container(
                      padding: EdgeInsets.only(top: 05, right: 05),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: SizedBox(
                                  // width: 20.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20)),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.add, color: Colors.white),
                                          Text('Add Project', style: TextStyle(
                                            color: Colors.white,),),
                                        ],
                                      ),
                                    onPressed: firstorg?(){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProject()));
                                    }:null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Container(
                            // padding: EdgeInsets.only(left: 50),
                            child: ListTile(
                              title: Text("Select All"),
                              trailing: Container(
                                  width: 60,
                                  child: Switch(
                                    value: isSwitched,
                                    onChanged: (bool expanding) => _selectall(expanding),
                                    // onChanged: (bool expanding){},
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.green,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.red,
                                  )
                              ),
                            ),
                          ),
                          // Container(
                          //   // padding: EdgeInsets.only(left: 50),
                          //   child: ListTile(
                          //     title: Text("UnAssigned Project"),
                          //     trailing: Container(
                          //         width: 60,
                          //         child: Switch(
                          //           value: unAssignedProject,
                          //           onChanged : (bool expanding) => _unAssigned(expanding),
                          //           activeColor: Colors.white,
                          //           activeTrackColor: Colors.green,
                          //           inactiveThumbColor: Colors.white,
                          //           inactiveTrackColor: Colors.red,
                          //         )
                          //     ),
                          //   ),
                          // ),
                          // Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                shrinkWrap: true,
                                // padding: EdgeInsets.only(top: 16),
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: Text(snapshot.data[i]['pName']),
                                    trailing: Container(
                                        width: 60,
                                        child: Switch(
                                          value: switchList[i]['pStatus'],
                                          // onChanged: (bool Value){},
                                          onChanged: (bool expanding) => _onchanged(expanding, i,snapshot.data[i]['pId']),
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.green,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Colors.red,
                                        )
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) =>
                                              UpdateProject(
                                                  id: snapshot.data[i]['pId']
                                              )));
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                );
              }
            }
            else{
              return Scaffold(
                body: Container(
                  child: Center(
                    child: AwesomeLoader(
                      loaderType: AwesomeLoader.AwesomeLoader3,
                      color: Colors.orange,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

// class ItemList extends StatefulWidget {
//   List list;
//   ItemList({key,this.list}) : super(key:key);
//   @override
//   _ItemListState createState() => _ItemListState(list);
// }
//
// class _ItemListState extends State<ItemList> {
//   bool isSwitched = false;
//   List list;
//   _ItemListState(this. list);
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(top:05,right: 05),
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     child: SizedBox(
//                       // width: 20.0,
//                       height: 30.0,
//                       child: RaisedButton(
//                           color: Colors.blue,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                           child: Row(
//                             children: <Widget>[
//                               Icon(Icons.add,color: Colors.white),
//                               Text('Add Project',style: TextStyle(color: Colors.white,),),
//                             ],
//                           ),
//                           onPressed: (){}
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(),
//               Container(
//                 // padding: EdgeInsets.only(left: 50),
//                 child: ListTile(
//                   title: Text("Select All"),
//                   trailing: Container(
//                       width: 60,
//                       child: Switch(
//                         value: isSwitched,
//                         onChanged: (bool value) {
//                           setState(() {
//                             isSwitched = value;
//                           });
//                         },
//                         activeColor: Colors.white,
//                         activeTrackColor: Colors.green,
//                         inactiveThumbColor: Colors.white,
//                         inactiveTrackColor: Colors.red,
//                       )
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 itemCount: list.length,
//                 shrinkWrap: true,
//                 // padding: EdgeInsets.only(top: 16),
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, i){
//                   return ListTile(
//                     title: Text(list[i]['pName']),
//                     trailing: Container(
//                         width: 60,
//                         child: Switch(
//                           value: isSwitched,
//                           onChanged: (bool value) {
//                             setState(() {
//                               isSwitched = value;
//                             });
//                           },
//                           activeColor: Colors.white,
//                           activeTrackColor: Colors.green,
//                           inactiveThumbColor: Colors.white,
//                           inactiveTrackColor: Colors.red,
//                         )
//                     ),
//                     onTap: (){},
//                   );
//
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
