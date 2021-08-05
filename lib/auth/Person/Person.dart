import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:propel/network_utils/api.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

class AddPersonMobile extends StatefulWidget {
  @override
  _AddPersonMobileState createState() => _AddPersonMobileState();
}

class _AddPersonMobileState extends State<AddPersonMobile> {
  final phoneNo = new TextEditingController();
  bool phoneVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  BottomLoader bl;
  void _mobile_no_check(mobile_no) async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var res = await Network().Mobile_NO_Check('/getPersonByMobileNo/$mobile_no');
    var body = json.decode(res.body);

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => AccountCreate1(mobile_no:mobile_no,data:body['data'])));

    // if(body['message'] == "SUCCESS"){
    //
    //   if(body['data']['pId'] != ''){
    //     var Name = body['data']['pFirstName'] +body['data']['pMiddleName'];
    //     bl.close();
    //     // Navigator.push(context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => LoginPageTwo(
    //     //             mobileno:mobile_no,
    //     //             name:Name,
    //     //             user_id:body['data']['pId']
    //     //         )));
    //   }else{
    //     // bl.close();
    //     // Fluttertoast.showToast(
    //     //     msg: "Mobile Number does not exist",
    //     //     toastLength: Toast.LENGTH_SHORT,
    //     //     gravity: ToastGravity.BOTTOM,
    //     //     // timeInSecForIos: 1,
    //     //     backgroundColor: Colors.grey[200],
    //     //     textColor: Colors.black
    //     // );
    //   }
    //
    //
    //
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange,
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 10){
                  setState(() {
                    isButtonEnabled = false;
                  });
                }else{
                  setState(() {
                    isButtonEnabled = true;
                  });
                }

              },
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Mobile",
                  labelText: "Mobile No",
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: Colors.blue,
                  ),
                  // errorText: phoneVal ? "Mobile Number is required":null,
                  errorText: phoneVal?"Mobile number is required":invalidphone? "InValid Mobile Number":null

                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: phoneNo,
            ),

            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  isButtonEnabled?() {
                setState(() {
                  phoneNo.text.isEmpty?phoneVal = true:phoneVal = false;
                  phoneNo.text.length != 10?invalidphone=true:invalidphone = false;
                  if(phoneVal == false && invalidphone == false){
                    _mobile_no_check(phoneNo.text);
                    // Navigator.push(context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LoginPageTwo(
                    //           mobileno:phoneNo.text,
                    //         )));
                  }
                });
              }:null,
            ),

          ],
        ),
      ),

    );
  }
}


class AccountCreate1 extends StatefulWidget {
  final Object data; // receives the value
  final String mobile_no;
  AccountCreate1({ Key key, this.data ,this.mobile_no}): super(key: key);
  @override
  _AccountCreate1State createState() => _AccountCreate1State();
}

class _AccountCreate1State extends State<AccountCreate1> {
  List SalutionList = [{'id':1,"name":"Mr"},{"id":2,"name":"Ms"}];
  final FirstName = new TextEditingController();
  final MiddleName = new TextEditingController();
  final LastName = new TextEditingController();
  final Alias = new TextEditingController();
  int SalutionId;
  bool isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a Account",style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      // backgroundColor: Colors.orange,
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Salution',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select Salution'),
                    items: SalutionList?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: SalutionId,
                    onChanged: (value) {
                      setState(() {
                        SalutionId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
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
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your First Name",
                  labelText: "First Name",
                  // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: FirstName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Middle Name",
                labelText: "Middle Name",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: MiddleName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Last Name",
                labelText: "Last Name",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: LastName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Nick Name",
                labelText: "Nick Name or Alias",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: Alias,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  isButtonEnabled?() {

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountCreate2(mobileno:widget.mobile_no,
                          salution:SalutionId,first_name:FirstName.text,middle_name:MiddleName.text,alisas:Alias.text
                        )));

              }:null,
            ),
          ],
        ),
      ),

    );
  }
}



class AccountCreate2 extends StatefulWidget {
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final String mobileno;
  const AccountCreate2({Key key,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.mobileno}) : super(key: key);
  @override
  _AccountCreate2State createState() => _AccountCreate2State();
}

