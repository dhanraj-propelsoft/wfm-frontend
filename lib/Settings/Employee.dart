import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text("Employee List",style: TextStyle(color: Colors.black),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: Scaffold(
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
                            Text('Add Workforce',style: TextStyle(color: Colors.white,),),
                          ],
                        ),
                        onPressed: (){

                        },
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
