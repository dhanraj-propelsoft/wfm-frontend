import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  List employeeList;
  int seletedemployee;
  List categoryList;
  int seletedcategory;
  final Name = new TextEditingController();
  bool _valName = false;
  final Details = new TextEditingController();
  final CreateddateController = TextEditingController();
  final DuedateController = TextEditingController();
  var todayDate =  DateTime.now();
  bool _isLoading = false;
  int seletedOrg;
  int OrganizationId;
  bool isButtonEnabled = false;

  get_orgId() async{
    final prefs = await SharedPreferences.getInstance();
    seletedOrg = prefs.getInt('orgid') ?? 0;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    OrganizationId = seletedOrg == 0?Data['firstOrg']:seletedOrg;
    return OrganizationId;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {

          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // var formattedDate = ${todayDate.day}-${todayDate.month}-${todayDate.year}";

  void initState() {
    super.initState();
    _projectData();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    // String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    // print(formattedTime);
    // print(formattedDate);
    // var temp = DateTime.now().toUtc();
    // var d1 = DateTime.utc(temp.year,temp.month,temp.day);
    // print(d1);
    // var d1= DateTime.utc(2021,04,25);
    // var d2 = DateTime.utc(2021,05,25);
    // print(d1);
    // print(d2);
    // if(d2.compareTo(d1)==0){
    //   print('true');
    // }else{
    //   print('false');
    // }

    // final birthday = DateTime(2021, 05, 19);
    // final date2 = DateTime.now();
    // final difference = date2.difference(birthday).inDays;
    // print(difference);

  }

  @override
  Future<String> _projectData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    final orgId = await get_orgId();
    var res = await Network().projectCreate('/projectCreate/$orgId');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      var result = body['data'];
      // var formattedDate ="${todayDate.year}-${todayDate.month}-${todayDate.day}";
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String todayDate = formatter.format(now);

      setState(() {
        employeeList = result['pEmployeeDatas'];
        categoryList = result['pCategoryDatas'];
        CreateddateController.text = todayDate;
        DuedateController.text = "Lifetime";

        seletedemployee = int.parse(Data['person_id']);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future projectSave(String name,String Details,int employee,int category,String StartDate,String EndDate) async {
    setState(() {
      _isLoading = true;
    });
    final orgId = await get_orgId();
    print(orgId);
    var data = {'pName' : name,'pDetails':Details,'pProjectOwner':employee,'pCategoryId':category,'pStartDate':StartDate,'pDeadlineDate':EndDate,'orgId':orgId};
    var res = await Network().ProjectStore(data, '/projectStore');
    var body = json.decode(res.body);
    print(body);
    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:2, page:"Add"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Project name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    }
  }

  Widget build(BuildContext context) {
    if(_isLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Add Project",style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    obscureText: false,
                    // maxLines: 3,
                    onChanged:(val){

                      if (val.trim().isEmpty){
                        setState(() {
                          isButtonEnabled = false;
                        });
                      }else{
                        setState(() {
                          isButtonEnabled = true;
                        });
                      }

                    },
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Enter Project Name",
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      errorText: _valName ? "Name is required" : null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                    ),
                    controller: Name,

                  ),

                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    obscureText: false,
                    // maxLines: 3,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Enter the Project Details",
                      labelText: "Details",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                    ),
                    controller: Details,
                  ),

                ),
                // Container(
                //   padding: EdgeInsets.only(left: 15, right: 15,top: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Project Owner",style: TextStyle(color: Colors.grey),),
                //       Text("Category",style: TextStyle(color: Colors.grey),)
                //     ],
                //   ),
                // ),
                Container(
                  // padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: seletedemployee,
                              // iconSize: 30,
                              // icon: (null),
                              // style: TextStyle(
                              //   color: Colors.black54,
                              //   fontSize: 16,
                              // ),
                              hint: Text('Project Owner'),
                              items: employeeList?.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      item['first_name'].toString()),
                                      value: int.parse(item['person_id']),
                                );
                              })?.toList() ??
                                  [],
                              onChanged: (newValue) {
                                setState(() {
                                  seletedemployee = newValue;

                                });
                              },
                            ),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: seletedcategory,
                              // iconSize: 30,
                              // icon: (null),
                              // style: TextStyle(
                              //   color: Colors.black54,
                              //   fontSize: 16,
                              // ),
                              hint: Text('UnAssigned Category'),
                              items: categoryList?.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['name'].toString()),
                                  value: item['id'],
                                );
                              })?.toList() ??
                                  [],
                              onChanged: (newValue) {
                                setState(() {
                                  seletedcategory = newValue;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            controller: CreateddateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Start Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(
                                    Icons.calendar_today_rounded, size: 18.0)
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              CreateddateController.text = date.toString().substring(0, 10);
                            },),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            controller: DuedateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'End Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(
                                    Icons.calendar_today_rounded, size: 18.0)
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              DuedateController.text = date.toString().substring(0, 10);
                              var startDate = CreateddateController.text;
                              var EndDate = DuedateController.text;
                              print(EndDate.compareTo(startDate));
                              if(EndDate.compareTo(startDate) < 0)
                              {
                                _showMsg("Start Date should not be greater than End Date.");
                                setState(() {
                                  DuedateController.text = "";
                                });
                              }

                            },),
                        ),
                      ],
                    )
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 15, right: 15),
                //   child: TextField(
                //     obscureText: false,
                //     decoration: InputDecoration(
                //       // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //       //   hintText: "Attachment",
                //         suffixIcon: Icon(Icons.attach_file)
                //       // border:
                //       // OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                //     ),
                //
                //   ),
                //
                // ),
                SizedBox(
                  height: 50,
                ),

                ButtonBar(
                    children: <Widget>[
                      // RaisedButton(
                      //   color: Colors.red,
                      //   child: Text('Clear'),
                      //   onPressed: () {
                      //     Name.clear();
                      //     Details.clear();
                      //     // CreateddateController.clear();
                      //     // DuedateController.clear();
                      //     setState(() {
                      //       seletedcategory = null;
                      //     });
                      //
                      //   },
                      // ),
                      // RaisedButton(
                      //   color: Colors.green,
                      //   child: Text('Save'),
                      //   onPressed: () {
                      //     setState(() {
                      //       Name.text.isEmpty ? _valName = true : _valName =
                      //       false;
                      //       if (_valName == false) {
                      //         projectSave(
                      //             Name.text, Details.text, seletedemployee,
                      //             seletedcategory, CreateddateController.text,
                      //             DuedateController.text);
                      //       }
                      //     });
                      //   },
                      // )
                      RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Text('Clear',style: TextStyle(color: Colors.white,),),
                            // Icon(Icons.redo_sharp,color: Colors.white),
                          ],
                        ),
                        onPressed:isButtonEnabled?(){
                          Name.clear();
                          Details.clear();
                          // CreateddateController.clear();
                          // DuedateController.clear();
                          setState(() {
                            seletedcategory = null;
                          });
                          // Name.clear();
                          // Details.clear();
                          // setState(() {
                          //   seletedcategory = null;
                          //   seletedproject = null;
                          //   Assignedtoemployee = null;
                          //   _selected_followers.clear();
                          // });
                        }:null,
                        // onPressed: (){
                        //   Name.clear();
                        //   Details.clear();
                        //   // CreateddateController.clear();
                        //   // DuedateController.clear();
                        //   setState(() {
                        //     seletedcategory = null;
                        //     seletedproject = null;
                        //     Assignedtoemployee = null;
                        //     _selected_followers.clear();
                        //   });
                        // }
                      ),
                      RaisedButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Text('Save',style: TextStyle(color: Colors.white,),),
                            // Icon(Icons.redo_sharp,color: Colors.white),
                          ],
                        ),
                        onPressed:isButtonEnabled?(){
                            setState(() {
                                  Name.text.isEmpty ? _valName = true : _valName =
                                  false;
                                  if (_valName == false) {
                                    projectSave(
                                        Name.text, Details.text, seletedemployee,
                                        seletedcategory, CreateddateController.text,
                                        DuedateController.text);
                                  }
                                });
                        }:null,
                        // onPressed: (){
                        //   Name.clear();
                        //   Details.clear();
                        //   // CreateddateController.clear();
                        //   // DuedateController.clear();
                        //   setState(() {
                        //     seletedcategory = null;
                        //     seletedproject = null;
                        //     Assignedtoemployee = null;
                        //     _selected_followers.clear();
                        //   });
                        // }
                      ),
                    ]


                )
              ],
            ),
          ),
        ),

      );
    }
  }
}