class _AccountCreate2State extends State<AccountCreate2> {

  List Gender = [{'id':1,"name":"Male"},{"id":2,"name":"Female"},{"id":3,"name":"Third Gender"}];
  List BloodGroup = [{'id':1,"name":"B+"},{"id":2,"name":"B-"},{"id":3,"name":"A+"}];
  final DOB = new TextEditingController();
  int GenderId;
  int BloodGroupId;
  bool isButtonEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a Account",style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Gender',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select'),
                    items: Gender?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: GenderId,
                    onChanged: (value) {
                      setState(() {
                        GenderId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            TextField(
              readOnly: true,
              controller: DOB,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                  hintText: 'Pick Date',
                  labelText: 'DOB',
                  labelStyle: TextStyle(fontSize: 14.0),
                  hintStyle: TextStyle(fontSize: 14.0),
                  // suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
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
                DOB.text = date.toString().substring(0,10);
              },),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Blood Group',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select'),
                    items: BloodGroup?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: BloodGroupId,
                    onChanged: (value) {
                      setState(() {
                        BloodGroupId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  () {

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountCreateOTP(mobileno:widget.mobileno,
                            salution:widget.salution,first_name:widget.first_name,middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:GenderId,Dob:DOB.text,bloodgroup:BloodGroupId
                        )));

              },
            ),
          ],
        ),
      ),
    );
  }
}



class AccountCreateOTP extends StatefulWidget {

  final String mobileno;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;


  const AccountCreateOTP({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender}) : super(key: key);
  @override
  _AccountCreateOTPState createState() => _AccountCreateOTPState();
}

class _AccountCreateOTPState extends State<AccountCreateOTP> {
  final otp = new TextEditingController();
  String Mobile_hashed;
  bool otp_validate = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 4){
                  setState(() {
                    otp_validate = false;
                  });
                }else{
                  setState(() {
                    otp_validate = true;
                  });
                }

              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: "OTP Received on your Mobile $Mobile_hashed",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


              ),
              controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Validate',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: otp_validate?(){

                // OTP_Validate(otp.text,widget.userid);
              }:null,
            ),

          ],
        ),
      ),
    );
  }
  void OTP_Validate (OTP,user_id)async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'userId' : user_id,
      'otp' : OTP
    };
    var res = await Network().authData(data, '/OTPVerification');
    var body = json.decode(res.body);

    // if(body['message'] == "SUCCESS") {
    //   bl.close();
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => Forgot_Password(userid: user_id)
    //     ),
    //   );
    //
    // }else{
    //   bl.close();
    //   Fluttertoast.showToast(
    //       msg: "OTP is Invalid",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       // timeInSecForIos: 1,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black
    //   );
    // }
  }
}

