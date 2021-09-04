import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/masters/Category/add_category.dart';
import 'package:propel/wfm/masters/Category/update_category.dart';
import 'dart:convert';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';


class category extends StatefulWidget {
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {

  bool isSwitched;
  int OrganizationId;
  List switchList;
  Future myFuture;
  int seletedOrg;
  bool unAssigned;
  bool firstorg = false;
  BottomLoader bl;

  get_orgId() async{
    int org_id = await Network().GetActiveOrg();

    if(org_id != 0){
        setState(() {
            firstorg = true;
          });
    }
    return org_id;
  }


  Future<List> categoryData() async {
    final orgId = await get_orgId();

    var res = await Network().getMethodWithToken('/CategoryList/$orgId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];
      setState(() {
        isSwitched = body['selectall'];
        switchList = result;
      });
      return result;
    }else{

      Fluttertoast.showToast(
          msg: "Server Error,Contact Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
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
    final user = await categoryData();

    var data = {'id' : id,'status':value?1:0};

    var res = await Network().postMethodWithToken(data, '/CategoryStatusChg');
    var body = json.decode(res.body);

    if(body['status'] == 1){

      Fluttertoast.showToast(

          msg: body['data'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,

          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
      myFuture = categoryData();

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
    final user = await categoryData();
    var data = {'status':value,'id':user};
    var res = await Network().postMethodWithToken(data, '/CategorySelectAll');
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
      myFuture = categoryData();
      setState(() {
        isSwitched = value;
      });

      final prefs = await SharedPreferences.getInstance();

      prefs.setBool('unAssignedcategory', value);
      bl.close();
    }

  }

  @override
  void initState() {
    myFuture = categoryData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: myFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
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
                                          Text('Add Category', style: TextStyle(
                                            color: Colors.white,),),
                                        ],
                                      ),
                                      // onPressed: () {
                                      //
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               AddCategory()));
                                      // }
                                    onPressed: firstorg?(){
                                      Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCategory()));
                                    }:null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Center(
                              child: Text("Category is Empty")
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.only(top:05,right: 05),
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.add,color: Colors.white),
                                        Text('Add Category',style: TextStyle(color: Colors.white,),),
                                      ],
                                    ),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCategory()));
                                  },
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
                                  // onChanged: (bool value) {
                                  //   setState(() {
                                  //     isSwitched = value;
                                  //   });
                                  // },
                                  onChanged: (bool expanding) => _selectall(expanding),
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.green,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.red,
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              // padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),

                              itemBuilder: (context, i){
                                return ListTile(

                                  title: Text(snapshot.data[i]['pName']),
                                  trailing: Container(
                                      width: 60,
                                      child: Switch(
                                        value: switchList[i]['pStatus'],
                                        onChanged: (bool expanding) => _onchanged(expanding, i,snapshot.data[i]['pId']),
                                        activeColor: Colors.white,
                                        activeTrackColor: Colors.green,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: Colors.red,
                                      )
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateCategory(
                                              id:snapshot.data[i]['pId'],
                                              name:snapshot.data[i]['pName'],
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
            }else{
              return Container(
                child: Center(
                  child: AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    color: Colors.orange,
                  ),
                ),
              );
            }
          }),
    );
  }
}








