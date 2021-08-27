import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final txtName = new TextEditingController();
  bool _valName = false;
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


  Future categorySave(String name) async {
    setState(() {
      _isLoading = true;
    });
    final orgId = await get_orgId();
    var data = {'pName' : name,'orgId':orgId};
    var res = await Network().categorySave(data, '/CategoryStore');
    var body = json.decode(res.body);
    if(body['status'] == 1){

      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:1,
                page:"Add"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Category name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    }
  }

  @override
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
        appBar: AppBar(title: Text("Add Category",style: TextStyle(color: Colors.white),),
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
                      child: Text('Save'),

                      onPressed:isButtonEnabled?(){
                        categorySave(txtName.text);
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