// class Forgot_Password extends StatefulWidget {
//   final int userid;
//   const Forgot_Password({Key key,this.userid}) : super(key: key);
//   @override
//   _Forgot_PasswordState createState() => _Forgot_PasswordState();
// }
//
// class _Forgot_PasswordState extends State<Forgot_Password> {
//   final forgot_password = new TextEditingController();
//   final conform_password = new TextEditingController();
//   bool _isObscure = true;
//   bool _isObscure_conform = true;
//   bool _valforgot_pwd = false;
//   bool _valconform_pwd = false;
//   bool pwd_length = false;
//   bool match = false;
//   BottomLoader bl;
//   void update_password (userid,pwd,conform_pwd)async{
//
//     bl = new BottomLoader(
//       context,
//       showLogs: true,
//       isDismissible: true,
//     );
//     bl.style(
//       message: 'Please wait...',
//     );
//     bl.display();
//     var data = {
//       'userId' : userid,
//       'new_password' : pwd,
//       'new_confirm_password':conform_pwd
//     };
//     var res = await Network().authData(data, '/updatePassword');
//     var body = json.decode(res.body);
//     if(body['message'] == "SUCCESS") {
//       bl.close();
//       Navigator.push(
//         context,
//         new MaterialPageRoute(
//             builder: (context) => LoginPageTwo()
//         ),
//       );
//       Fluttertoast.showToast(
//           msg: "Password has been Updated!!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           // timeInSecForIos: 1,
//           backgroundColor: Colors.grey,
//           textColor: Colors.black
//       );
//
//     }else{
//       bl.close();
//       Fluttertoast.showToast(
//           msg: "Server error.Contact Admin",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           // timeInSecForIos: 1,
//           backgroundColor: Colors.grey,
//           textColor: Colors.black
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(left:25,right: 25),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//
//               obscureText: _isObscure,
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 // labelText: 'Password',
//                 errorText: _valforgot_pwd ? "Password is required":pwd_length?"Password atleast 6 digit must":null,
//                 hintText: "Enter New Password",
//                 hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
//                 suffixIcon: IconButton(
//                     icon: Icon(
//                         _isObscure ? Icons.visibility : Icons.visibility_off),
//                     onPressed: () {
//                       setState(() {
//                         _isObscure = !_isObscure;
//                       });
//                     }),
//               ),
//               controller: forgot_password,
//             ),
//             SizedBox(height: 20,),
//             TextField(
//               obscureText: _isObscure_conform,
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 // labelText: 'Password',
//                 errorText: _valconform_pwd ? "PassWord does not match":null,
//                 hintText: "Retype Password for Confirmation",
//                 hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
//                 suffixIcon: IconButton(
//                     icon: Icon(
//                         _isObscure_conform ? Icons.visibility : Icons.visibility_off),
//                     onPressed: () {
//                       setState(() {
//                         _isObscure_conform = !_isObscure_conform;
//                       });
//                     }),
//               ),
//               controller: conform_password,
//             ),
//             SizedBox(height: 10.0,),
//             RaisedButton(
//               color: Colors.green,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   // Icon(Icons.direc,color: Colors.white),
//                   Text('Submit',style: TextStyle(color: Colors.white,),),
//                 ],
//               ),
//               onPressed: (){
//
//                 setState(() {
//                   forgot_password.text.isEmpty?_valforgot_pwd = true:_valforgot_pwd = false;
//                   forgot_password.text.length <=5 ?pwd_length = true:pwd_length = false;
//                   (forgot_password.text != conform_password.text) ?
//                   _valconform_pwd = true : _valconform_pwd = false;
//                 });
//                 if(_valforgot_pwd == false && pwd_length == false && _valconform_pwd != true) {
//                   update_password(widget.userid, forgot_password.text,
//                       conform_password.text);
//                 }
//                 // if(_valconform_pwd){
//                 //   print(widget.userid);
//                 //   print(conform_password.text);
//                 //   // update_password(widget.userid,conform_password.text);
//                 // }
//                 // setState(() {
//                 //
//                 //   forgot_password.text.isEmpty?_valforgot_pwd = true:_valforgot_pwd = false;
//                 //   conform_password.text.isEmpty?_valconform_pwd =true:_valconform_pwd = false;
//                 //   forgot_password.text.length <=5 ?pwd_length = true:pwd_length = false;
//                 //   if(_valforgot_pwd == false && _valconform_pwd == false) {
//                 //     (forgot_password.text != conform_password.text) ?
//                 //     match = false : match = true;
//                 //   }
//                 //   print(match);
//                 //   // if(match){
//                 //   //
//                 //   //   change_password(widget.userid,conform_password.text,forgot_password.text);
//                 //   // }
//                 //
//                 // });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class EmailVerfication extends StatefulWidget {
  final String mobileno;
  final bool user_credentials;
  const EmailVerfication({Key key,this.mobileno,this.user_credentials}) : super(key: key);
  @override
  _EmailVerficationState createState() => _EmailVerficationState();
}

class _EmailVerficationState extends State<EmailVerfication> {

