import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/Auth/SignUp/signup.dart';
import 'package:tkt/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tkt/models/verifier.dart';
import 'package:tkt/widgets/verifier_item.dart';
import '../../utils.dart';
import 'package:share/share.dart';
import 'buyTicket.dart';
import 'package:url_launcher/url_launcher.dart';
ProgressDialog pr;

var verifiers;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class MyEventDetails extends StatefulWidget {
  final String name;
  final String organiser;
  final String banner;
  final String location;
  final String description;
  final String pricing;
  final List sessions;
  final String lat;
  final String lng;
  final String venue;
  final List ticket_types;
  final String event_id;
  // final String start_date;
  // final String start_time;

  const MyEventDetails(
      this.name,
      this.organiser,
      this.banner,
      this.location,
      this.description,
      this.pricing,
      this.sessions,
      this.lat,
      this.lng,
      this.venue,
      this.ticket_types,
      this.event_id);
  //this.start_date, this.start_time
  @override
  _MyEventDetailsState createState() => _MyEventDetailsState();
}

class _MyEventDetailsState extends State<MyEventDetails> {
  Location location = new Location();
  final _phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  void shownInSnackbar(String value) {
    _scaffoldKey2.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }

  @override
  void initState() {
    print(widget.sessions);

    setState(() {
      verifiers = _getVerifiers();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);

      pr.style(message: 'Showing some progress...');

    
    
    //Optional
    pr.style(
          message: 'Confirming..',
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



    return Scaffold(
      key: _scaffoldKey2,
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  share(context);
                },
                child: Icon(Feather.share_2),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              ),
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  // share(context);
                  saveFav(widget.name, widget.description, widget.organiser,
                      widget.location, widget.banner);
                  shownInSnackbar("Successfully Favourited this Event.!!");
                },
                child: Icon(Feather.heart),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              ),
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  // share(context);
                },
                child: Icon(Feather.more_vertical),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              )
        ],
        backgroundColor: color1,
      ),
      body: Column(children: <Widget>[
        Container(
            width: ww,
            height: hh * 0.82,
            child: ListView(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Hero(
                  tag: widget.banner,
                  child: Center(
                    child: ClipRRect(
                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      child: Image.network(
                        widget.banner,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: ww * 0.03, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:
                                          Text(widget.name, style: kTitleStyle),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      widget.location != null
                                          ? Text(
                                              widget.location,
                                              style: kSubtitleStyle,
                                            )
                                          : Text(
                                              "ONLINE",
                                              style: kSubtitleStyle,
                                            )
                                    ],
                                  ),
                                ),
                                // Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       children: <Widget>[
                                //         Text(
                                //           "by: ${widget.organiser}",
                                //           style: kSubtitleStyle
                                //         ),
                                //       ],
                                //     ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              widget.location != null
                                  ? InkWell(
                                      onTap: () async {
                                        var pos = await location.getLocation();

                                        print(pos);
                                        double user_lat = pos.latitude;
                                        double user_lng = pos.longitude;

                                        var url =
                                            'https://www.google.com/maps/dir/?api=1&origin=$user_lat,$user_lng&destination=${widget.lat},${widget.lng}&travelmode=driving&dir_action=navigate';
                                        _launchURL(url);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: ww * 0.05,
                                            vertical: ww * 0.02),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(Feather.arrow_right, size: 15),
                                            Text(
                                              '  LOCATE ON MAP',
                                              style: kTitleStyle.copyWith(
                                                  fontSize: ww * 0.02),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ])
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ww * 0.85,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(widget.description,
                                    style: kSubtitleStyle.copyWith(
                                        height: 1.9,
                                        color: Colors.blueGrey,
                                        fontSize: ww * 0.030)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: ww * 0.038, vertical: ww * 0.01),
                          children: <Widget>[
                            _buildPopUpImage(
                                'assets/images/stmarksbasilica.jpg'),
                            _buildPopUpImage('assets/images/gondola.jpg'),
                            _buildPopUpImage('assets/images/murano.jpg'),
                          ],
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Verifiers',
                            style: kTitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Container(
                        height: hh * 0.25,
                        child: FutureBuilder(
                          future: verifiers,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshots) {
                            if (snapshots.hasData) {
                              return RefreshIndicator(
                                onRefresh: () {
                                  setState(() {
                                    verifiers = _getVerifiers();
                                  });

                                  return verifiers;
                                },
                                child: ListView.builder(
                                  itemCount: snapshots.data.length,
                                  scrollDirection: Axis.vertical,
                                  // shrinkWrap: true,
                                  // physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return VerifyItem(
                                      id: snapshots.data[index].id, 
                                      photo: snapshots.data[index].photo, 
                                      phone: snapshots.data[index].phone,
                                       name: snapshots.data[index].name);
                                  },
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dated Sessions',
                            style: kTitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.sessions.length,
                            itemBuilder: (context, i) {
                              return buildIngredientItem(
                                  (widget.sessions[i]["start_date"])
                                      .substring(0, 10),
                                  (widget.sessions[i]["end_date"])
                                      .substring(0, 10));
                            },
                          )),
                    ),
                  ],
                ),
              )
            ])),
        Expanded(
          child: InkWell(
            onTap: () async {
              _showModalSheet();
            },
            child: Container(
                color: color1,
                child: Center(
                  child: Text(
                    "Add Verifiers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ww * 0.045,
                      fontFamily: 'nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ),
      ]),
    );
  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();

    Share.share('check out my TicketGH website https://example.com',
        subject: 'Pay with smile 🥰 !',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  buildIngredientItem(String bgDate, String name) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.only(right: ww * 0.02),
        child: InkWell(
          onTap: () {},
          child: Column(children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("FROM :",
                              style:
                                  kTrailingStyle.copyWith(fontSize: ww * 0.03)),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(bgDate,
                        style: kTitleStyle.copyWith(
                            fontSize: ww * 0.04, fontWeight: FontWeight.w300)),
                    SizedBox(height: 4.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("TO :",
                              style:
                                  kTrailingStyle.copyWith(fontSize: ww * 0.03)),
                        ],
                      ),
                    ),
                    Text(name,
                        textAlign: TextAlign.center,
                        style: kTitleStyle.copyWith(
                            fontSize: ww * 0.04, fontWeight: FontWeight.w300))
                  ],
                ))),
          ]),
        ));
  }

  buildTicketType(String id, String name) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: ww * 0.05),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BuyTicket(id)));
            },
            child: Container(
              width: ww * 0.50,
              height: ww * 0.12,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6.0,
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5.0),
                  ]),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name,
                      style: kTitleStyle,
                    ),
                    IconButton(
                      icon: Icon(Feather.arrow_right),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  launchMap() async {
    var mapSchema = 'geo:${widget.lat},${widget.lng}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildPopUpImage(String s) {
    return Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.025),
        child: InkWell(
          onTap: () {},
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: AssetImage(s), fit: BoxFit.cover),
              ),
            )
          ]),
        ));
  }

  void _showModalSheet() {
    showModalBottomSheet(
        // isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
              color: Colors.white,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.0035,
                      color: Colors.black12),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all((Radius.circular(40))),
                          color: Colors.grey.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6.0,
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5.0)
                          ]),
                      child:
                          Icon(Icons.account_balance, color: color1, size: 18)),
                ),

                SizedBox(height: 10),
                Text(
                  "Save Verifier? ",
                  style: TextStyle(
                      fontFamily: "Futura",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.040),
                ),

                SizedBox(height: 2),
                // Text("+233$receiverNum", style: TextStyle(
                //                           fontFamily: "Futura",
                //                           color: Colors.blueGrey,
                //                           fontWeight: FontWeight.w100,

                //                           fontSize: 13
                //                         ),),

                SizedBox(height: MediaQuery.of(context).size.width * 0.032),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.width * 0.052),
                          Container(
                            decoration: BoxDecoration(
                                // border: Border(bottom: BorderSide(color: Colors.red),
                                ),
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                prefixIcon: Icon(
                                  Icons.phone_iphone,
                                  color: Colors.black,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "Raleway",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.width * 0.052),

                SizedBox(height: MediaQuery.of(context).size.width * 0.038),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontFamily: "Futura",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.052),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        /*  _pushFavoriteRequest(); */
                        confirmVerifier();
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
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              fontFamily: "Futura",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.052),
                        ),
                      ),
                    )
                  ],
                ),
              ]));
        });
  }

  void confirmRequest() async {

    pr.show();
    final SharedPreferences prefs = await _prefs;
    var _phone = prefs.getString('phoneNumber');
    var _kiv = prefs.getString('kiv');
    var _ksp = prefs.getString('ksp');
    var _keycode = prefs.getString('keycode');
    var trim = "";
    if (_phoneController.text[0] == "0") {
      trim = _phoneController.text.substring(1);
    } else {
      trim = _phoneController.text;
    }

    print(trim);
    Uri url = Uri.parse(
        '$baseUrl/auth/profile?filter=+233$trim');
    // final newURI = url.replace(queryParameters: params);
    Map<String, String> headers = {
      "kiv": _kiv,
      "ksp": _ksp,
      "keyCode": _keycode,
    };

    //   Map<String, dynamic> body = {

    // };
    Response response = await http.get(url, headers: headers);

    String abody = response.body;
    print("printing now");

    final cbody = json.decode(abody);
    print(cbody);
    if (cbody["data"].length != 0) {
      pr.hide();
      var verifierId = cbody["data"][0]["id"];
      print(verifierId);
      String verifyurl = '$baseUrl/verifiers';
      print(url);
      Map<String, String> headers = {
        "kiv": _kiv,
        "ksp": _ksp,
        "keycode": _keycode,
      };
      print(headers);

      Map<String, dynamic> body = {
        "verifier_id": verifierId,
        "event_id": widget.event_id,
        "phone": "233$_phone"
      };
      print(body);
      Response response =
          await http.post(verifyurl, headers: headers, body: body);

      String abody = response.body;
      print(abody);
      var qbody = json.decode(abody);
      print(qbody);
      showMessage(context, qbody["message"], "Congratulations.");
    } else {
      pr.hide();
      setState(() {
        verifiers =_getVerifiers();
        _phoneController.text = "";
      });
      
      showMessage(context, "The number entered is not a valid user.", "Oops..");
    }
  }

  void confirmVerifier() {
    print(_phoneController.text.length);
    if (_phoneController.text.length == 0) {
      showMessage(context, "The number field cannot be empty.", "Oops..");
    } else {
      print("executing...");
      confirmRequest();
    }
  }

  Future<List<Verifier>> _getVerifiers() async {
    List<Verifier> arrayVerifiers = [];
    final SharedPreferences prefs = await _prefs;
    var _phone = prefs.getString('phoneNumber');
    var _kiv = prefs.getString('kiv');
    var _ksp = prefs.getString('ksp');
    var _keycode = prefs.getString('keycode');

    final response = await http.get(
      '$baseUrl/verifiers?filter[event_id]=${widget.event_id}',
      headers: {
        "kiv": _kiv,
        "ksp": _ksp,
        "keycode": _keycode,
      },
    );

    String abody = response.body;
    final cbody = json.decode(abody);
    print(cbody);

    if (response.statusCode == 200) {
      var convertedResponse = json.decode(response.body);

      convertedResponse["data"].forEach((data) {
        Verifier filterVerifier = new Verifier(
            phone: data["user"]["phone"].toString(),
            name: data["user"]["name"],
            photo: data["user"]["photo"],
            id: data["id"]);

        arrayVerifiers.add(filterVerifier);
      });
      print("this is number of list ${convertedResponse.length}");
    } else {
      print(response.body);
    }
    print("this is the array for event filter $arrayVerifiers");
    return arrayVerifiers;
  }
}
