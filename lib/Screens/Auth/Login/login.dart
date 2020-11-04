import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tkt/Screens/Auth/signup.dart';
import 'package:tkt/Screens/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:tkt/constants.dart';
import '../../../utils.dart';
import '../SignUp/signupverify.dart';

ProgressDialog pr;


// Create storage
final storage = new FlutterSecureStorage();
const String _storageKeyMobileToken = "token";
const String _storageKeyKivToken = "kiv";
const String _storageKeyKspToken = "ksp";
const String _storageNum = "phonenumber";


const String _processKeyKiv = "processKiv";
const String _processKeyKsp = "processKsp";


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final _phoneController = TextEditingController();
 

  final _formKey = GlobalKey<FormState>();
  String _kiv = "";
  String _ksp = "";
  String _keycode = "1234567";
  

class _LoginState extends State<Login> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> _processKey1(String processKiv) async {
  final SharedPreferences prefs = await _prefs;
  

  return prefs.setString(_processKeyKiv, processKiv);
}

Future<bool> _setNumber(String phonenumber) async {
  final SharedPreferences prefs = await _prefs;
  

  return prefs.setString(_storageNum, phonenumber);
}


Future<bool> _processKey2(String processKsp) async {
  final SharedPreferences prefs = await _prefs;
  

  return prefs.setString(_processKeyKsp, processKsp);
}

Future<bool> _setMobileToken(String token) async {
  final SharedPreferences prefs = await _prefs;
  

  return prefs.setString(_storageKeyMobileToken, token);
}



  




   _makeSecurityRequest() async {
    String url = '$baseUrl/auth/sec';
   

    Map<String, dynamic> body = {'keyCode':'$_keycode'};

      Response response = await post(url, body: body);
    // check the status code for the result
    int statusCode = response.statusCode;
    var responseBody = response.body;

    final cbody = json.decode(responseBody);

    print(cbody);

    if(statusCode == 200) {
      setState(() {
        _kiv = cbody['kiv'];
        _ksp = cbody['ksp'];
        
        
      });
    }  else {
      throw new Exception("Network busy..try again next time");
    }

    // this API passes back the id of the new item added to the body
    String abody = response.body;

    print(abody);
    print("kiv : $_kiv");
    print("ksp : $_ksp");
  }

   _checkWhetherRegistered(String phone_num) async {

    String url = '$baseUrl/auth/check-phone';
    Map<String, String> headers = {
      "kiv":"$_kiv", 
      "ksp":"$_ksp", 
      "keycode": "$_keycode",
      

    };

    Map<String, dynamic> body = {'phoneNum': phone_num, 'countryCode': 'gh'};

     Response response = await post(url, headers: headers, body: body);

      var rspBody = response.body;
      print(rspBody);
      var decodedbody = json.decode(rspBody);
     print(decodedbody);
    // check the status code for the result
    
    var statuscode = decodedbody['statusCode'];

    if (statuscode == "200") {
         

            var responseBody = response.body;
            final cbody = json.decode(responseBody);

            
      var message = cbody['message'];

      
     

        await _setMobileToken(cbody['OTP-CODE']);
        await _processKey1("$_kiv");
      await _processKey2("$_ksp");
      
      await _setNumber("$phone_num");

      pr.hide();
        

        // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpVerify()));

              // dont set otp because user has not registered
              // await _setMobileToken(cbody['OTP-CODE']);
        
        // print(cbody['OTP-CODE']);

        // this API passes back the id of the new item added to the body
      

          
    }

    else if(statuscode == "500" ) {
     

     
      await _processKey1("$_kiv");
      await _processKey2("$_ksp");
      await _setNumber("$phone_num");
      

      
      Navigator.push(
          context,
          // you change it to OTP() view for IOS version
          MaterialPageRoute(builder: (context) => Home()),
        );


      
    }

    

  
  }


   bool _validate = false;

   String validatePhone(String value) {
   String patttern = r'\+?\d+';
                              RegExp regExp = new RegExp(patttern);
                              if (!regExp.hasMatch(value)) {
                                return 'Please enter a valid mobile number';
                              } else if (value.length < 9) {

                                return 'Please enter a valid mobile number';

                              }
                              return null;
  
}