  final email = new TextEditingController();
  String Mobile_hashed;
  bool emailVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  // bool isemailValid = true;
  BottomLoader bl;
  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  static emailmask(String code) {

    final String first_part = code.split("@")[0];

    final String hashed_text = "xxxx";

    final String remove_string = first_part.substring(0, first_part.length - 4);

    return remove_string+hashed_text+code.split("@")[1];
    // final int length = code.length;
    // final int replaceLength = length - 2;
    // final String replacement = List<String>.generate((length / 4).ceil(), (int _) => 'xxxx').join('');
    //
    // return code.replaceRange(0, replaceLength, replacement);
  }
  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    var email = emailmask("diwaharsrd@gmail.com");
    print(email);
    // const String email = 'ka';
    // final bool isValid = EmailValidator.validate(email);
    //
    // print('Email is valid? ' + (isValid ? 'yes' : 'no'));

    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(widget.user_credentials);
    return Scaffold(
       body: Container(
          padding: EdgeInsets.only(left:25,right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("No credentials are found, with your mobile number $Mobile_hashed, Kindly provide email for cross verification"),
              ),
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
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    hintText: "Enter your Personal Email Only",
                    labelText: "Email",
                    // errorText: isemailValid ? "Invalid Email address":"a",
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: email,
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon(Icons.direc,color: Colors.white),
                    Text('Next',style: TextStyle(color: Colors.white,),),
                  ],
                ),
                onPressed:  isButtonEnabled?() {


                  // var variable = EmailValidator.validate(email.text);
                  //
                  // setState(() {
                  //   isemailValid = variable;
                  // });


                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => loginCredtionalMsg(
                           mobileno:widget.mobileno,
                            user_credtional:widget.user_credentials,
                            email:email.text
                          )));


                }:null,
              ),
            ],
          ),
        )
    );
  }
}

class distnictOTP extends StatefulWidget {
  final String mobileno;
  final String email;
  const distnictOTP({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _distnictOTPState createState() => _distnictOTPState();
}

class _distnictOTPState extends State<distnictOTP> {
  final otp = new TextEditingController();
  String Mobile_hashed;
  bool otp_validate = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 4){
                  setState(() {
                    otp_validate = false;
                  });
                }else{
                  setState(() {
                    otp_validate = true;
                  });
                }

              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: "OTP Received on your Mobile $Mobile_hashed",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


              ),
              controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Validate',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: otp_validate?(){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountList(
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
                // OTP_Validate(otp.text);
              }:null,
            ),


          ],
        ),
      ),
    );
  }
  // void OTP_Validate (OTP,user_id)async{
  //   bl = new BottomLoader(
  //     context,
  //     showLogs: true,
  //     isDismissible: true,
  //   );
  //   bl.style(
  //     message: 'Please wait...',
  //   );
  //   bl.display();
  //   var data = {
  //     'userId' : user_id,
  //     'otp' : OTP
  //   };
  //   var res = await Network().authData(data, '/OTPVerification');
  //   var body = json.decode(res.body);
  //
  //   if(body['message'] == "SUCCESS") {
  //     bl.close();
  //     Navigator.push(
  //       context,
  //       new MaterialPageRoute(
  //           builder: (context) => Forgot_Password(userid: user_id)
  //       ),
  //     );
  //
  //   }else{
  //     bl.close();
  //     Fluttertoast.showToast(
  //         msg: "OTP is Invalid",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         // timeInSecForIos: 1,
  //         backgroundColor: Colors.grey,
  //         textColor: Colors.black
  //     );
  //   }
  // }
}

