import 'package:flutter/material.dart';
import 'package:propel/Employee/NewEmployee.dart';

class employeeList extends StatefulWidget {
  @override
  _employeeListState createState() => _employeeListState();
}

class _employeeListState extends State<employeeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Work Force",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                    color: Colors.orangeAccent,
                    child: Text(
                      '+Add WorkForce',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddEmployee()),
                      );
                    })
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
