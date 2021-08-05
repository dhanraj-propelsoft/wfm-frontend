import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/masters/Project/project.dart';
import 'dart:math';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';


class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}


class CompanyWidget {
  const CompanyWidget(this.id,this.name);
  final String name;
  final int id;
}
class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}
class _AddTaskState extends State<AddTask> {

  final Name = new TextEditingController();
  final Details = new TextEditingController();
  final CreateddateController = TextEditingController();
  final DuedateController = TextEditingController();
  BottomLoader bl;
  String ProjEndDate;
  List AssignedbyList;
  int Assignedbyemployee;
  List AssignedtoList;
  int Assignedtoemployee;
  List projectList;
  int seletedproject;
  List categoryList;
  int seletedcategory;
  int prorityid = 2;
  bool _valName = false;
  bool _isLoading = false;
  List tempFollowerList;
  List FollowerList;
  // List selectedfollower;
  String _myActivitiesResult;
  int seletedOrg;
  int OrganizationId;
  String Category = "Unassigned Category";
  List<CompanyWidget> _companies = [];
  List _selected_followers = [];
  bool isButtonEnabled = false;


  static List<Animal> _animals = [];
  // final _items = _animals.map((animal) => MultiSelectItem(animal.id, animal.name)).toList();
  List _selectedAnimals3 = [];

  get_orgId() async{
    final prefs = await SharedPreferences.getInstance();
    seletedOrg = prefs.getInt('orgid') ?? 0;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    OrganizationId = seletedOrg == 0?Data['firstOrg']:seletedOrg;
    return OrganizationId;
  }


  void _handleRadioValueChange(int value) {
    setState(() {
      prorityid = value;
      switch (prorityid) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  void initState() {
    super.initState();
    _taskData();
  }

  @override

  Future<String> _cateBasedProj(int CategoryId) async {
    var res = await Network().projectList('/CategoryBasedProj/$CategoryId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];
      print(result);

      setState(() {
        projectList= [];
        projectList = result;
      });
    }
  }

  Future<String> _ProjBasedCate(int ProjId) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var res = await Network().projectList('/ProjBasedCategory/$ProjId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
        var projectData = body['projecData'];
        var catgoryData = body['categoryData'];

      setState(() {

        if(projectData['deadline_date'] != "Lifetime"){
          ProjEndDate = projectData['deadline_date'];
          DuedateController.text = ProjEndDate;
        }
        if(catgoryData != null){
          Category = catgoryData['name'];
          seletedcategory = catgoryData['id'];
        }else{
          Category = "Unassigned Category";
        }

      });
      bl.close();
    }
  }


  // Future Assignedbychg(int Assignedbyid) async {
  //
  //   var res = await Network().projectList('/ProjBasedCategory/$ProjId');
  //   var body = json.decode(res.body);
  //   // if(body['status'] == 1){
  //   //   var category = body['categoryDatas'];
  //   //   var projectData = body['projecData'];
  //   //   // var categoryList = body['CategoryList'];
  //   //
  //   //
  //   //
  //   //   setState(() {
  //   //
  //   //     if(projectData['deadline_date'] != "Lifetime"){
  //   //       ProjEndDate = projectData['deadline_date'];
  //   //       DuedateController.text = ProjEndDate;
  //   //     }
  //   //     categoryList = [];
  //   //     categoryList = body['CategoryList'];
  //   //
  //   //
  //   //   });
  //   // }
  // }

  Future<String> _taskData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    final orgId = await get_orgId();
    var res = await Network().projectCreate('/taskCreate/$orgId');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      var result = body['data'];
      // var formattedDate ="${todayDate.year}-${todayDate.month}-${todayDate.day}";
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String todayDate = formatter.format(now);
      setState(() {
        AssignedbyList = result['pAssignedbyList'];
        AssignedtoList = result['pAssignedtoList'];
        FollowerList = result['pFollowerList'];
        tempFollowerList = result['pFollowerList'];
        result['pFollowerList'].forEach((item) => _companies .add(CompanyWidget(int.parse(item['person_id']), item['first_name'])));
        // _companies.removeWhere((item) => item.id == int.parse(Data['person_id']));
        categoryList = result['pCategoryDatas'];
        projectList = result['pProjectDatas'];
        CreateddateController.text = todayDate;
        DuedateController.text = todayDate;
        Assignedbyemployee = int.parse(Data['person_id']);
        Assignedtoemployee = int.parse(Data['person_id']);
        // print(FollowerList);
        // print(Data['person_id']);
        // FollowerList.removeWhere((item) => int.parse(item['person_id']) == int.parse(Data['person_id']));
        // print(FollowerList);
        // print(Assignedbyemployee);
        // print(Assignedtoemployee);
      });

    }
    setState(() {
      _isLoading = false;
    });
  }