class AccountList extends StatefulWidget {
  final String mobileno;
  final String email;
  const AccountList({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  bool selectradio = false;
  String noneofabove;
  int msg;
  @override
  Widget build(BuildContext context) {
    var mobileno = widget.mobileno;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("This mobile number $mobileno has these record on our system")),
            SizedBox(height: 20.0,),
            Text("By selecting one of them you ensure its your record and also you can edit and update spelling errors once you’re login"),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                // backgroundImage: AssetImage(widget.image),
                child: Text(
                    "P"),
                maxRadius: 20,
              ),
              title: Text("Nova paulraj Felix"),
              subtitle: Text("noxxxxfx@xxxpelxxx.in"),
              trailing: Radio(
                value: 1,
                groupValue: msg,
                onChanged: (int value) {
                  setState(() {
                    msg = value;
                    selectradio = true;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                // backgroundImage: AssetImage(widget.image),
                child: Text(
                    "F"),
                maxRadius: 20,
              ),
              title: Text("paulraj Felix"),
              subtitle: Text("noxxxxfx@xxxpelxxx.in"),
              trailing: Radio(
                value: 2,
                groupValue: msg,
                onChanged: (int value) {
                  setState(() {
                    msg = value;
                    selectradio = true;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("None of the above record is mine create a new account for me"),
              trailing: Radio(
                value: 3,
                groupValue: msg,
                onChanged: (int value) {

                  setState(() {
                    msg = value;
                    selectradio = true;
                  });
                },
              ),
            ),
            Divider(),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: selectradio ?(){

                if(msg != 3) {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EmailOTP(
                                  mobileno: widget.mobileno,
                                  email: widget.email
                              )));
                }else{
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountConformationMsg(
                                  mobileno: widget.mobileno,
                                  email: widget.email
                              )));
                }
              }: null,
            ),
          ],
        ),
      ),
    );
  }
}


class loginCredtionalMsg extends StatefulWidget {
  final String mobileno;
  final String email;
  final bool user_credtional;
  const loginCredtionalMsg({Key key,this.mobileno,this.user_credtional,this.email}) : super(key: key);
  @override
  _loginCredtionalMsgState createState() => _loginCredtionalMsgState();
}

class _loginCredtionalMsgState extends State<loginCredtionalMsg> {
  @override
  Widget build(BuildContext context) {
    print(widget.user_credtional);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("No user login information was found,")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("kindly fill the missing details and signup for a new account.")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Its our Pleasure to have you as user")),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
              },
            ),

          ],
        ),
      ),
    );
  }
}


class AccountConformationMsg extends StatefulWidget {
  final String mobileno;
  final String email;
  const AccountConformationMsg({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _AccountConformationMsgState createState() => _AccountConformationMsgState();
}

class _AccountConformationMsgState extends State<AccountConformationMsg> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("No user login information was found,")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("kindly fill the missing details and signup for a new account.")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Its our Pleasure to have you as user")),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
              },
            ),

          ],
        ),
      ),
    );
  }
}

