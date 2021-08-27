import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/network_utils/api.dart';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateCategory extends StatefulWidget {
  final int id;
  final String name;
  const UpdateCategory({Key key, this.id, this.name}) : super(key: key);
  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final txtName = new TextEditingController();
  bool _valName = false;
  bool _isLoading = false;
  bool isButtonEnabled = true;
  int _state = 0;

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

  Future categoryUpdate(String name) async {
    setState(() {
      _isLoading = true;
    });
    final orgId = await get_orgId();

    var data = {"pName": name,'orgId':orgId};
    var id = widget.id;
    var res = await Network().categoryUpdate(data, '/CategoryUpdate/$id');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:1, page:"Update"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Category name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
    }
  }
  @override
  void initState() {
    txtName.text = widget.name;
    super.initState();
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
        appBar: AppBar(title: Text("Update Category",style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
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
                decoration: new InputDecoration(
                  hintText: 'Enter Category',
                  hintStyle: TextStyle(fontSize: 17.0),
                  labelText: 'Category',
                  labelStyle: TextStyle(fontSize: 17.0),
                  errorText: _valName ? "Category is required" : null,
                ),
                controller: txtName,
              ),
              ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.green,
                      child: Text('Update'),
                        onPressed:isButtonEnabled?(){
                          categoryUpdate(txtName.text);
                        }:null
                    ),
                  ]


              )
            ],

          ),
        ),
      );
    }
  }
}
