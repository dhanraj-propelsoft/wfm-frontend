import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Name = new TextEditingController();
  final MobileNo = new TextEditingController();
  final Email = new TextEditingController();
  final DOB = new TextEditingController();
  final HomeAddress = new TextEditingController();
  final OfficeAddress = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Profile",style: TextStyle(color: Colors.black),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.only(left: 10.0,right: 10.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/splash_img.jpg'),
                ),
              ),
              TextField(
                onTap: () {
                  name_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Mobile",
                  labelText: "Name",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: Name,
              ),
              TextField(
                onTap: () {
                  mobile_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Mobile",
                  labelText: "Mobile",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: MobileNo,
              ),
              TextField(
                onTap: (){
                  email_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Email",
                  labelText: "Email",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: Email,
              ),
              TextField(
                onTap: (){
                  dob_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your DOB",
                  labelText: "DOB",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: DOB,
              ),
              TextField(
                onTap: (){
                  home_address_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Address",
                  labelText: "Home Address",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: HomeAddress,
              ),
              TextField(
                onTap: (){
                  home_address_update();
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Address",
                  labelText: "Office Address",

                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: OfficeAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void name_update() async{

    final firstname = new TextEditingController();
    final middlename = new TextEditingController();
    final lastname = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "First Name",
                                fillColor: Colors.white),
                            controller: firstname,
                          ),

                        ),
                        SizedBox(height: bottomsheet_height,),
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "Middle Name",
                                fillColor: Colors.white),
                            controller: middlename,
                          ),

                        ),
                        SizedBox(height: bottomsheet_height,),
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "Last Name",
                                fillColor: Colors.white),
                            controller: lastname,
                          ),

                        ),
                        SizedBox(height: bottomsheet_height,),
                        ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            // padding: EdgeInsets.all(50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(Icons.direc,color: Colors.white),
                                Text('Update',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ],
                            ),
                            // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                          ),
                        ),
                        SizedBox(
                          height: bottomsheet_height,
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void mobile_update() async{

    final mobileno = new TextEditingController();


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "Mobile No",
                                fillColor: Colors.white),
                            controller: mobileno,
                          ),

                        ),

                        SizedBox(height: bottomsheet_height,),
                        ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            // padding: EdgeInsets.all(50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(Icons.direc,color: Colors.white),
                                Text('Update',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ],
                            ),
                            // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                          ),
                        ),
                        SizedBox(
                          height: bottomsheet_height,
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void email_update() async{

    final email = new TextEditingController();


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(15.0),
                              //   ),
                              // ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "Email",
                                fillColor: Colors.white),
                            controller: email,
                          ),

                        ),

                        SizedBox(height: bottomsheet_height,),
                        ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            // padding: EdgeInsets.all(50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(Icons.direc,color: Colors.white),
                                Text('Update',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ],
                            ),
                            // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                          ),
                        ),
                        SizedBox(
                          height: bottomsheet_height,
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void dob_update() async{

    final dob = new TextEditingController();


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'DOB',
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
                              dob.text = date.toString().substring(0,10);
                            },
                            controller: dob,
                          ),

                        ),

                        SizedBox(height: bottomsheet_height,),
                        ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            // padding: EdgeInsets.all(50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(Icons.direc,color: Colors.white),
                                Text('Update',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ],
                            ),
                            // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                          ),
                        ),
                        SizedBox(
                          height: bottomsheet_height,
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void home_address_update() async{

    final home_address = new TextEditingController();


    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.only(left:15,right: 15),
                          height: 45.0,
                          child: TextField(
                            autofocus: true,
                            // onChanged:(val){
                            //
                            //   if (val.trim().isEmpty){
                            //     setState(() {
                            //       isCategoryNameVal = false;
                            //     });
                            //   }else{
                            //     setState(() {
                            //       isCategoryNameVal = true;
                            //     });
                            //   }
                            //
                            // },
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(15.0),
                              //   ),
                              // ),
                                filled: true,
                                hintStyle: new TextStyle(color: Colors.grey[600]),
                                // hintText: "Boys Rings",
                                labelText: "Home Address",
                                fillColor: Colors.white),
                            controller: home_address,
                          ),

                        ),
                        SizedBox(height: bottomsheet_height,),
                        ButtonTheme(
                          height: 45.0,
                          child: RaisedButton(
                            // padding: EdgeInsets.all(50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(Icons.direc,color: Colors.white),
                                Text('Update',style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ],
                            ),
                            // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                          ),
                        ),
                        SizedBox(
                          height: bottomsheet_height,
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

}