class AccountVerfied extends StatefulWidget {
  final String mobileno;
  final String email;
  const AccountVerfied({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _AccountVerfiedState createState() => _AccountVerfiedState();
}

class _AccountVerfiedState extends State<AccountVerfied> {
  final mobileno = new TextEditingController();
  final email = new TextEditingController();
  bool selectradio = false;
  int msg;
  BottomLoader bl;
  void Account_conform() async{

    if(msg == 1) {
      bl = new BottomLoader(
        context,
        showLogs: true,
        isDismissible: true,
      );
      bl.style(
        message: 'Please wait...',
      );
      bl.display();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  NewAccountCreate1(
                      mobileno: widget.mobileno,
                      email: widget.email
                  )));
    }else{
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  Inconvenience(
                  )));
    }
    // var res = await Network().authData(data, '/login');
    // var body = json.decode(res.body);
    // if(body['status'] == '1'){
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => MainPage()
    //     ),
    //   );
    // }else{
    //   _showMsg(body['status']);
    // }
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      mobileno.text = widget.mobileno;
      email.text = widget.email;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text("Create a Account",style: TextStyle(color: Colors.grey),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,),onPressed: (){
            Navigator.of(context).pop();
          },
            ),
        ),
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TextField(
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'My Mobile No',
            //     // hintText: "OTP Received on your Mobile $Mobile_hashed",
            //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            //   ),
            //   controller: mobileno,
            // ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My MobileNo',
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(widget.mobileno),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My Email',
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(widget.email),
                ],
              ),
            ),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'My email',
            //     // hintText: "OTP Received on your Mobile $Mobile_hashed",
            //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            //   ),
            //   controller: email,
            // ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text('The above details are my personal mobile number and email'),
                leading: Radio(
                  value: 1,
                  groupValue: msg,
                  onChanged: (int value) {

                    setState(() {
                      msg = value;
                      selectradio = true;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text('The above details are  not mine, I use one or both the information of  my family member or it’s a official, which I may hand over on my exit'),
                leading: Radio(
                  value: 2,
                  groupValue: msg,
                  onChanged: (int value) {
                    setState(() {
                      msg = value;
                      selectradio = true;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: selectradio ?(){

                Account_conform();
                // if(msg == 1) {
                //   Navigator.push(context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               NewAccountCreate1(
                //                   mobileno: widget.mobileno,
                //                   email: widget.email
                //               )));
                // }else{
                //   Navigator.push(context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               Inconvenience(
                //               )));
                // }
              }: null,
            ),

          ],
        ),
      ),
    );
  }
}

class NewAccountCreate1 extends StatefulWidget {
  final String mobileno;
  final String email;
  NewAccountCreate1({ Key key,this.mobileno,this.email}): super(key: key);
  @override
  _NewAccountCreate1State createState() => _NewAccountCreate1State();
}

class _NewAccountCreate1State extends State<NewAccountCreate1> {

  List SalutionList = [{'id':1,"name":"Mr"},{"id":2,"name":"Ms"}];
  final FirstName = new TextEditingController();
  final MiddleName = new TextEditingController();
  final LastName = new TextEditingController();
  final Alias = new TextEditingController();
  int SalutionId;
  bool isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Create a Account",style: TextStyle(color: Colors.grey),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,),onPressed: (){
          Navigator.of(context).pop();
        },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Salution',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select Salution'),
                    items: SalutionList?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: SalutionId,
                    onChanged: (value) {
                      setState(() {
                        SalutionId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
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
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your First Name",
                labelText: "First Name",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: FirstName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Middle Name",
                labelText: "Middle Name",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: MiddleName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Last Name",
                labelText: "Last Name",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: LastName,
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                hintText: "Enter your Nick Name",
                labelText: "Nick Name or Alias",
                // errorText: phoneVal ? "Mobile Number is required":null,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
              controller: Alias,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  isButtonEnabled?() {

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => NewAccountCreate2(mobileno:widget.mobileno,email:widget.email,
                            salution:SalutionId,first_name:FirstName.text,middle_name:MiddleName.text,alisas:Alias.text,last_name: LastName.text,
                        )));

              }:null,
            ),
          ],
        ),
      ),

    );
  }
}

class NewAccountCreate2 extends StatefulWidget {
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final String mobileno;
  final String email;
  const NewAccountCreate2({Key key,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.mobileno,this.email}) : super(key: key);
  @override
  _NewAccountCreate2State createState() => _NewAccountCreate2State();
}

class _NewAccountCreate2State extends State<NewAccountCreate2> {

  List Gender = [{'id':1,"name":"Male"},{"id":2,"name":"Female"},{"id":3,"name":"Third Gender"}];
  List BloodGroup = [{'id':1,"name":"B+"},{"id":2,"name":"B-"},{"id":3,"name":"A+"}];
  BottomLoader bl;
  final DOB = new TextEditingController();
  int GenderId;
  int BloodGroupId;
  bool isButtonEnabled = false;