@override
  void initState() {
    _makeSecurityRequest();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     final _phoneController = TextEditingController();
  
    performLoginWithoutPassword() async {
      String phoneNum = _phoneController.text;
      String trim = phoneNum.substring(phoneNum.length - 9);
      print("+233$trim");

      pr = new ProgressDialog(context,type: ProgressDialogType.Normal);

      pr.style(message: 'Showing some progress...');

    // Write value 
      await storage.write(key: "phony", value: "$trim");
    
    //Optional
    pr.style(
          message: 'Authenticating +233$trim...',
          borderRadius: 4.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(strokeWidth: 2.0),
          elevation: 5.0,
          insetAnimCurve: Curves.easeInOut,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 8, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600),
        );

        if (_formKey.currentState.validate()) {
        pr.show();


        
        
          _checkWhetherRegistered("+233$trim");

        
        
      } else {
        throw new Exception("Forms error");
      }



    }
   

    const color1 = Color.fromRGBO(92, 72, 213, 0.7);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);

    final hh = MediaQuery.of(context).size.height;
    final ww = MediaQuery.of(context).size.width;
    

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: ww, 
            height: hh,
            color: color1,
            child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25,  left: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Welcome !",
                          style: kTitleStyle.copyWith(fontSize: 40, color: Colors.white),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
          ), 

          SingleChildScrollView(
              child: Container(
              width: ww, 
              height: hh * 0.65, 
              margin: EdgeInsets.only(top: hh * 0.35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
              ),

              child: Form(
                key: _formKey, 

                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Container(
                          width: 320,
                          padding: EdgeInsets.all(2.0),
                          child: TextFormField(
                            controller: _phoneController,
                            
                            // validator: (value) {
                            //   String patttern = r'\+?\d+';
                            //   RegExp regExp = new RegExp(patttern);
                            //   if (value.length == 0) {
                            //     return 'Please enter mobile number';
                            //   } else if (!regExp.hasMatch(value)) {
                            //     return 'Please enter a valid mobile number';
                            //   }
                            //   return null;
                            // },
                            
                            keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                            ],
                            // autocorrect: true,
                            decoration: InputDecoration(
                             errorText: _validate ? validatePhone(_phoneController.text) : null,
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone_iphone),
                              hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "Raleway",
                                  fontSize: 14),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 8),
                      //   child: Container(
                      //     width: 320,
                      //     padding: EdgeInsets.all(2.0),
                      //     child: TextFormField(
                      //       controller: _passwordController, obscureText: true,
                      //       validator: (value) {
                      //         String patttern = r'^.{3,20}$';
                      //         RegExp regExp = new RegExp(patttern);
                      //         if (value.length == 0) {
                      //           return 'Please enter password';
                      //         } else if (value.length < 3) {
                      //           return 'Password should be more than 3 characters';
                      //         } else if (!regExp.hasMatch(value)) {
                      //           return 'Please enter valid password';
                      //         }
                      //         return null;
                      //       },
                      //       // autocorrect: true,
                      //       decoration: InputDecoration(
                      //         hintText: 'Password',
                      //         prefixIcon: Icon(Icons.lock),
                      //         hintStyle: TextStyle(
                      //             color: Colors.blueGrey,
                      //             fontFamily: "Raleway",
                      //             fontSize: 14),
                      //         filled: true,
                      //         fillColor: Colors.white70,
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(8.0)),
                      //           borderSide:
                      //               BorderSide(color: Colors.grey, width: 0.5),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(8.0)),
                      //           borderSide:
                      //               BorderSide(color: Colors.grey, width: 0.5),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 2),
                      //   width: 320,
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: <Widget>[
                      //         Text(
                      //           "Forget Password?",
                      //           style: TextStyle(
                      //               fontFamily: "Raleway",
                      //               fontSize: 11,
                      //               color: Colors.blueGrey),
                      //         )
                      //       ]),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: (() => {
                            // setState(() {

                            //   _validate = true;
                            // }),

                            performLoginWithoutPassword()
                                // with password
                                // _performLogin(),

                                // without password
                                // _performLoginWithoutPassword()
                               
                              }),
                          child: Container(
                            alignment: Alignment.center,
                            width: 180,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.5)),
                              color: color1,
                            ),
                            child: Text("SignUp Or Login",
                                style: kTitleStyle.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Text(
                      //           "Don't have an account? ",
                      //           style: TextStyle(
                      //               fontFamily: "Raleway", fontSize: 12),
                      //         ),
                      //         FlatButton(
                      //             onPressed: () => {
                      //                   Navigator.push(
                      //                     context,
                      //                     // you change it to OTP() view for IOS version
                      //                     MaterialPageRoute(
                      //                         builder: (context) => Signup()),
                      //                   )
                      //                 },
                      //             child: Text(
                      //               'Register Now',
                      //               style: TextStyle(
                      //                   color: Colors.blue,
                      //                   fontFamily: "Raleway",
                      //                   fontSize: 12),
                      //             )),
                      //       ]),
                      // )
                    ],
                  ),

              )

            ),
          )


      ],)
      
    );
  }
}