import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/task/task_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/auth/Person/Person.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage  extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage > {
  final phoneNo = new TextEditingController();
  bool phoneVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  BottomLoader bl;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  @override

  void _mobile_no_check(mobile_no) async{
    // setState(() {
    //   _isLoading = true;
    // });
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



    if(body['message'] == "SUCCESS"){


      if(body['data']['pId'] != ''){


        if(body['data']['pHavingUser']){

          var Name = body['data']['pFirstName'] + body['data']['pMiddleName'];
              bl.close();
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPageTwo(
                              mobileno: mobile_no,
                              name: Name,
                              user_id: body['data']['pId']
                          )));
        }else{

          bl.close();
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      EmailVerfication(
                          mobileno: mobile_no,
                          user_credentials : true
                      )));
        }
      }else{
        bl.close();
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailVerfication(
                              mobileno: mobile_no,
                              user_credentials : false
                            )));
      }
      // if(body['data']['pId'] != '') {
      //   if (body['data']['pPersonUserDetails'] != null) {
      //     var Name = body['data']['pFirstName'] + body['data']['pMiddleName'];
      //     bl.close();
      //     Navigator.push(context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 LoginPageTwo(
      //                     mobileno: mobile_no,
      //                     name: Name,
      //                     user_id: body['data']['pId']
      //                 )));
      //   } else {
      //
      //       if(body['data']['pId'] == ''){
      //         bl.close();
      //
      //         Navigator.push(context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     EmailVerfication(
      //                       mobileno: mobile_no,
      //                       user_credentials : false
      //                     )));
      //
      //       }else{
      //
      //         bl.close();
      //         Navigator.push(context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     EmailVerfication(
      //                       mobileno: mobile_no,
      //                       user_credentials : true
      //                     )));
      //
      //
      //       }
      //   }
      // }
      // }else{
      //   bl.close();
      //   Navigator.push(context,
      //       MaterialPageRoute(
      //           builder: (context) => EmailVerfication(
      //               mobileno:mobile_no,
      //           )));
      // }

    }

    // if(body['status'] == '1'){
    //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   localStorage.setString('token', json.encode(body['token']));
    //   localStorage.setString('user', json.encode(body['user']));
    //   localStorage.setString('allData', json.encode(body));
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

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange,
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orange,fontStyle: FontStyle.italic,fontSize: 60.0),),
            Text("Version:beta",style: TextStyle(color: Colors.grey),),

            SizedBox(height: 70.0,),
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(50.0),
            //     child: Image(image: AssetImage('assets/logo.jpg'),height: 160,width: 160,)
            // ),
            Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InternationalPhoneNumberInput(

                    onInputChanged: (PhoneNumber number) {

                      if (number.phoneNumber.trim().isEmpty || number.phoneNumber.length != 13){
                        setState(() {
                          isButtonEnabled = false;
                        });
                      }else{
                        setState(() {
                          isButtonEnabled = true;
                        });
                      }

                    },

                    onInputValidated: (bool value) {

                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: phoneNo,
                    formatInput: false,
                    keyboardType:
                    TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ],
              ),
            ),
            // TextField(
            //   onChanged:(val){
            //
            //     if (val.trim().isEmpty || val.length != 10){
            //       setState(() {
            //         isButtonEnabled = false;
            //       });
            //     }else{
            //       setState(() {
            //         isButtonEnabled = true;
            //       });
            //     }
            //
            //   },
            //   keyboardType: TextInputType.number,
            //   obscureText: false,
            //   decoration: InputDecoration(
            //     // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            //     hintText: "Enter your Personal Mobile Number Only",
            //     labelText: "Mobile No",
            //     prefixIcon: const Icon(
            //       Icons.phone_android,
            //       color: Colors.blue,
            //     ),
            //     // errorText: phoneVal ? "Mobile Number is required":null,
            //     errorText: phoneVal?"Mobile number is required":invalidphone? "InValid Mobile Number":null
            //
            //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            //   ),
            //   controller: phoneNo,
            // ),
            // TextFormField(
            //     controller: phoneNo,
            //     decoration: new InputDecoration(
            //         labelText: "quantity"
            //     ),
            //     // keyboardType: TextInputType.numberWithOptions(decimal: true),
            //     autovalidate: false,
            //     validator: (value) {
            //       if (value.isEmpty) {
            //         isValid  = false;
            //         return "the quantity cannot be empty";
            //       }  else {
            //         isValid = true;
            //         return null;
            //       }
            //     }
            // ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orangeAccent,
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
            SizedBox(height: 20,),
            Center(
              child: Text("Don’t have a Login yet, Enter your Mobile Number and click Next to  Signup for a New Account",style: TextStyle(fontStyle: FontStyle.italic),),)
          ],
        ),
      ),

    );
  }
}