  Future taskSave(String name,String Details,String StartDate,String EndDate,int assignedby,int assignedto,int category,int project,int prority,List _selected_followers) async {
    setState(() {
      _isLoading = true;
    });
    final orgId = await get_orgId();
    var data = {'pName' : name,'pDetails':Details,'pStartDate':StartDate,'pEndDate':EndDate,'pAssignedBy':assignedby,'pAssignedTo':assignedto,'pCategoryId':category,'pProjectId':project,'pProrityId':prority,'pFollower':_selected_followers,'orgId':orgId};

    var res = await Network().ProjectStore(data, '/taskStore');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:3, page:"Add"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Task name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
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
              // color: Colors.blue,
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(title: Text("Add Task",style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left:15,right: 15),
                  child: TextField(
                    // autofocus: true,
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
                    obscureText: false,
                    // maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Key in Work or to do task",
                      labelText: "Task",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      errorText: _valName ? "Name is required":null,
                    ),
                    controller: Name,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:15,right: 15),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Enter the Task Details",
                      labelText: "Task Details",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                    ),
                    controller: Details,
                  ),

                ),
                Container(
                    padding: EdgeInsets.only(left:15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child:TextField(
                            readOnly: true,
                            controller: CreateddateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Created Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
                            ),
                            onTap: () async {
                              // final DateTime now = DateTime.now();
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              var date =  await showDatePicker(
                                  context: context,
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100)
                              );
                              CreateddateController.text = date.toString().substring(0,10);
                            },),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          child:TextField(
                            readOnly: true,
                            controller: DuedateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Due Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
                            ),
                            onTap: () async {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              var date =  await showDatePicker(
                                  context: context,
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100));
                              DuedateController.text = date.toString().substring(0,10);

                              if(ProjEndDate != null){
                                // var startDate = ProjEndDate;
                                // var EndDate = DuedateController.text;
                                if(DuedateController.text.compareTo(ProjEndDate) > 0)
                                {
                                  Fluttertoast.showToast(

                                      msg: "Date Exceeds the Project Due date",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      // timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.black
                                  );
                                  setState(() {
                                    DuedateController.text = ProjEndDate;
                                  });
                                }
                              }

                              var startDate = CreateddateController.text;
                              var EndDate = DuedateController.text;
                              if(EndDate.compareTo(startDate) < 0)
                              {
                                Fluttertoast.showToast(

                                    msg: "Start Date should not be greater than End Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.black
                                );
                                setState(() {
                                  DuedateController.text = ProjEndDate != null?ProjEndDate:"";
                                });
                              }

                            },),
                        ),
                      ],
                    )
                ),
                Container(
                  // padding: EdgeInsets.only(left:15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(

                                value: Assignedbyemployee,
                                // iconSize: 30,
                                // icon: (null),
                                // style: TextStyle(
                                //   color: Colors.black54,
                                //   fontSize: 16,
                                // ),

                                hint: Text('Assigned By'),
                                items: AssignedbyList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['first_name'].toString()),
                                    value: int.parse(item['person_id']),
                                  );
                                })?.toList() ?? [],
                                // onChanged: (newValue) => Assignedbychg(value),
                                onChanged: (newValue) {
                                  setState(() {
                                    Assignedbyemployee = newValue;
                                    print(Assignedbyemployee);
                                    _companies = [];
                                    tempFollowerList.forEach((item) => _companies .add(CompanyWidget(int.parse(item['person_id']), item['first_name'])));
                                    _companies.removeWhere((item) => item.id == Assignedbyemployee);
                                    _companies.removeWhere((item) => item.id == Assignedtoemployee);
                                    // FollowerList.removeWhere((item) => int.parse(item['person_id']) == Assignedbyemployee);
                                    if(_selected_followers != null){
                                      _selected_followers.clear();
                                    }
                                    // selectedfollower.clear();
                                    // Assignedbychg(Assignedbyemployee);
                                    // FollowerList.removeWhere((item) => item['id'] == Assignedbyemployee);

                                  });
                                },
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20.09,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                value: Assignedtoemployee,
                                // iconSize: 30,
                                // icon: (null),
                                // style: TextStyle(
                                //   color: Colors.black54,
                                //   fontSize: 16,
                                // ),
                                hint: Text('Assigned To'),
                                items: AssignedtoList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['first_name'].toString()),
                                    value: int.parse(item['person_id']),
                                  );
                                })?.toList() ??
                                    [],
                                onChanged: (newValue) {
                                  setState(() {

                                    Assignedtoemployee = newValue;
                                    _companies = [];
                                    tempFollowerList.forEach((item) => _companies .add(CompanyWidget(int.parse(item['person_id']), item['first_name'])));
                                    _companies.removeWhere((item) => item.id == Assignedtoemployee);
                                    _companies.removeWhere((item) => item.id == Assignedbyemployee);
                                    if(_selected_followers != null){
                                      _selected_followers.clear();
                                    }

                                    // FollowerList = tempFollowerList;
                                    // FollowerList.removeWhere((item) => int.parse(item['person_id']) == Assignedtoemployee);

                                    // FollowerList.removeWhere((item) => item['id'] == Assignedtoemployee);



                                  });
                                },
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20.09,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left:15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            // child: DropdownButtonHideUnderline(
                            //       child: ButtonTheme(
                            //         alignedDropdown: true,
                            //         child: DropdownButton(
                            //           value: seletedcategory,
                            //           // icon: Icon(
                            //           //   Icons.account_tree,
                            //           //   color: Colors.grey,
                            //           //   size: 20.09,
                            //           // ),
                            //           // iconSize: 30,
                            //           // icon: (null),
                            //           // style: TextStyle(
                            //           //   color: Colors.black54,
                            //           //   fontSize: 16,
                            //           // ),
                            //           hint: Text('Unassigned Category'),
                            //           items: categoryList?.map((item) {
                            //             return new DropdownMenuItem(
                            //               child: new Text(item['name'].toString()),
                            //               value: item['id'],
                            //             );
                            //           })?.toList() ?? [],
                            //           onChanged: (newValue) {
                            //             setState(() {
                            //               seletedcategory = newValue;
                            //               _cateBasedProj(seletedcategory);
                            //             });
                            //           },
                            //         ),
                            //       ),
                            //     ),
                            child: Text(Category,style: TextStyle(fontSize: 16.0,
                          color: Colors.grey
                      ),),
                          ),

                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  value: seletedproject,
                                  // icon: Icon(
                                  //   Icons.layers,
                                  //   color: Colors.grey,
                                  //   size: 20.09,
                                  // ),
                                  // iconSize: 30,
                                  // icon: (null),
                                  // style: TextStyle(
                                  //   color: Colors.black54,
                                  //   fontSize: 16,
                                  // ),
                                  hint: Text('Unassigned Proj'),
                                  items: projectList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['name'].toString()),
                                      value: item['id'],
                                    );
                                  })?.toList() ?? [],
                                  onChanged: (newValue) {
                                    setState(() {
                                      seletedproject = newValue;

                                      // if(seletedcategory == null){
                                      //   Fluttertoast.showToast(
                                      //
                                      //       msg: "Select Project first",
                                      //       toastLength: Toast.LENGTH_SHORT,
                                      //       gravity: ToastGravity.BOTTOM,
                                      //       // timeInSecForIos: 1,
                                      //       backgroundColor: Colors.grey,
                                      //       textColor: Colors.black
                                      //   );
                                      //   seletedproject= null;
                                      // }
                                      _ProjBasedCate(seletedproject);

                                    });
                                  },
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),

                ),
                Container(
                  padding: EdgeInsets.only(left:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Priority",style: TextStyle(
                          color: Colors.grey
                      ),),
                      Radio(value: 1, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Low",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Radio(value: 2, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Normal",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Radio(value: 3, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Medium",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Radio(value: 4, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "High",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: MultiSelectBottomSheetField(
                    initialValue: _selected_followers,
                    initialChildSize: 0.7,
                    maxChildSize: 0.95,
                    title: Text("Select Followers"),
                    buttonText: Text("Followers"),
                    items:  _companies.map((animal) => MultiSelectItem(animal.id, animal.name)).toList(),
                    searchable: true,
                    onConfirm: (values) {
                      setState(() {
                        _selected_followers = values;
                      });

                    },
                    // chipDisplay: MultiSelectChipDisplay(
                    //   onTap: (item) {
                    //     setState(() {
                    //       _selectedAnimals3.remove(item);
                    //     });
                    //     _multiSelectKey.currentState.validate();
                    //   },
                    // ),
                  ),
                ),
                // Container(
                //     padding: EdgeInsets.only(left:15,right: 10,top: 05),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Followers",style: TextStyle(
                //             color: Colors.grey
                //         )),
                //         SingleChildScrollView(
                //           physics: BouncingScrollPhysics(),
                //           scrollDirection: Axis.horizontal,
                //           child: Wrap(
                //             children: companyPosition.toList(),
                //           ),
                //         ),
                //       ],
                //     ),

                // ),

                // MultiSelectFormField(
                //       autovalidate: false,
                //       chipBackGroundColor: Colors.blue,
                //       chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                //       // dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                //       // checkBoxActiveColor: Colors.blue,
                //       // checkBoxCheckColor: Colors.white,
                //       // FollowerList.removeWhere((item) => item['id'] == Assignedbyemployee);
                //       dialogShapeBorder: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(12.0))),
                //       title: Text(
                //         "Followers",
                //         style: TextStyle(fontSize: 16),
                //       ),
                //       validator: (value) {
                //
                //
                //         if (value == null || value.length == 0) {
                //           return 'Please select one or more options';
                //         }
                //         return null;
                //       },
                //       dataSource: FollowerList,
                //       textField: 'first_name',
                //       valueField: 'person_id'
                //           '',
                //       okButtonLabel: 'OK',
                //       cancelButtonLabel: 'CANCEL',
                //       // hintWidget: Text('Tap to Select followers'),
                //       initialValue: _selected_followers,
                //       onSaved: (value) {
                //         setState(() {
                //           _selected_followers = value;
                //
                //           // if(Assignedbyemployee == null || Assignedtoemployee == null){
                //           //   Fluttertoast.showToast(
                //           //       msg: "Select Assignedby and Assigned to first",
                //           //       toastLength: Toast.LENGTH_SHORT,
                //           //       gravity: ToastGravity.BOTTOM,
                //           //       // timeInSecForIos: 1,
                //           //       backgroundColor: Colors.grey,
                //           //       textColor: Colors.black
                //           //   );
                //           //   selected_follower.clear();
                //           // }
                //           // else {
                //           //
                //           //       selectedfollower.removeWhere((item) => int.parse(item) == Assignedbyemployee);
                //           //
                //           //       selectedfollower.removeWhere((item) => int.parse(item) == Assignedtoemployee);
                //           //
                //           // }
                //
                //           //
                //           //   // selectedfollower.removeWhere((item) => int.parse(item) == Assignedtoemployee);
                //           // }
                //         });
                //       },
                //     )

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Text('Cancel',style: TextStyle(color: Colors.white,),),
                      // Icon(Icons.close,color: Colors.white),
                    ],
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/');
                  }
              ),
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
                    setState(() {
                      seletedcategory = null;
                      seletedproject = null;
                      Assignedtoemployee = null;
                      _selected_followers.clear();
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
              RaisedButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Text('Save',style: TextStyle(color: Colors.white,),),
                      // Icon(Icons.save,color: Colors.white),
                    ],
                  ),
                    // onPressed:
                    // Name.text.isEmpty?null:
                    //     (){
                    // print(Name.text);
                    // },
                  // onPressed: (){

                    // setState(() {
                    //   Name.text.isEmpty?_valName = true:_valName = false;
                    //   if(_valName == false){
                    //     taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                    //   }
                    // });
                  // }
                onPressed:isButtonEnabled?(){
                  setState(() {
                    Name.text.isEmpty?_valName = true:_valName = false;
                    if(_valName == false){
                      taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                    }
                  });
                  // taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                }:null,
              ),
            ],
          ),
        ),
        // persistentFooterButtons: [
        //   Container(
        //     child: Row(
        //       children: [
        //         RaisedButton(
        //             color: Colors.grey,
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //             child: Row(
        //               children: <Widget>[
        //                 Text('Cancel',style: TextStyle(color: Colors.white,),),
        //                 Icon(Icons.close,color: Colors.white),
        //               ],
        //             ),
        //             onPressed: (){
        //               Navigator.pushNamed(context, '/');
        //             }
        //         ),
        //         SizedBox(
        //           width: 50,
        //         ),
        //         RaisedButton(
        //             color: Colors.blue,
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //             child: Row(
        //               children: <Widget>[
        //                 Text('Clear',style: TextStyle(color: Colors.white,),),
        //                 Icon(Icons.redo_sharp,color: Colors.white),
        //               ],
        //             ),
        //             onPressed: (){}
        //         ),
        //         SizedBox(
        //           width: 50,
        //         ),
        //         RaisedButton(
        //             color: Colors.green,
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //             child: Row(
        //               children: <Widget>[
        //                 Text('Save',style: TextStyle(color: Colors.white,),),
        //                 Icon(Icons.save,color: Colors.white),
        //               ],
        //             ),
        //             onPressed: (){
        //
        //               setState(() {
        //                 Name.text.isEmpty?_valName = true:_valName = false;
        //                 if(_valName == false){
        //                   taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,selectedfollower);
        //                 }
        //               });
        //             }
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      );
    }

  }
  // Iterable<Widget> get companyPosition sync* {
  //   for (CompanyWidget company in _companies) {
  //
  //     yield Padding(
  //       padding: const EdgeInsets.all(6.0),
  //       child: FilterChip(
  //         // backgroundColor: Colors.tealAccent[200],
  //         avatar: CircleAvatar(
  //           backgroundColor: Colors.grey,
  //           child: Text(company.name[0].toUpperCase(),style: TextStyle(color: Colors.white),),
  //         ),
  //         label: Text(company.name,),
  //         selected: _selected_followers.contains(company.id),
  //         // selected: company.id,
  //         selectedColor: Colors.orange,
  //         onSelected: (bool selected) {
  //
  //           setState(() {
  //             if (selected) {
  //               print(company.id);
  //               print(Assignedbyemployee);
  //
  //               // _selected_followers.removeWhere((int id) {
  //               //   return id == Assignedbyemployee;
  //               // });
  //               // _selected_followers.removeWhere((int id) {
  //               //   return id == Assignedtoemployee;
  //               // });
  //               _selected_followers.add(company.id);
  //             } else {
  //
  //               _selected_followers.removeWhere((int id) {
  //                 return id == company.id;
  //               });
  //             }
  //           });
  //         },
  //         // onSelected: (bool value)=>follower_update(value,company.id),
  //       ),
  //     );
  //   }
  // }
}

