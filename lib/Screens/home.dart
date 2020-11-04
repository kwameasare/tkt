import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/Pages/myevents.dart';
import 'Pages/profile.dart';
import 'package:tkt/Screens/Auth/profile.dart';
import 'package:tkt/Screens/CreateEvent/createevent.dart';
import 'package:tkt/Screens/Supporting/favorites.dart';
import 'package:tkt/constants.dart';
import 'package:tkt/testPages/db_test.dart';
import '../testPages/test_add_session.dart';
import 'package:tkt/Screens/mlpage.dart';
import 'package:tkt/Screens/eventDetails.dart';
import 'package:tkt/models/categories_model.dart';
import 'package:tkt/widgets/destination_carousel.dart';
import 'package:tkt/widgets/event_item.dart';
import 'Events/query_category.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
import 'Pages/verify_ticket.dart';
import 'Pages/verifytickets.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

String kiv = "";
String ksp = "";
String keycode = "";
bool customerPresent = false;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var categories;

class _HomeState extends State<Home> {
  Future<List<Category>> _queryEvents() async {
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
          ticket_types: data["ticket_types"].toList(),
          event_id: data["id"],
          //  start_date : data['sessions'][0]["start_date"],
          //  start_time : data['sessions'][0]["start_time"]
        );
        print(data["sessions"]);
        arrayCategories.add(filterEvent);
      });
      print("this is number of list ${convertedResponse.length}");
    } else {
      print(response.body);
    }
    print("this is the array for event filter $arrayCategories");
    return arrayCategories;
  }

  Future makeCustomerCall() async{
    final SharedPreferences prefs = await _prefs;
    var phone = prefs.getString('phoneNumber');
    var _kiv = prefs.getString('kiv');
    var _ksp = prefs.getString('ksp');
    var _keycode = prefs.getString('keycode');

    String trim = "";
    print(phone);

    if(phone == null || phone == "") {
      return;
    } else {
       

      var params = {
        'phoneNum': phone,
        'fireToken': firebase,
        'countryCode': 'gh', 
      };

      Uri url = Uri.parse('$baseUrl/auth/profile?filter=$phone');
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
      print(cbody["data"][0]["name"]);

    if(cbody["statusCode"] == 200 || cbody["statusCode"] == "200") {
        setState(() {
        customerPresent = true;
        customerName = cbody["data"][0]["name"];
        customerPhone = phone.toString();
        customerImage = cbody["data"][0]["photo"];
        customerType = cbody["data"][0]["user_type"];
        customerEmail = cbody["data"][0]["email"];
      });

      print(customerEmail);

       } 

      

      

        

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
  void initState() {
    
    getValue().then((value) {
      setState(() {
        categories = _queryEvents();
      });

      makeCustomerCall();

    });

    
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);

    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [color1, color2])
          ),
      accountName: customerPresent ? Text( customerName,
          style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white))
          : Text('Anonymous',
          style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white)),
      accountEmail: customerPresent ? Text(customerEmail,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)) :
          Text('Anonymous',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)),
      currentAccountPicture: customerPresent ? CircleAvatar(
          backgroundColor: Colors.white, child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                image: DecorationImage(image: NetworkImage(customerImage),
                fit: BoxFit.cover)
              ),
            )

          // child: Image.asset('assets/images/bed.gif'),
          ) : CircleAvatar(
          backgroundColor: Colors.white, child: Icon(Feather.user, color: Colors.black)

          // child: Image.asset('assets/images/bed.gif'),
          ),
    );

    var item1 = new ListTile(
      title: Text('Home',
          style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
      leading: Icon(Feather.home),
      onTap: () {
        Navigator.push(
          context,
          // you change it to OTP() view for IOS version
          MaterialPageRoute(builder: (context) => Home()),
        );
      },
    );
    var item2 = new ListTile(
      title: Text('Favourites',
          style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
      leading: Icon(Icons.favorite),
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Favorites()));
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => AddMoney()));
      },
    );
    var item3 = new ListTile(
      title: Text('Profile',
          style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
      leading: Icon(Feather.user_check),
      onTap: () {
        if(customerPresent) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(customerName, customerPhone, customerImage)));
        } else {
          showModalLoginSheet(context);
        }
        
      },
    );
    // var item4 = new ListTile(title: Text('Banking'), leading: Icon(Feather.share_2), onTap: () {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Bank()));
    // },);
    var item5 = new ListTile(
      title: Text('Tickets',
          style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
      leading: Icon(Icons.question_answer),
      onTap: () {
        // Navigator.push(
        //     context,
        //     // you change it to OTP() view for IOS version
        //     MaterialPageRoute(builder: (context) => Transactions()));
      },
    );
    var item6 = new ListTile(
        title: Text('Create Event',
            style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
        leading: Icon(Icons.add_alert),
        onTap: () {
          Navigator.push(
              context,
              // you change it to OTP() view for IOS version
              MaterialPageRoute(builder: (context) => CreateEvent()));
        });

        var item7 = new ListTile(
        title: Text('My Events',
            style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
        leading: Icon(Icons.event),
        onTap: () {
          Navigator.push(
              context,
              // you change it to OTP() view for IOS version
              MaterialPageRoute(builder: (context) => MyEvents(customerPhone)));
        });

        var item8 = new ListTile(
        title: Text('Verify Events',
            style: kTitleStyle.copyWith(fontSize : ww * 0.038)),
        leading: Icon(Icons.verified_user),
        onTap: () {
          Navigator.push(
              context,
              // you change it to OTP() view for IOS version
              MaterialPageRoute(builder: (context) => AllVerifyTickets(customerPhone)));
        });

     var children = [ 
       drawerHeader,
      item1,
      item2,
      item3,
      // item4,
      item5,
      item6,
      item7,
      item8
       
     ];  
     GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>(); 
    var drawer = new Drawer(child: ListView(children: children));
    return WillPopScope(
      onWillPop: _onBackPressed,
      
      child: Scaffold(
        key: _homeKey,
        /* appBar: AppBar(
          backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  // share(context);
                },
                child: Icon(Feather.power),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("TICKET GH", style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'nunito',
                                fontSize: ww * 0.078,
                                fontWeight: FontWeight.bold))
          ],
        ),
      ), */

      

      drawer: drawer,
      

        backgroundColor: Colors.grey[100],

        // new bottom navigation
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: color1,
          elevation: 4.0,
          icon: const Icon(Icons.add_alert),
          label: const Text(
            'CREATE EVENT',
            style: TextStyle(
                fontFamily: "Raleway",
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEvent()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: hh * 0.07,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Feather.list),
                    onPressed: () {
                      _homeKey.currentState.openDrawer();
                    },
                  ),
                  IconButton(
                    icon: Icon(Feather.user),
                    onPressed: () {

                      if(customerPresent) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(customerName, customerPhone, customerImage)));

                      } else {
                        showModalLoginSheet(context);
                      }
                      
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: ww,
                height: hh * 0.3,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [color1, color2])),
              ),
              Column(
                children: <Widget>[
                  Container(
                      width: ww * 0.9,
                      height: hh * 0.05,
                      margin: EdgeInsets.only(
                        bottom: hh * 0.000,
                        top: hh * 0.07,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            // BoxShadow(
                            //                                   blurRadius: 6.0,
                            //                                   color: Colors.grey.withOpacity(0.2),
                            //                                   spreadRadius: 5.0)
                          ]),
                      child: Container(
                          alignment: Alignment.center,
                          width: ww * 0.8,
                          height: hh * 0.05,
                          child: TextField(
                              decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            hintText: 'Search Events',
                            prefixIcon: Icon(Icons.search),
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'nunito',
                                fontSize: ww * 0.035),
                            border: InputBorder.none,
                          )))),
                  Padding(
                    padding: EdgeInsets.only(left: ww * 0.05, top: hh * 0.02),
                    child: Row(
                      children: <Widget>[
                        Text("Hello, $customerName",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'nunito',
                                fontSize: ww * 0.078,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ww * 0.05),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(Icons.location_on,
                                  color: Colors.white70, size: 14),
                            ),
                            TextSpan(
                              text: "  East Legon, Accra",
                              style: kTitleStyle.copyWith(
                                  fontSize: ww * 0.035,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hh * 0.03),
                  Container(
                    margin: EdgeInsets.only(left: ww * 0.05),
                    height: MediaQuery.of(context).size.height * 0.11,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        buildCategoryItem(
                            "Conference",
                            Icon(Icons.event_seat, size: 30.0, color: color1),
                            1),
                        buildCategoryItem("Seminar",
                            Icon(Icons.mic, size: 30.0, color: color1), 2),
                        buildCategoryItem(
                            "Tradeshow",
                            Icon(Icons.card_giftcard,
                                size: 30.0, color: color1),
                            3),
                        buildCategoryItem("Convention",
                            Icon(Icons.people, size: 30.0, color: color1), 4),
                        buildCategoryItem(
                            "Festival",
                            Icon(Icons.fiber_smart_record,
                                size: 30.0, color: color1),
                            5),
                        buildCategoryItem(
                            "Concert",
                            Icon(Icons.airline_seat_individual_suite,
                                size: 30.0, color: color1),
                            6),
                        buildCategoryItem("Dinner",
                            Icon(Icons.fastfood, size: 30.0, color: color1), 7),
                        buildCategoryItem("Workshop",
                            Icon(Icons.pan_tool, size: 30.0, color: color1), 8),
                        buildCategoryItem(
                            "Rally",
                            Icon(Icons.directions_run,
                                size: 30.0, color: color1),
                            9),
                        buildCategoryItem(
                            "Other",
                            Icon(Icons.devices_other,
                                size: 30.0, color: color1),
                            10),
                        buildCategoryItem("Party",
                            Icon(Icons.people, size: 30.0, color: color1), 11),
                        buildCategoryItem("Tour",
                            Icon(Icons.flag, size: 30.0, color: color1), 12),
                        buildCategoryItem("Tournament",
                            Icon(Icons.gamepad, size: 30.0, color: color1), 13),
                        /*  buildCategoryItem("Sports",
                       Icon(Icons.shopping_basket, size: 30.0, color: color1)
                       ),
                       buildCategoryItem("Game",
                       Icon(Icons.games, size: 30.0, color: color1)
                       ),
                       buildCategoryItem("Club",
                       Icon(Icons.golf_course, size: 30.0, color: color1)
                       ),
                       buildCategoryItem("Awards",
                       Icon(Feather.award, size: 30.0, color: color1)
                       ), */
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: ww * 0.05),
                      child: Text("Popular Events",
                          style: kTitleStyle.copyWith(
                              fontSize: ww * 0.060,
                              color: Color.fromRGBO(175, 167, 194, 1)))),
                  Padding(
                    padding: EdgeInsets.only(right: ww * 0.05),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => QueryCategory(0, "All Events")));

                      },
                                          child: Text("More",
                          style: kTrailingStyle.copyWith(fontSize: ww * 0.035)),
                    ),
                  )
                ],
              ),

              Container(
                height: MediaQuery.of(context).size.width * 0.60,
                child: FutureBuilder(
                  future: categories,
                  builder: (BuildContext context, AsyncSnapshot snapshots) {
                    if (snapshots.hasData) {
                      return RefreshIndicator(
                        onRefresh: () {
                          setState(() {
                            categories = _queryEvents();
                          });

                          return categories;
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return EventItem(
                              name: snapshots.data[index].name,
                              organiser: snapshots.data[index].organiser,
                              banner: snapshots.data[index].banner,
                              location: snapshots.data[index].location,
                              description: snapshots.data[index].description,
                              pricing: snapshots.data[index].pricing,
                              sessions: snapshots.data[index].sessions,
                               lat: snapshots.data[index].lat,
                                lng: snapshots.data[index].lng,
                                 venue: snapshots.data[index].venue,
                                 ticket_types: snapshots.data[index].ticket_types,
                                 event_id: snapshots.data[index].event_id,
                              // start_date: snapshots.data[index].start_date,
                              // start_time: snapshots.data[index].start_time
                            );
                          },
                          itemCount: snapshots.data.length,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              // DestinationCarousel(),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: ww * 0.05),
                      child: Text("Events Around Me",
                          style: kTitleStyle.copyWith(
                              fontSize: ww * 0.060,
                              color: Color.fromRGBO(175, 167, 194, 1)))),
                  Padding(
                    padding: EdgeInsets.only(right: ww * 0.05),
                    child: Text("More",
                        style: kTrailingStyle.copyWith(fontSize: ww * 0.035)),
                  )
                ],
              ),

              // DestinationCarousel()
            ]),
          )
        ]),

        // Old bottom navigation
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   child: Icon(Icons.add_alert, color: color1, size: 30),
        //   shape: CircleBorder(
        //     side: BorderSide(color: color1, width: 4.0),
        //   ),
        //   onPressed: () {
        //     // Navigator.push(context, MaterialPageRoute(builder: (context) => MlPage()));
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => CreateEvent()));
        //   },
        // ),
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   child: Container(
        //       width: ww,
        //       height: 60,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: <Widget>[
        //           MaterialButton(
        //             minWidth: 40,
        //             child: Icon(
        //               Feather.message_circle,
        //               size: 30,
        //               color: color2,
        //             ),
        //           ),
        //           MaterialButton(
        //             minWidth: 40,
        //             child: Icon(Feather.user, size: 30, color: color2),
        //             onPressed: () {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => TestSession()));
        //               // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
        //             },
        //           ),
        //         ],
        //       )),
        // ),
      ),
    );
  }

  buildCategoryItem(String name, Icon iconName, int id) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QueryCategory(id, name)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        height: MediaQuery.of(context).size.height * 0.0,
        width: MediaQuery.of(context).size.width * 0.32,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 6.0,
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5.0)
            ]),
        child: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.030),
              child: iconName,
            ),
            SizedBox(height: 4.0),
            Text(name,
                style: kTitleStyle.copyWith(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ))
          ]),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
              'Exit TicketGH?',
              style: TextStyle(
                fontFamily: "Montserrat",
              ),
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(
                  "NO",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Raleway"),
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: Text(
                  "YES",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Raleway"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