class LoginPageTwo extends StatefulWidget {
  final String name;
  final String mobileno;
  final int user_id;
  const LoginPageTwo({Key key,this.mobileno,this.name,this.user_id}) : super(key: key);
  @override
  _LoginPageTwoState createState() => _LoginPageTwoState();
}

class _LoginPageTwoState extends State<LoginPageTwo> {
  final password = new TextEditingController();
  bool pwdVal = false;
  bool isButtonEnabled = false;
  bool _isObscure = true;
  bool _isLoading = false;
  BottomLoader bl;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'back',
        onPressed: () {
          MaterialPageRoute(
              builder: (context) => LoginPage(
              ));
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var user_name = widget.name;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orange,fontStyle: FontStyle.italic,fontSize: 60.0),),
            Text("Version:beta",style: TextStyle(color: Colors.grey),),

            SizedBox(height: 70.0,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Hi! $user_name",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.right,),),
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
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: "Enter Password",
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.blue,
                ),
                suffixIcon: isButtonEnabled?IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }):null,
                errorText: pwdVal ? "PassWord is required":null,
              ),
              controller: password,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.login_outlined,color: Colors.white),
                  Text(_isLoading? 'Proccessing...' : 'Login',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed:  isButtonEnabled?() {
                setState(() {
                  password.text.isEmpty?pwdVal = true:pwdVal = false;
                  if(pwdVal == false){
                    _login();
                  }
                });


              }:null,
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){

              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.orange,
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0) //                 <--- border radius here
                    ),
                  ),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => EmailVerfication(
                                mobileno: widget.mobileno,
                              )
                          ),
                        );
                      },
                        child: Text("I’m not $user_name, I don’t have a password yet Signup for a New Account",style: TextStyle(color: Colors.orange),))),),
            ),

            // InkWell(child:  Align(
            //   alignment: Alignment.centerRight,
            //   child: Text("forgot password?",style: TextStyle(color: Colors.blue),),),
            //   onTap: (){
            //       forgot_password(widget.user_id,widget.mobileno);
            //   },
            // ),
            SizedBox(height: 20,),
            // RichText(
            //   text: TextSpan(
            //     text: "I'm not $user_name, I don't have a passoword yet'\n",
            //     style: TextStyle(
            //       color: Colors.grey,),
            //     children: <TextSpan>[
            //       TextSpan(
            //           text: 'Sign up for a New Account',
            //           style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
            //     ],
            //   ),
            // ),

            // Text("I'm not $user_name, I don't have a passoword yet"),
            // InkWell(child: Center(child: Text("Sign up for a New Account",style: TextStyle(color: Colors.blue),),),
            //   onTap: (){
            //
            // },
            // )
          ],
        ),
      ),
    );
  }
  void _login() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'mobile' : widget.mobileno,
      'password' : password.text
    };

    Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => WrongPassword(
                  name:widget.name,
                  mobileno: widget.mobileno,
                  userid: widget.user_id,
                )
            ),
          );
    // var res = await Network().authData(data, '/login');
    // var body = json.decode(res.body);
    //
    // if(body['status'] == '1'){
    //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   localStorage.setString('token', json.encode(body['token']));
    //   localStorage.setString('user', json.encode(body['user']));
    //   localStorage.setString('allData', json.encode(body));
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => MainPage()
    //     ),
    //   );
    // }else{
    //   _showMsg(body['status']);
    // }

    setState(() {
      _isLoading = false;
    });

  }

}

class WrongPassword extends StatefulWidget {
  final String mobileno;
  final String name;
  final int userid;
  const WrongPassword({Key key,this.mobileno,this.userid,this.name}) : super(key: key);
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

    var data = {"userId": user_id};
    print(data);
    var res = await Network().authData(data, '/sendOtpForgetPassword');
    var body = json.decode(res.body);
    print(body);
    if(body['message'] == 'SUCCESS'){
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => OTP(
                  mobileno:mobile_no,
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
  final String mobileno;
  final int userid;
  const OTP({Key key,this.mobileno,this.userid}) : super(key: key);
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
    var data = {
      'userId' : user_id,
      'otp' : OTP
    };
    var res = await Network().authData(data, '/OTPVerification');
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
    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => LoginPageTwo()
        ),
      );
      Fluttertoast.showToast(
          msg: "Password has been Updated!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
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
          ],
        ),
      ),
    );
  }
}






