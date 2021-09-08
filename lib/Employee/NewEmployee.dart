import 'package:flutter/material.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add WorkForce'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10.85),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Employee Mobile No",
                    labelText: "Mobile Number",
                  ),
                )
              ],
            )),
      ),
    );
  }
}
