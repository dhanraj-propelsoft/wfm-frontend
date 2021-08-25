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
import 'package:propel/auth/ForgotPassword/forgot_password.dart';
import 'package:propel/auth/Person/distnict_data.dart';


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


    print(body);
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
                              user_id: body['data']['pPersonUserDetails']['id'],
                              user_credentials : true,
                              email:body['data']['pPersonEmailDetails']['email']


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


    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange,
      body: Container(
        padding: EdgeInsets.only(left:25,right: 20),
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
  final bool user_credentials;
  final String email;
  const LoginPageTwo({Key key,this.mobileno,this.name,this.user_id,this.user_credentials,this.email}) : super(key: key);
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

                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => distnictOTP(
                                    mobileno:widget.mobileno,
                                    email:widget.email
                                )));

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
      'mobile' : widget.mobileno,
      'password' : password.text
    };



    var res = await Network().authData(data, '/wfmlogin');
    var body = json.decode(res.body);


    if(body['status'] == 1){

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
      Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => WrongPassword(
                    name:widget.name,
                    mobileno: widget.mobileno,
                    userid: widget.user_id,
                    email:widget.email
                  )
              ),
            );

    }



  }

}