// class _AddTaskState extends State<AddTask> {
//   final dateController = TextEditingController();
//   final duedateController = TextEditingController();
//
//   String categorydropdownValue = 'UnAssigned Category';
//   String projectdropdownValue = 'UnAssigned Project';
//   String _name;
//   String _email;
//   String _password;
//   String _url;
//   String _phoneNumber;
//   String _calories;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Widget _buildName() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Name'),
//       maxLength: 10,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Name is Required';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _name = value;
//       },
//     );
//   }
//
//   Widget _buildEmail() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Email'),
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Email is Required';
//         }
//
//         if (!RegExp(
//             r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//             .hasMatch(value)) {
//           return 'Please enter a valid email Address';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _email = value;
//       },
//     );
//   }
//
//   Widget _buildPassword() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Password'),
//       keyboardType: TextInputType.visiblePassword,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Password is Required';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _password = value;
//       },
//     );
//   }
//
//   Widget _builURL() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Url'),
//       keyboardType: TextInputType.url,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'URL is Required';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _url = value;
//       },
//     );
//   }
//
//   Widget _buildPhoneNumber() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Phone number'),
//       keyboardType: TextInputType.phone,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Phone number is Required';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _url = value;
//       },
//     );
//   }
//
//   Widget _buildCalories() {
//     return TextFormField(
//       decoration: InputDecoration(labelText: 'Calories'),
//       keyboardType: TextInputType.number,
//       validator: (String value) {
//         int calories = int.tryParse(value);
//
//         if (calories == null || calories <= 0) {
//           return 'Calories must be greater than 0';
//         }
//
//         return null;
//       },
//       onSaved: (String value) {
//         _calories = value;
//       },
//     );
//   }
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is removed
//     dateController.dispose();
//     duedateController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add New Task")),
//       // body: SingleChildScrollView(
//       //   child: Container(
//       //     margin: EdgeInsets.all(24),
//       //     child: Form(
//       //       key: _formKey,
//       //       child: Column(
//       //         mainAxisAlignment: MainAxisAlignment.center,
//       //         children: <Widget>[
//       //           _buildName(),
//       //           _buildEmail(),
//       //           _buildPassword(),
//       //           _builURL(),
//       //           _buildPhoneNumber(),
//       //           _buildCalories(),
//       //           SizedBox(height: 100),
//       //           RaisedButton(
//       //             child: Text(
//       //               'Submit',
//       //               style: TextStyle(color: Colors.blue, fontSize: 16),
//       //             ),
//       //             onPressed: () {
//       //               if (!_formKey.currentState.validate()) {
//       //                 return;
//       //               }
//       //
//       //               _formKey.currentState.save();
//       //
//       //               //Send to API
//       //             },
//       //           )
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//       body: SingleChildScrollView(
//         child: Row(
//           children: [
//             Flexible(
//               child: TextField(
//                 readOnly: true,
//                 controller: dateController,
//                 decoration: InputDecoration(
//                     hintText: 'Pick your Date',
//                     labelText: 'Created Date'
//                 ),
//                   onTap: () async {
//                     var date =  await showDatePicker(
//                         context: context,
//                         initialDate:DateTime.now(),
//                         firstDate:DateTime(1900),
//                         lastDate: DateTime(2100));
//                     dateController.text = date.toString().substring(0,10);
//                   },
//               ),
//             ),
//
//             Flexible(
//               child: TextField(
//                 readOnly: true,
//                 controller: duedateController,
//                 decoration: InputDecoration(
//                     hintText: 'Pick your Date',
//                     labelText: 'Created Date'
//                 ),
//                 onTap: () async {
//                   var date =  await showDatePicker(
//                       context: context,
//                       initialDate:DateTime.now(),
//                       firstDate:DateTime(1900),
//                       lastDate: DateTime(2100));
//                   duedateController.text = date.toString().substring(0,10);
//                 },
//               ),
//             ),
//           ],
//         ),
//
//       ),
//     );
//   }
// }
