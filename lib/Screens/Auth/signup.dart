import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkt/Screens/mlpage.dart';
import 'package:tkt/constants.dart';
import 'package:tkt/utils.dart';

class Signup extends StatefulWidget {
  final String phone;
  const Signup(this.phone);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  // final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    void _checkInfo() {
      if (_fullNameController.text.length != 0 &&
          _emailController.text.length != 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MlPage(_fullNameController.text,
                    _emailController.text, widget.phone)));
      } else {
        showMessage(context, "Please provide valid Information.", "OOPS ... ");
      }
    }

    final hh = MediaQuery.of(context).size.height;
    final ww = MediaQuery.of(context).size.width;
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    return Scaffold(

        // floatingActionButton: FloatingActionButton.extended(
        //             onPressed: () {},
        //             icon: Icon(Icons.face, color: Colors.white, size:30),
        //             label: Text("Take Picture"),
        //           ),
        body: Stack(
      children: <Widget>[
        Container(
          height: hh * 0.34,
          width: ww,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
              color: color1
              //  gradient: LinearGradient(
              //                 colors: [
              //                   Color.fromRGBO(143, 148, 251, 1),
              //                   Color.fromRGBO(143, 148, 251, .6),
              //                 ]
              //               ),
              // gradient: LinearGradient(
              // begin: Alignment.bottomLeft,
              // end: Alignment.topRight,
              // colors: [color1, color2])
              ),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.18, left: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Add Information",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Futura",
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
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
            height: hh * 0.82,
            margin: EdgeInsets.only(top: hh * 0.25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
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
                        controller: _fullNameController,

                        // autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: Icon(Icons.verified_user),
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

                  //   Padding(
                  //   padding: EdgeInsets.only(top: 8),
                  //   child: Container(
                  //     width: 320,
                  //     padding: EdgeInsets.all(2.0),
                  //     child: TextFormField(
                  //       controller: _phoneController,

                  //       // validator: (value) {
                  //       //   String patttern = r'\+?\d+';
                  //       //   RegExp regExp = new RegExp(patttern);
                  //       //   if (value.length == 0) {
                  //       //     return 'Please enter mobile number';
                  //       //   } else if (!regExp.hasMatch(value)) {
                  //       //     return 'Please enter a valid mobile number';
                  //       //   }
                  //       //   return null;
                  //       // },

                  //       keyboardType: TextInputType.number,
                  //     inputFormatters: <TextInputFormatter>[
                  //       WhitelistingTextInputFormatter.digitsOnly
                  //       ],
                  //       // autocorrect: true,
                  //       decoration: InputDecoration(
                  //        errorText: _validate ? validatePhone(_phoneController.text) : null,
                  //         hintText: 'Phone Number',
                  //         prefixIcon: Icon(Icons.phone_iphone),
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

                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      width: 320,
                      padding: EdgeInsets.all(2.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          String patttern =
                              r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
                          RegExp regExp = new RegExp(patttern);
                          if (value.length == 0) {
                            return 'Please enter your email';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
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

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: (() => {_checkInfo()}),
                      child: Container(
                        alignment: Alignment.center,
                        width: 180,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.5)),
                          color: color1,
                        ),
                        child: Text("Next",
                            style: kTitleStyle.copyWith(
                                fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
