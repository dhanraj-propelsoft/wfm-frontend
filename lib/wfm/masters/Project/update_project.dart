import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProject extends StatefulWidget {
  final int id;
  const UpdateProject({Key key,this.id}) : super(key: key);
  @override
  _UpdateProjectState createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {

  final Name = new TextEditingController();
  bool _valName = false;
  final Details = new TextEditingController();
  List employeeList;
  int seletedemployee;
  List categoryList;
  int seletedcategory;
  final CreateddateController = TextEditingController();
  final DuedateController = TextEditingController();
  bool _isLoading = false;
  int seletedOrg;
  int OrganizationId;

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

  Future<String> _projectData() async {
    setState(() {
      _isLoading = true;
    });
    int projectid = widget.id;
    final orgId = await get_orgId();

    var res = await Network().projectCreate('/projectEdit/$projectid/$orgId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];
      setState(() {
        employeeList = result['pEmployeeDatas'];
        categoryList = result['pCategoryDatas'];
        // print(employeeList);
        // print(result);

        seletedemployee = (result["pProjectOwner"] != 0)?result["pProjectOwner"]:seletedemployee;
        seletedcategory = (result["pCategoryId"] != 0)?result["pCategoryId"]:seletedcategory;
        Name.text = result["pName"];
        Details.text = result["pDetails"];
        CreateddateController.text = result['pStartDate'];
        DuedateController.text = result['pDeadlineDate'];
        _isLoading = false;
      });
    }


  }

  Future projectUpdate(String name,String Details,int employee,int category,String StartDate,String EndDate) async {
    setState(() {
      _isLoading = true;
    });
    final orgId = await get_orgId();
    int projectid = widget.id;
    var data = {'pName' : name,'pDetails':Details,'pProjectOwner':employee,'pCategoryId':category,'pStartDate':StartDate,'pDeadlineDate':EndDate,'orgId':orgId};
    var res = await Network().ProjectStore(data, '/projectUpdate/$projectid');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:2, page:"Update"
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
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
    }
  }

  void initState() {
    super.initState();
    _projectData();
  }
  @override
  // void addproject() async{
  //   int projectid = widget.id;
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var loginData = jsonDecode(localStorage.getString('allData'));
  //   var res = await Network().projectEdit('/projectEdit/$projectid');
  //   var body = json.decode(res.body);
  //   print(body);
  //   if(body['status'] == 1){
  //     var result = body['data'];
  //     setState(() {
  //       employees = result['pEmployeeDatas'];
  //       category = result['pCategoryDatas'];
  //       seletedemployee = result["pProjectOwner"];
  //       seletedcategory = result["pCategoryId"];
  //       Name.text = result["pName"];
  //       Details.text = result["pDetails"];
  //       CreateddateController.text = result['pStartDate'];
  //       DuedateController.text = result['pDeadlineDate'];
  //     });
  //   }
  // }




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
        appBar: AppBar(title: Text("Update Project",style: TextStyle(color: Colors.white),),
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
                Container(
                  // padding: EdgeInsets.only(left:15,right: 15),
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
                              CreateddateController.text =
                                  date.toString().substring(0, 10);
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
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.blue,
                        child: Text('Clear'),
                        onPressed: () {
                          Name.clear();
                          Details.clear();
                          CreateddateController.clear();
                          DuedateController.clear();
                          setState(() {
                            seletedcategory;
                          });
                        },
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.green,
                        child: Text('Update'),
                        onPressed: () {
                          setState(() {
                            Name.text.isEmpty ? _valName = true : _valName =
                            false;
                            if (_valName == false) {
                              projectUpdate(
                                  Name.text, Details.text, seletedemployee,
                                  seletedcategory, CreateddateController.text,
                                  DuedateController.text);
                            }
                          });
                        },
                      )
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

