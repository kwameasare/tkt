import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Animation/FadeAnimation.dart';
import 'package:tkt/Screens/Auth/SignUp/signupverify.dart';
import 'package:tkt/utils.dart';

import '../../../constants.dart';
String kiv = "";
String ksp = "";
String keycode = "";
bool signin = false;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


class SignUpPage2 extends StatefulWidget {
  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {

  final _phoneController = TextEditingController();

   _checkPhoneRequest(String number) async {
     setState(() {
       signin = true;
     });
    String url = '$baseUrl/auth/check-phone';
    print(url);
    Map<String, String> headers = {
      "kiv": kiv,
      "ksp": ksp,
      "keyCode": keycode,
    };

    print(keycode);

    Map<String, dynamic> body = {
      'phoneNum': number,
      'countryCode': 'gh'
    };

    Response response = await post(url, headers: headers, body: body);
    // check the status code for the result
    int statusCode = response.statusCode;

    String abody = response.body;
    final cbody = json.decode(abody);

    print(cbody);
    if (cbody["statusCode"] == "200") {
      var responseBody = response.body;

      final cbody = json.decode(responseBody);

      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpVerify(cbody['OTP-CODE'], kiv, ksp, keycode, number, "signup")));

      // print(cbody['OTP-CODE']);

      // this API passes back the id of the new item added to the body
      String abody = response.body;

      print(abody);
    } else {
      setState(() {
        signin = false;
      });
      showMessage(context, cbody["data"], "OOPS...");
      // throw new Exception("Network busy..try again next time");
    }
  }

  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
      
    });
    print(kiv);
  }

  @override
  void dispose() {
    setState(() {
      signin = false;
    });
    // TODO: implement dispose
    super.dispose();
  }
  

  @override
  void initState() {
    setState(() {
      signin = false;
    });
    
    getValue();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Phone number",
                                        hintStyle: kTitleStyle.copyWith(
                                            color: Colors.grey[400])),
                                  ),
                                ),
                                // Container(
                                //   padding: EdgeInsets.all(8.0),
                                //   child: TextField(
                                //     decoration: InputDecoration(
                                //       border: InputBorder.none,
                                //       hintText: "Password",
                                //       hintStyle: kTitleStyle.copyWith(color: Colors.grey[400])
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      signin ? FadeAnimation(
                          2,
                          InkWell(
                            onTap: () {
                              
                            },
                                                      child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: color1),
                              child: Center(
                                child: Text(
                                  "Checking Phone!!",
                                  style: kTitleStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )) : FadeAnimation(
                          2,
                          InkWell(
                            onTap: () {
                              _checkPhoneRequest(_phoneController.text);
                            },
                                                      child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: color1),
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: kTitleStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
