import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/Auth/signup.dart';
import 'package:tkt/models/favorite.dart';
import 'Database/database_helper.dart';
import './constants.dart';
import 'Screens/Auth/Login/login2.dart';
import 'Screens/Auth/SignUp/signup.dart';
import 'models/categories_model.dart';

String firebase = "12355545";

String customerName = "";
String customerPhone = "";
String customerImage = "";
String customerType = "";
String customerEmail = "";

String phone = "";
String baseUrl = "base url goes here";
var categories;

const String _storageSessions = "recurringSessions";
const String _storagePricing = "recurringPricing";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future saveFav(String title, String description, String organizer,
    String location, String image) async {
  var db = new DatabaseHelper();
  await db
      .saveFav(new Favorite(title, description, organizer, location, image));
  print("finished");
}

Future<List<Category>> queryEvents() async {
  List<Category> arrayCategories = [];
  String url = '$baseUrl/events';

  print(url);
  Map<String, String> headers = {
    "kiv": kiv,
    "ksp": ksp,
    "keyCode": keycode,
  };
  print(headers);

  Response response = await http.get(url, headers: headers);

  String abody = response.body;
  final cbody = json.decode(abody);
  print(cbody);

  if (response.statusCode == 200) {
    var convertedResponse = json.decode(response.body);

    convertedResponse["data"].forEach((data) {
      Category filterEvent = new Category(
        name: data["name"],
        organiser: data['organizer'],
        banner: data['banner'],
        location: data['venue'],
        description: data['description'],
        pricing: data['pricing'],
        sessions: data["sessions"].toList(),
        lat: data["venue_gps_lat"],
        lng: data["venue_gps_lng"],
        venue: data["venue"],
        ticket_types: data["tickets_types"].toList(),
        event_id: data["id"],
        //  start_date : data['sessions'][0]["start_date"],
        //  start_time : data['sessions'][0]["start_time"]
      );
      arrayCategories.add(filterEvent);
    });
    print("this is number of list ${convertedResponse.length}");
  } else {
    print(response.body);
  }
  print("this is the array for event filter $arrayCategories");
  return arrayCategories;
}

Future<String> getkiv() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString('kiv') ?? '';
}

Future<String> getksp() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString('ksp') ?? '';
}

Future<String> getkeycode() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString('keycode') ?? '';
}

Future<bool> setSessionstoPreference(String sessions) async {
  final SharedPreferences prefs = await _prefs;

  return prefs.setString(_storageSessions, sessions);
}

Future<bool> setPricingtoPreference(String pricing) async {
  final SharedPreferences prefs = await _prefs;

  return prefs.setString(_storagePricing, pricing);
}

Future<bool> setNumber(String phonenumber) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString('phoneNumber', phonenumber);
}

Future<void> getNumber() async {
  final SharedPreferences prefs = await _prefs;
  phone = prefs.getString('phoneNumber');
  return;
}

Future<bool> setSessionsNull(String phonenumber) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString('phoneNumber', phonenumber);
}

void showModalLoginSheet(context) {
  const color1 = Color.fromRGBO(92, 72, 213, 0.8);
  const color2 = Color.fromRGBO(161, 69, 219, 0.5);

  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
            color: Colors.white,
            child: new Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.0035,
                    color: Colors.black12),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: Colors.black,
                    //     size: 20,
                    //   ),
                    // ),
                    Spacer(),
                    Icon(
                      Icons.file_upload,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all((Radius.circular(40))),
                        color: Colors.grey.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5.0)
                        ]),
                    child: Icon(Feather.globe, color: Colors.black, size: 25)),
              ),

              SizedBox(height: 2),
              Text(
                "",
                style: TextStyle(
                    fontFamily: "Futura",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.052),
              ),

              SizedBox(height: 2),
              // Text("+233$receiverNum", style: TextStyle(
              //                           fontFamily: "Futura",
              //                           color: Colors.blueGrey,
              //                           fontWeight: FontWeight.w100,

              //                           fontSize: 13
              //                         ),),

              SizedBox(height: MediaQuery.of(context).size.width * 0.052),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Oops SIGNUP to Continue.",
                      style: kTitleStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.040)),
                  Text(
                    " ",
                    style: TextStyle(
                        fontFamily: "Futura",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.075),
                  ),
                ],
              ),

              Text(" EventQix ", style: kSubtitleStyle.copyWith(color: kRed)),

              SizedBox(height: MediaQuery.of(context).size.width * 0.052),

              Text(
                "",
                style: TextStyle(
                    fontFamily: "Futura",
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w100,
                    fontSize: MediaQuery.of(context).size.width * 0.032),
              ),

              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all((Radius.circular(10))),
                  color: Colors.blueGrey[50],
                ),
                child: Text(
                  "",
                  style: TextStyle(
                      fontFamily: "Futura",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.048),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.width * 0.025),

              // Text("Total Amount", style: TextStyle(
              //                           fontFamily: "Futura",
              //                           color: Colors.blueGrey,
              //                           fontWeight: FontWeight.w100,

              //                           fontSize: MediaQuery.of(context).size.width * 0.032
              //                         ),),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget> [
              //     Text("GH₵ ", style: TextStyle(
              //                           fontFamily: "Futura",
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: MediaQuery.of(context).size.width * 0.050
              //                         ),),

              //   ],
              // ),

              SizedBox(height: MediaQuery.of(context).size.width * 0.038),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage2(),
                          ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6.0,
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5.0)
                          ]),
                      child: Text("LOGIN", style: kTitleStyle),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage2(),
                            //Signup
                          ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: color1,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6.0,
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5.0)
                          ]),
                      child: Text("SIGNUP",
                          style: kTitleStyle.copyWith(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ]));
      });
}

void showMessage(context, String message, String header) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                //  image: DecorationImage(
                //           image: AssetImage('assets/images/back4.jpg'),
                //           fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.0,
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "TicketGH",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 4.0, color: color1)),
                              child: Icon(Icons.close,
                                  color: Colors.black, size: 18))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          header,
                          style: TextStyle(
                              fontFamily: "Futura",
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black,
                              letterSpacing: 1.5),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Text("WORRY.", style: TextStyle(
                      //     fontFamily : "Futura",
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 19,
                      //     color : Colors.black45,
                      //     letterSpacing : 1.5
                      //   ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        message,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: color1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Futura"),
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