  void OTP_send() async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'pId' : "",
      'pFirstName' : widget.first_name,
      'pMiddleName':widget.middle_name,
      'pLastName':widget.last_name,
      'pAlias':widget.alisas,
      'pDob':DOB.text,
      'pGender':GenderId,
      'pBloodGroup':BloodGroupId,
      'pPersonEmail':widget.email,
      'mobile_no':widget.mobileno
    };

    var res = await Network().authData(data, '/createPersonTmpFile');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => NewAccountCreateOTP(mobileno:widget.mobileno,email:widget.email,
                  salution:widget.salution,first_name:widget.first_name,middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:GenderId,Dob:DOB.text,bloodgroup:BloodGroupId
              )));
    }

  }

  Future<String> _projectData() async {
    // var res = await Network().projectCreate('/projectCreate/$orgId');
    // var body = json.decode(res.body);
  }


  @override
  void initState() {
    super.initState();
    // GetData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Create a Account",style: TextStyle(color: Colors.grey),),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,),onPressed: (){
          Navigator.of(context).pop();
        },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Gender',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select'),
                    items: Gender?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: GenderId,
                    onChanged: (value) {
                      setState(() {
                        GenderId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            TextField(
              readOnly: true,
              controller: DOB,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Pick Date',
                labelText: 'DOB',
                labelStyle: TextStyle(fontSize: 14.0),
                hintStyle: TextStyle(fontSize: 14.0),
                // suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
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
                DOB.text = date.toString().substring(0,10);
              },),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Blood Group',
                    style: TextStyle(),
                  ),
                  DropdownButton(
                    hint: Text('Select'),
                    items: BloodGroup?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'],
                      );
                    })?.toList() ?? [],
                    value: BloodGroupId,
                    onChanged: (value) {
                      setState(() {
                        BloodGroupId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  () {
                OTP_send();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewAccountCreateOTP extends StatefulWidget {

  final String mobileno;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;
  final String email;
  const NewAccountCreateOTP({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email}) : super(key: key);
  @override
  _NewAccountCreateOTPState createState() => _NewAccountCreateOTPState();
}

class _NewAccountCreateOTPState extends State<NewAccountCreateOTP> {
  final otp = new TextEditingController();
  String Mobile_hashed;
  bool otp_validate = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 4){
                  setState(() {
                    otp_validate = false;
                  });
                }else{
                  setState(() {
                    otp_validate = true;
                  });
                }

              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: "OTP Received on your Mobile $Mobile_hashed",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


              ),
              controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Validate',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: otp_validate?(){
                OTP_Validate();
              }:null,
            ),

          ],
        ),
      ),
    );
  }
  void OTP_Validate ()async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'mobile_no' : widget.mobileno,
      'otp' : otp.text
    };


    var res = await Network().authData(data, '/getTmpPersonFile');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AccountCreatePasswordSet(mobileno:widget.mobileno,email:widget.email,salution:widget.salution,first_name:widget.first_name,
              middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:widget.gender,Dob:widget.Dob,bloodgroup:widget.bloodgroup,
            )
        ),
      );
    }else{
      bl.close();
      Fluttertoast.showToast(
          msg: "OTP is Invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
    }
  }
}

class AccountCreatePasswordSet extends StatefulWidget {

  final String mobileno;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;
  final String email;
  const AccountCreatePasswordSet({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email}) : super(key: key);
  @override
  _AccountCreatePasswordSetState createState() => _AccountCreatePasswordSetState();
}

class _AccountCreatePasswordSetState extends State<AccountCreatePasswordSet> {

  final forgot_password = new TextEditingController();
  final conform_password = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure_conform = true;
  bool _valforgot_pwd = false;
  bool _valconform_pwd = false;
  bool pwd_length = false;
  bool match = false;
  bool msg = false;
  bool validpwd = false;
  bool pwdmatch = false;
  BottomLoader bl;

