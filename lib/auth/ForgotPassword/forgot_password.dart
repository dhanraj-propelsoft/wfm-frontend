import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/task/task_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';


class WrongPassword extends StatefulWidget {
  final String mobileno;
  final String name;
  final int userid;
  final String email;
  const WrongPassword({Key key,this.mobileno,this.userid,this.name,this.email}) : super(key: key);
  @override
  _WrongPasswordState createState() => _WrongPasswordState();
}

class _WrongPasswordState extends State<WrongPassword> {
  BottomLoader bl;


  void forgot_password(user_id,mobile_no) async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    // var data = {"userId": user_id};
    //
    // var res = await Network().authData(data, '/sendOtpForgetPassword');
    var data = {"email_id":widget.email,"name":widget.name};
    var res = await Network().authData(data, '/sendotp_email');
    var body = json.decode(res.body);


    if(body['status'] == 1){
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => OTP(
                  email:widget.email,
                  userid:user_id
              )));
    }
  }
  @override
  Widget build(BuildContext context) {
    var user_name = widget.name;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.topLeft,
              child: Text("Hi! $user_name",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),),),
            SizedBox(height: 40.0,),
            Center(child: Text("Hope you had entered wrong Password you can  try again or else Reset through Forget Password")),
            SizedBox(height: 40.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.direc,color: Colors.white),
                      Text('Try Again',style: TextStyle(color: Colors.white,),),
                    ],
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.direc,color: Colors.white),
                      Text('Forgot Password',style: TextStyle(color: Colors.white,),),
                    ],
                  ),
                  onPressed: (){
                    forgot_password(widget.userid, widget.mobileno);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OTP extends StatefulWidget {
  final String email;
  final int userid;
  const OTP({Key key,this.email,this.userid}) : super(key: key);
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
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
    print(widget.email);
    var number = getPayCardStr(widget.email);

    setState(() {
      Mobile_hashed = number;
    });
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
              controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orangeAccent,
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

                OTP_Validate(otp.text,widget.userid);
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
    // var data = {
    //   'userId' : user_id,
    //   'otp' : OTP
    // };
    // var res = await Network().authData(data, '/OTPVerification');
    var data = {
      'email_id' : widget.email,
      'otp':otp.text
    };
    var res = await Network().authData(data, '/verifiy_email_otp');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Forgot_Password(userid: user_id)
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

class Forgot_Password extends StatefulWidget {
  final int userid;
  const Forgot_Password({Key key,this.userid}) : super(key: key);
  @override
  _Forgot_PasswordState createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
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

  void update_password (userid,pwd)async{

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
      'password' : pwd,
    };
    var res = await Network().authData(data, '/updatePassword_and_login');
    var body = json.decode(res.body);


    if(body['status'] == 1) {

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('allData', json.encode(body));
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MainPage()
        ),
      );

    }else{
      bl.close();
      Fluttertoast.showToast(
          msg: "Server error.Contact Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
    }
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
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Login',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: pwdmatch?(){

                update_password(widget.userid,conform_password.text);
              }:null,
            ),
          ],
        ),
      ),
    );
  }
}