  void update_password (userid,pwd,conform_pwd)async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'userId' : userid,
      'new_password' : pwd,
      'new_confirm_password':conform_pwd
    };
    var res = await Network().authData(data, '/updatePassword');
    var body = json.decode(res.body);
    // if(body['message'] == "SUCCESS") {
    //   bl.close();
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => LoginPageTwo()
    //     ),
    //   );
    //   Fluttertoast.showToast(
    //       msg: "Password has been Updated!!",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       // timeInSecForIos: 1,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black
    //   );
    //
    // }else{
    //   bl.close();
    //   Fluttertoast.showToast(
    //       msg: "Server error.Contact Admin",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       // timeInSecForIos: 1,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black
    //   );
    // }
  }
  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (val){

                if (val.length <= 5){


                  setState(() {
                    validpwd = false;
                  });
                }else{

                  setState(() {
                    validpwd = true;
                  });
                }
              },
              obscureText: _isObscure,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                errorText: validpwd?null:"Password atleast 6 digit must",
                hintText: "Enter New Password",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
              ),
              controller: forgot_password,
            ),
            SizedBox(height: 20,),
            Visibility(
              visible: validpwd,
              child: TextField(
                onChanged: (val){

                  if (val != forgot_password.text){


                    setState(() {
                      pwdmatch = false;
                    });
                  }else{

                    setState(() {
                      pwdmatch = true;
                    });
                  }
                },
                obscureText: _isObscure_conform,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // labelText: 'Password',
                  // errorText: pwdmatch ? "PassWord does not match":null,
                  hintText: "Retype Password for Confirmation",
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure_conform ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure_conform = !_isObscure_conform;
                        });
                      }),
                ),
                controller: conform_password,
              ),
            ),
            SizedBox(height: 30.0,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Sign Up',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: pwdmatch?(){

                // setState(() {
                //   forgot_password.text.isEmpty?_valforgot_pwd = true:_valforgot_pwd = false;
                //   forgot_password.text.length <=5 ?pwd_length = true:pwd_length = false;
                //   (forgot_password.text != conform_password.text) ?
                //   _valconform_pwd = true : _valconform_pwd = false;
                // });
                // if(_valforgot_pwd == false && pwd_length == false && _valconform_pwd != true) {
                //   setState(() {
                //     msg = true;
                //   });
                  // update_password(widget.userid, forgot_password.text,
                  //     conform_password.text);
                // }
                // if(_valconform_pwd){
                //   print(widget.userid);
                //   print(conform_password.text);
                //   // update_password(widget.userid,conform_password.text);
                // }
                // setState(() {
                //
                //   forgot_password.text.isEmpty?_valforgot_pwd = true:_valforgot_pwd = false;
                //   conform_password.text.isEmpty?_valconform_pwd =true:_valconform_pwd = false;
                //   forgot_password.text.length <=5 ?pwd_length = true:pwd_length = false;
                //   if(_valforgot_pwd == false && _valconform_pwd == false) {
                //     (forgot_password.text != conform_password.text) ?
                //     match = false : match = true;
                //   }
                //   print(match);
                //   // if(match){
                //   //
                //   //   change_password(widget.userid,conform_password.text,forgot_password.text);
                //   // }
                //
                // });
              }:null,
            ),
            SizedBox(height: 20.0,),
            Visibility(
              visible: pwdmatch,
              child: RichText(
                text: TextSpan(
                style: defaultStyle,
                children: <TextSpan>[
              TextSpan(text: 'By clicking Sign Up, you agree to our '),
              TextSpan(
                  text: 'Term,',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Terms of Service"');
                    }),
                  TextSpan(
                      text: 'Data Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Terms of Service"');
                        }),
              TextSpan(text: ' and  '),
              TextSpan(
                  text: 'Cookie Policy',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Privacy Policy"');
                    }),
                  TextSpan(text: ' Also you agree to send and receive SMS and Email notification from us.'),
          ],
        ),
      ),
            )

          ],
        ),
      ),
    );
  }
}

class Inconvenience extends StatefulWidget {
  @override
  _InconvenienceState createState() => _InconvenienceState();
}

class _InconvenienceState extends State<Inconvenience> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("Sorry for the inconvenience caused, we need a unique mobile number owned by you to signup our system.")),
            SizedBox(height: 50.0,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmailOTP extends StatefulWidget {
  final String mobileno;
  final String email;
  EmailOTP({ Key key,this.mobileno,this.email}): super(key: key);
  @override
  _EmailOTPState createState() => _EmailOTPState();
}

class _EmailOTPState extends State<EmailOTP> {
  bool otp_validate = false;

  static getPayCardStr(String code) {

    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }
  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    print(widget.email);

    // setState(() {
    //   Mobile_hashed = number;
    // });
  }
  @override
  Widget build(BuildContext context) {
    var email = widget.email;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 4){
                  setState(() {
                    otp_validate = false;
                  });
                }else{
                  setState(() {
                    otp_validate = true;
                  });
                }

              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: "OTP Received on your Email $email",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


              ),
              // controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Validate',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: otp_validate?(){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(mobileno:widget.mobileno,email:widget.email)));
              }:null,
            ),
          ],
        ),
      ),
    );
  }
}








